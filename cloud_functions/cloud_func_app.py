import csv
from io import StringIO
from googleapiclient.discovery import build
from google.oauth2 import service_account
import gspread
from google.oauth2 import service_account
from googleapiclient.http import MediaFileUpload, MediaIoBaseUpload
from google.cloud import storage, firestore, speech, translate_v2 as translate
import tempfile
import os
import json
import uuid
import requests
import re
from datetime import datetime
import io
from pydub import AudioSegment
bucket_name = "importmagic"
credential = service_account.Credentials.from_service_account_file(
        'credentials.json', 
        scopes=['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive']
    )
drive_service = build('drive', 'v3')
gc = gspread.authorize(credential)
db = firestore.Client(project="ondc-409004")
headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "*",
    "Access-Control-Allow-Headers": "*",
    "Access-Control-Max-Age": "3600",
}

header = ["id", "source_file", "unique_product_name", "brand", "price", "size", "category", "product_description", "item_count", "barcode"]
headers_text = " unique_product_name, brand, price, size, category, product_description, item_count & barcode "
client = speech.SpeechClient()
firebase_api_key = "AIzaSyDeV24UJKbuDNoj09sn6xbB-w-fZahGu9k"
storage_client = storage.Client()
bucket = storage_client.bucket(bucket_name)
def getUUID():
    res = str(uuid.uuid4())
    res_arr = res.split("-")
    return res_arr[0] + res_arr[1] + res_arr[2] + res_arr[3] + res_arr[4]

def getDataFromBucket(unique_client_id, filename):
    custom_filename = unique_client_id + "/" + filename
    blob = bucket.blob(custom_filename)
    if blob.exists():
        return json.loads(blob.download_as_string())   
    return {}

def saveDataToBucket(unique_client_id, filename, data):
    custom_filename = unique_client_id + "/" + filename
    blob = bucket.blob(custom_filename)
    blob.cache_control = "no-cache"
    blob.upload_from_string(json.dumps(data))

def app_process(request):
    """Creates a Google Drive folder and returns its link.

    Args:
        request (flask.Request): The request object.

    Returns:
        str: The link to the created or existing folder.
    """

    if request.method == "OPTIONS":
    # Allows GET requests from any origin with the Content-Type
    # header and caches preflight response for an 3600s
        return ("", 204, headers)
    
    if request.method == 'POST':
        response = public_action(request)

        if response is None:
            response = private_action(request)

        return response             
        
    return ("", 404, headers)

def public_action(request):
    form_data = request.form.to_dict()
    action = form_data.get('action')

    if action is None:
        return ("No action", 404, headers)

    if action == "create-user":
        return create_user(form_data)
        
    elif action == "authenticate-user":
        return authenticate_user(form_data)
    
    return None
    
def private_action(request):
    verify = verify_token(request)
    
    if isinstance(verify, (dict, list)):
        return verify
    
    form_data = request.form.to_dict()
    action = form_data.get('action')

    if action is None:
       return ("No action", 401, headers)
    
    if not isinstance(verify, (str)):
        return ("No client Id Found", 404, headers)
    
    elif action == "change-password":
        return change_password(request)
    
    elif action == "delete-user":
        return delete_user(request, verify)
    
    elif action == "image-upload":
        return upload_image(verify, request.files.get('image_file'))
        
    elif action == "audio-upload":
        return upload_audio(verify, request.files.get('audio_file'))  
        
    elif action == "text-upload":
        return upload_text(verify, form_data.get('text'))

    elif action == "edit-products":
        return edit_product(verify, json.loads(form_data.get('product')))
    
    elif action == "delete-products":
        return delete_product(verify, form_data.get('productId'))
    
    elif action == "add-products":
        return add_product(verify, json.loads(form_data.get('product')))
    
    elif action == "get-local":
        return get_local(form_data, verify)
    
    elif action == "get-global":
        return get_global(form_data)
    
    elif action == "get-history":
        return get_history(verify)
    
    elif action == "transcribe":
        return extract_product_details_from_voice(request.files.get('audio_file'), form_data.get('lang'))
        
    elif action == "update-user":
        return update_user(request, verify)

    elif action == "get-user-info":
        return get_user_info(verify)
        
    return ("", 404, headers)     

def create_user(form_data):
    unique_client_id = form_data.get('email')
    user_password = form_data.get('password')
    lang = form_data.get('lang')
    try:
        request_url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + firebase_api_key
        request_body = {
            "email": unique_client_id,
            "password": user_password,
            "returnSecureToken": True
        }
        response = requests.post(request_url, json=request_body)
        if response.status_code == 200:
            upload_sheet_url = create_drive_sheet(unique_client_id + "_upload")
            export_sheet_url = create_drive_sheet(unique_client_id)
            upload_folder_url = create_folder(unique_client_id)
            saveDataToBucket(unique_client_id, "file_details.json", {})
            saveDataToBucket(unique_client_id, "products.json", {})
            saveDataToBucket(unique_client_id, "embeddings.json", {})
            saveDataToBucket(unique_client_id, "trans_products.json", {})
            db.collection(unique_client_id).document("info").set({"upload_sheet_url": upload_sheet_url, "upload_folder_url": upload_folder_url, "export_sheet_url": export_sheet_url, "lang": lang})  
            return (response.json()["idToken"], response.status_code, headers) 
        else:
            return (response.json(), response.status_code, headers)
    except Exception as e:
        return (str(e), 400, headers)

def change_password(request):
    try:
        if 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            token = auth_header.split(" ")[1] if len(auth_header.split(" ")) > 1 else None

            if not token:
                return ("Token is missing!", 401, headers)
            
            form_data = request.form.to_dict()
            user_password = form_data.get('password')
            
            request_url = "https://identitytoolkit.googleapis.com/v1/accounts:update?key=" + firebase_api_key
            request_body = {
                "idToken": token,
                "password": user_password,
                "returnSecureToken": True
            }
            response = requests.post(request_url, json=request_body)
            if response.status_code == 200:
               return (response.json()["idToken"], response.status_code, headers)
            else:
                return (response.json(), response.status_code, headers)
        else:
            return ("Authorization header not found", 401, headers)
    except Exception as e:
        return (str(e), 400, headers) 
    
def delete_user(request, unique_client_id):
    try:
        if 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            token = auth_header.split(" ")[1] if len(auth_header.split(" ")) > 1 else None
            request_url = "https://identitytoolkit.googleapis.com/v1/accounts:delete?key=" + firebase_api_key
            request_body = {
                "idToken": token
            }
            response = requests.post(request_url, json=request_body)

            if response.status_code == 200:
                try:
                    spreadsheet = gc.open(unique_client_id)
                    gc.del_spreadsheet(spreadsheet.id)
                except gspread.exceptions.SpreadsheetNotFound:
                    pass

                try:
                    spreadsheet = gc.open(unique_client_id+"_upload")
                    gc.del_spreadsheet(spreadsheet.id)
                except gspread.exceptions.SpreadsheetNotFound:
                    pass

                db.collection(unique_client_id).document("info").delete()
                blobs = list(bucket.list_blobs(prefix=unique_client_id))
                bucket.delete_blobs(blobs)
                
                query = f"name='{unique_client_id}' and mimeType='application/vnd.google-apps.folder'"
                results = drive_service.files().list(q=query, fields="files(id)").execute()
                files = results.get('files', [])
                if files:
                    folder_id = files[0]['id']
                    drive_service.files().delete(fileId=folder_id).execute()

                return ("", response.status_code, headers)
            else:
                return (response.json(), response.status_code, headers)
        else:
            return ("Authorization header not found", 401, headers)
    except Exception as e:
        return (str(e), 400, headers)     

def verify_token(request):
    try:
        if 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            token = auth_header.split(" ")[1] if len(auth_header.split(" ")) > 1 else None

            if not token:
                return ("Token is missing!", 401, headers)
            
            request_url = "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=" + firebase_api_key
            request_body = {
                "idToken": token
            }
            response = requests.post(request_url, json=request_body)
            if response.status_code == 200:
                return response.json()["users"][0]["email"]
            else:
                return ("Token is invalid!", response.status_code, headers)
        else:    
            return ("Authorization header not found", 401, headers)           
    except Exception as e:
        return (str(e), 401, headers) 
    
def authenticate_user(form_data):
    unique_client_id = form_data.get('email')
    user_password = form_data.get('password')
    try:
        request_url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + firebase_api_key
        request_body = {
            "email": unique_client_id,
            "password": user_password,
            "returnSecureToken": True
        }
        response = requests.post(request_url, json=request_body)
        if response.status_code == 200:
            return (response.json()["idToken"], 200, headers)
        else:
            return (response.json(), response.status_code, headers)
    except Exception as e:
        return (str(e), 400, headers)
    
def update_user(request, verify):
    try:
        profile_master = db.collection(verify).document("info")
        form_data = request.form.to_dict()
        profile = json.loads(form_data.get('info')) 
        if profile.get("upload_sheet_url") is not None:
           del profile["upload_sheet_url"]
        if profile.get("upload_folder_url") is not None:
            del profile["upload_folder_url"]
        if profile.get("export_sheet_url") is not None:
           del profile["export_sheet_url"]
        profile_master.update(profile)
        return ("", 200, headers)
    except Exception as e:
        return (str(e), 400, headers)
    
def get_user_info(verify):
    try:
        profile = db.collection(verify).document("info").get().to_dict()
        return (profile, 200, headers)
    except Exception as e:
        return (str(e), 400, headers)  

def edit_product(unique_client_id, product):
    try:
        product["user_modified"] = "true"

        #Add missing keys
        for key in header:
            if key not in product.keys():
                product[key] = ""

        info = db.collection(unique_client_id).document("info").get().to_dict()
        lang = info.get("lang")

        products = getDataFromBucket(unique_client_id, "products.json")
        products[product["id"]] = product

        trans_products = getDataFromBucket(unique_client_id, "trans_products.json")

        if lang not in trans_products.keys():
            trans_products[lang] = {}
        
        for key in trans_products.keys():
            if key == "en-IN":
                new_translation = [product]
            else:
                new_translation = translate_batch([product], lang=lang)
            trans_products[key][product["id"]] = new_translation[0]
        
        saveDataToBucket(unique_client_id, "products.json", products)
        saveDataToBucket(unique_client_id, "trans_products.json", trans_products)
        return (product, 200, headers)
    except Exception as e:
        return (str(e), 400, headers)

def delete_product(unique_client_id, productId):
    products = getDataFromBucket(unique_client_id, "products.json")
    embeddings = getDataFromBucket(unique_client_id, "embeddings.json")
    trans_products = getDataFromBucket(unique_client_id, "trans_products.json")

    if productId in products.keys():
       products.pop(productId)

    if productId in embeddings.keys():
       embeddings.pop(productId)
       
    for key in list(trans_products.keys()):
        if productId in trans_products[key].keys():
           trans_products[key].pop(productId)

    saveDataToBucket(unique_client_id, "products.json", products)
    saveDataToBucket(unique_client_id, "trans_products.json", trans_products)
    saveDataToBucket(unique_client_id, "embeddings.json", embeddings)
    return ("", 200, headers)

def add_product(unique_client_id, product):
    try:
        product["user_modified"] = "true"
        product["id"] = str(getUUID())
        product["barcode"] = product["id"]

        info = db.collection(unique_client_id).document("info").get().to_dict()
        lang = info.get("lang")
        #Add missing keys
        for key in header:
            if key not in product.keys():
                product[key] = ""
        
        products = getDataFromBucket(unique_client_id, "products.json")
        products[product["id"]] = product

        trans_products = getDataFromBucket(unique_client_id, "trans_products.json")

        if lang not in trans_products.keys():
            trans_products[lang] = {}

        for key in trans_products.keys():
            if key == "en-IN":
                new_translation = [product]
            else:
                new_translation = translate_batch([product], lang=lang)
            trans_products[key][product["id"]] = new_translation[0]

        saveDataToBucket(unique_client_id, "products.json", products)
        saveDataToBucket(unique_client_id, "trans_products.json", trans_products)
        return (product, 200, headers)
    except Exception as e:
        return (str(e), 400, headers)
    
def get_content(product):
    prefix_length = len("https://storage.googleapis.com/"+ bucket_name +"/")
    content = ""
    filepaths = product['source_file'].split(",")
    for filepath in filepaths:
        filepath = filepath[prefix_length:]
        if filepath.split(".")[-1] == "txt":
            blob = bucket.blob(filepath)
            if blob.exists():
                content =  blob.download_as_string().decode('utf-8') + ";" + content
    return content

def get_global(form_data):
    lang = form_data.get('lang')

    global_product_map = getDataFromBucket("global", "products.json")
    if global_product_map is None:
        global_product_map = {}

    global_trans_product_map = getDataFromBucket("global", "global_trans_product_map.json")
    if  global_trans_product_map is None:
        global_trans_product_map = {}

    global_product = []
    for key in global_product_map.keys():
        global_product.append(global_product_map[key])

    if lang not in global_trans_product_map.keys():
        global_trans_product_map[lang] = {}


    to_be_translated = []
    for product in global_product:
        if global_trans_product_map[lang].get(product["id"]) is None:
            to_be_translated.append(product)

    if lang == "en-IN":        
        new_translation = global_product
    else:    
        new_translation = translate_batch(to_be_translated, lang=lang)    

    for product in new_translation:
        global_trans_product_map[lang][product["id"]] = product  

    translated_products = []
    for lkey in list(global_trans_product_map.keys()):
        for key in list(global_trans_product_map[lkey].keys()):
            if key not in global_product_map.keys():
                global_trans_product_map[lkey].pop(key)
            elif lkey == lang:
                translated_products.append(global_trans_product_map[lkey][key])

    for item in global_product:
        item['content'] = get_content(item)

    for item in translated_products:
        item['content'] = get_content(item)

    return ({"trans_global_json_data": translated_products, "global_json_data": global_product}, 200, headers)

def get_local(form_data, unique_client_id):
    lang = form_data.get('lang')

    products_map = getDataFromBucket(unique_client_id, "products.json")
    trans_product_map = getDataFromBucket(unique_client_id, "trans_products.json")

    if lang not in trans_product_map.keys():
        trans_product_map[lang] = {}

    products = []
    for key in products_map.keys():
        products.append(products_map[key])

    to_be_translated = []
    for product in products:
        if trans_product_map[lang].get(product["id"]) is None:
            to_be_translated.append(product)

    if lang == "en-IN":        
        new_translation = products
    else:    
        new_translation = translate_batch(to_be_translated, lang=lang)

    for product in new_translation:
        trans_product_map[lang][product["id"]] = product

    translated_products = []
    for lkey in list(trans_product_map.keys()):
        for key in list(trans_product_map[lkey].keys()):
            if key not in products_map.keys():
                trans_product_map[lkey].pop(key)
            elif lkey == lang:
                translated_products.append(trans_product_map[lkey][key])

    for item in products:
        item['content'] = get_content(item)

    for item in translated_products:
        item['content'] = get_content(item)     
               

    return ({"trans_json_data": translated_products, "json_data": products}, 200, headers)

def get_history(unique_client_id):
    file_details = getDataFromBucket(unique_client_id, "file_details.json")
    folder_link = create_folder(unique_client_id)
    folder_id = extract_folder_id_from_link(folder_link)

    response = drive_service.files().list(q=f"'{folder_id}' in parents",fields='files(id, name)').execute()
    files = response.get('files', [])

    for file in files:
        if file['id'] not in file_details.keys():
            file_id = file['id']
            url = f'https://drive.google.com/uc?id={file_id}'
            data_response = requests.get(url)
            data = data_response.content
            file_type = file.get('name').split(".")[-1]  

            file_details[file_id] = dict()
            file_details[file_id]['name'] = file.get('name')
            custom_filename = unique_client_id + "/files/" + file.get('name')
            blob = bucket.blob(custom_filename)
            blob.upload_from_string(data)
            data_url = f"https://storage.googleapis.com/{bucket_name}/{custom_filename}"
            file_details[file_id]['data_url'] = data_url  
            file_details[file_id]['status'] = "uploaded"
            file_details[file_id]['retry_count'] = 0

            if file_type == "txt":
                file_details[file_id]['content'] = data.decode('utf-8')
            else:
                file_details[file_id]['content'] = ""

            now = datetime.now()
            # Convert to string
            date_time_string = now.strftime("%Y-%m-%d %H:%M:%S")
            file_details[file_id]["last_update_time"] = date_time_string

    saveDataToBucket(unique_client_id, "file_details.json", file_details)
    file_details_arr = []
    for key in file_details.keys():
        file_details_arr.append(file_details[key])

    return (file_details_arr, 200, headers)

def create_drive_sheet(sheet_name):
    try:
        spreadsheet = gc.open(sheet_name)
    except gspread.exceptions.SpreadsheetNotFound:
        spreadsheet = gc.create(sheet_name)

    worksheet = spreadsheet.get_worksheet(0)    
    all_values = worksheet.get_all_values()

    if len(all_values) == 0:     
            csv_data = StringIO()
            csv_writer = csv.writer(csv_data)
            csv_writer.writerow(header)
            csv_data.seek(0)
            csv_list = list(csv.reader(csv_data))
            worksheet.append_rows(csv_list)
    spreadsheet.share(None, perm_type='anyone', role='writer')    
    return spreadsheet.url
    
def create_folder(folder_name):
    # Check if the folder already exists
        query = f"name='{folder_name}' and mimeType='application/vnd.google-apps.folder'"
        results = drive_service.files().list(q=query, fields="files(id)").execute()
        files = results.get('files', [])

        if files:
            folder_id = files[0]['id']
            folder_link = f"https://drive.google.com/drive/folders/{folder_id}"
            # Share the folder publicly
            permission = {
                'type': 'anyone',
                'role': 'writer'
            }
            drive_service.permissions().create(fileId=folder_id, body=permission).execute()
            return folder_link

        # Create the folder
        file_metadata = {
            'name': folder_name,
            'mimeType': 'application/vnd.google-apps.folder'
        }
        folder = drive_service.files().create(body=file_metadata, fields='id').execute()
        folder_id = folder.get('id')
        folder_link = f"https://drive.google.com/drive/folders/{folder_id}"

        # Share the folder publicly
        permission = {
            'type': 'anyone',
            'role': 'writer'
        }
        drive_service.permissions().create(fileId=folder_id, body=permission).execute()
        return folder_link

def extract_folder_id_from_link(folder_link):
    # Extract folder ID from the public link
    match = re.search(r'/folders/([a-zA-Z0-9_-]+)', folder_link)
    if match:
        return match.group(1)
    else:
        raise ValueError("Invalid folder link format")

def updateUploadStatus(unique_client_id, file_id, file_name, content):
    url = f'https://drive.google.com/uc?id={file_id}'
    data_response = requests.get(url)
    data = data_response.content
    custom_filename = unique_client_id + "/files/" + file_name
    blob = bucket.blob(custom_filename)
    blob.upload_from_string(data)
    data_url = f"https://storage.googleapis.com/{bucket_name}/{custom_filename}"

    file_details = getDataFromBucket(unique_client_id, "file_details.json")
    file_details[file_id] = dict()
    file_details[file_id]['name'] = file_name
    file_details[file_id]['data_url'] = data_url  
    file_details[file_id]['status'] = "uploaded"
    file_details[file_id]['content'] = content
    file_details[file_id]['response'] = ""
    file_details[file_id]['retry_count'] = 0

    now = datetime.now()
    date_time_string = now.strftime("%Y-%m-%d %H:%M:%S")
    file_details[file_id]["last_update_time"] = date_time_string

    saveDataToBucket(unique_client_id, "file_details.json", file_details)     

def upload_image(folder_name, image_data):
    res = ("", 400, headers)
    temp_file_path = None
    try:
        if image_data is None:
            return ("Image data is required for image upload.", 400, headers)

        folder_link = create_folder(folder_name)

        # Upload the image to the folder
        file_metadata = {
            'name': image_data.filename,
            'parents': [folder_link.split('/')[-1]]  # Use the folder ID as the parent
        }

        # Write BytesIO content to a temporary file
        with tempfile.NamedTemporaryFile(delete=False) as temp_file:
            temp_file.write(image_data.read())
            temp_file_path = temp_file.name

        media = MediaFileUpload(temp_file_path, mimetype=image_data.mimetype)

        # Upload the file
        file = drive_service.files().create(body=file_metadata, media_body=media, fields='id').execute()

        # Return the link to the uploaded image
        image_id = file.get('id')
        image_link = f"https://drive.google.com/file/d/{image_id}"

        # Share the audio file publicly with anyone as a writer
        permission = {
            'type': 'anyone',
            'role': 'writer'
        }
        drive_service.permissions().create(fileId=file['id'], body=permission).execute()
        updateUploadStatus(folder_name, file['id'], image_data.filename, "")
        res = (image_link, 200, headers)
    except Exception as e:
        res = (str(e), 400, headers)
    finally:
        # Clean up: Delete the temporary file
        if temp_file_path:
            os.remove(temp_file_path)
    return res

def upload_audio(folder_name, data):
    res = ("", 400, headers)
    temp_file_path = None
    try:
        if data is None:
              return ("Audio data is required for audio upload.", 400, headers)
        
        # Create or retrieve the folder
        folder_link = create_folder(folder_name)
        filename = data.filename.split(".")[0] + ".wav"

        # Upload the audio file to the folder
        file_metadata = {
            'name': filename,
            'parents': [folder_link.split('/')[-1]]  # Use the folder ID as the parent
        }

        # Write BytesIO content to a temporary file
        with tempfile.NamedTemporaryFile(delete=False) as temp_file:
            temp_file.write(convert_to_wav(data.read()).read())
            temp_file_path = temp_file.name

        media = MediaFileUpload(temp_file_path, mimetype=data.mimetype)

        # Upload the file
        file = drive_service.files().create(body=file_metadata, media_body=media, fields='id').execute()

        # Return the link to the uploaded audio file
        audio_id = file.get('id')
        audio_link = f"https://drive.google.com/file/d/{audio_id}"

        # Share the audio file publicly with anyone as a writer
        permission = {
            'type': 'anyone',
            'role': 'writer'
        }
        drive_service.permissions().create(fileId=file['id'], body=permission).execute()
        updateUploadStatus(folder_name, file['id'], filename, "")
        res = (audio_link, 200, headers)
    except Exception as e:
        res = (str(e), 400, headers)
    finally:
        # Clean up: Delete the temporary file
        if temp_file_path:
            os.remove(temp_file_path)
    return res

def upload_text(folder_name, text_data):
    res = ("", 400, headers)
    temp_file_path = None
    try:
        if text_data is None:
           return ("Text data is required for text upload.", 400, headers)
        # Create or retrieve the folder
        folder_link = create_folder(folder_name)

        file_name = str(getUUID()) + ".txt"
        file_metadata = {'name': file_name, 'parents': [folder_link.split('/')[-1]]}

        temp_file = io.BytesIO()
        temp_file.write(text_data.encode())
        temp_file.seek(0) 
        media = MediaIoBaseUpload(temp_file, mimetype='text/plain', resumable=True)

        # Upload the file
        file = drive_service.files().create(body=file_metadata, media_body=media, fields='id').execute()

        # Return the link to the uploaded image
        image_id = file.get('id')
        image_link = f"https://drive.google.com/file/d/{image_id}"

        # Share the audio file publicly with anyone as a writer
        permission = {
            'type': 'anyone',
            'role': 'writer'
        }
        drive_service.permissions().create(fileId=file['id'], body=permission).execute()
        updateUploadStatus(folder_name, file['id'], file_name, text_data)
        res = (image_link, 200, headers)
    except Exception as e:
        res = (str(e), 400, headers)
    finally:
        # Clean up: Delete the temporary file
        if temp_file_path:
            os.remove(temp_file_path)
    return res

def convert_to_wav(data):
    # Load the audio file
    audio = AudioSegment.from_file(io.BytesIO(data))

    # Use the frame rate, sample width, and channels from the input audio
    wav_audio = audio.set_frame_rate(audio.frame_rate).set_sample_width(audio.sample_width).set_channels(1)

    # Export the WAV file to an in-memory file-like object
    wav_io = io.BytesIO()
    wav_audio.export(wav_io, format="wav")

    # Return the in-memory file-like object
    return wav_io

def extract_product_details_from_voice(tdata, lang):
    try:
        if tdata is None:
            return ("Audio data are required for audio upload.", 400, headers)
        
        if lang is None:
            return ("Language is required for audio transcribe.", 400, headers)
        
        data = convert_to_wav(tdata.read()).read()
        speech_config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        language_code=lang)
        audio = speech.RecognitionAudio(content=data)
        response = client.recognize(config=speech_config, audio=audio)
        response_str = ""
        for result in response.results:
            response_str = response_str + result.alternatives[0].transcript + ","            
        return (response_str, 200, headers)
    except Exception as e:
        return (str(e), 400, headers)           

def translate_batch(products, lang="en-IN"):
    # Initialize the translation client
    translate_client = translate.Client()

    # Batch size for translation
    batch_size = 128

    # Initialize an empty array to store the translated products
    translated_products = []

    # Iterate through batches of products
    for i in range(0, len(products), batch_size):
        batch = products[i:i + batch_size]

        # Translate relevant fields for each product in the batch
        translated_batch = []
        translated_names = translate_client.translate([str(product['unique_product_name']) for product in batch], target_language=lang)
        translated_descriptions = translate_client.translate([str(product['product_description']) for product in batch], target_language=lang)
        
        for product, translated_name, translated_description in zip(batch, translated_names, translated_descriptions):
            new_product = {}
            for key in product.keys():
                new_product[key] = product[key]
            new_product['unique_product_name'] = translated_name['translatedText']
            new_product['product_description'] = translated_description['translatedText']
            translated_batch.append(new_product)

        # Append the translated batch to the overall translated products array
        translated_products.extend(translated_batch)

    return translated_products  