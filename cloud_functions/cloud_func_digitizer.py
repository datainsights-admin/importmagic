from vertexai.preview.generative_models import GenerativeModel, Part
import uuid
from google.cloud import storage, firestore, speech, translate_v2 as translate
import json
from googleapiclient.discovery import build  # For Google Drive API
import requests
import re
import gspread
from google.oauth2 import service_account
import csv
from io import StringIO
from vertexai.preview.language_models import TextEmbeddingModel
import numpy as np
from vertexai.language_models import TextGenerationModel
from datetime import datetime
import io
from pydub import AudioSegment
bucket_name = "importmagic"
credentials = service_account.Credentials.from_service_account_file(
        'credentials.json', 
        scopes=['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive']
    )
gc = gspread.authorize(credentials)
embedding_model = TextEmbeddingModel.from_pretrained("textembedding-gecko")
multimodal_model = GenerativeModel("gemini-pro-vision")
lang_model = TextGenerationModel.from_pretrained("text-bison@001")
gemini_lang_model = GenerativeModel("gemini-pro")
storage_client = storage.Client()
bucket = storage_client.bucket(bucket_name)
drive_service = build('drive', 'v3')
db = firestore.Client(project="ondc-409004")
client = speech.SpeechClient()
# Set CORS headers for the main request
headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "*",
    "Access-Control-Allow-Headers": "*",
    "Access-Control-Max-Age": "3600",
}
header = ["id", "source_file", "unique_product_name", "brand", "price", "size", "category", "product_description", "item_count", "barcode"]
headers_text = " unique_product_name, brand, price, size, category, product_description, item_count & barcode "
firebase_api_key = "AIzaSyDeV24UJKbuDNoj09sn6xbB-w-fZahGu9k"

class VectorSearch:
    def __init__(self, key_vector_mapping=None):
        if key_vector_mapping is None:
            key_vector_mapping = {}
        self.keys = list(key_vector_mapping.keys())
        self.dataset = np.array(list(key_vector_mapping.values()))

    def vector_search(self, query_vector):
        if len(self.dataset) == 0:
            return None
        distances = np.linalg.norm(self.dataset - query_vector, axis=1)
        nearest_neighbor_index = np.argmin(distances)
        nearest_neighbor_key = self.keys[nearest_neighbor_index]
        return nearest_neighbor_key

    def remove_vector(self, key):
        if key in self.keys:
            index_to_remove = self.keys.index(key)
            self.keys.pop(index_to_remove)
            self.dataset = np.delete(self.dataset, index_to_remove, axis=0)

    def add_vector(self, key, vector):
        if len(self.dataset) == 0:
            self.keys.append(key)
            self.dataset = np.array([vector])
        else:
            self.keys.append(key)
            self.dataset = np.vstack([self.dataset, vector])    

def getUUID():
    res = str(uuid.uuid4())
    res_arr = res.split("-")
    return res_arr[0] + res_arr[1] + res_arr[2] + res_arr[3] + res_arr[4]

def extract_folder_id_from_link(folder_link):
    # Extract folder ID from the public link
    match = re.search(r'/folders/([a-zA-Z0-9_-]+)', folder_link)
    if match:
        return match.group(1)
    else:
        raise ValueError("Invalid folder link format")   
     
def clear_sheet(sheet_link):
    try:
        # Extract spreadsheet key from the Google Drive link
        spreadsheet_key = sheet_link.split('/')[-1]

        # Open the Google Sheet
        sheet = gc.open_by_key(spreadsheet_key)

        # Access the first sheet (you can modify this based on your sheet structure)
        worksheet = sheet.get_worksheet(0)

        # Clear the sheet
        worksheet.clear()

        csv_data = StringIO()
        csv_writer = csv.writer(csv_data)
        csv_writer.writerow(header)
        csv_data.seek(0)
        csv_list = list(csv.reader(csv_data))
        worksheet.append_rows(csv_list)

        return True
    except Exception as e:
        return str(e)
      
def sheet_to_json(sheet_link):
    try:
        # Extract spreadsheet key from the Google Drive link
        spreadsheet_key = sheet_link.split('/')[-1]

        # Open the Google Sheet
        sheet = gc.open_by_key(spreadsheet_key)

        # Access the first sheet (you can modify this based on your sheet structure)
        worksheet = sheet.get_worksheet(0)

        # Get all values from the sheet
        all_values = worksheet.get_all_values()

        if len(all_values) < 2:
            return []

        # Extract header and data separately
        header = all_values[0]
        data = all_values[1:]

        # Convert rows to JSON objects
        json_array = []
        for row in data:
            json_object = dict(zip(header, row))
            json_array.append(json_object)

        for item in json_array:
            item["user_modified"] = "false"
            item["id"] = getUUID()
            item["source_file"] = "sheet"
            item["source_folder"] = "sheet"   

        return json_array
    except Exception as e:
        return str(e)

def translate_text(target: str, text: str) -> dict:
    translate_client = translate.Client()
    result = translate_client.translate(text, target_language=target)
    return result["translatedText"]

def getProductForEmbedding(product):
    res = "unique_product_name is " + str(product["unique_product_name"])
    res = res + " brand is " + str(product["brand"])
    res = res + " price is " + str(product["price"])
    res = res + " size is " + str(product["size"])
    res = res + " category is " + str(product["category"])
    res = res + " product_description is " + str(product["product_description"])
    return res

def getProductForLLModel(product):
    return json.dumps({"unique_product_name": product["unique_product_name"],
                        "brand": product["brand"], "price": product["price"],
                          "size": product["size"], "category": product["category"], 
                          "product_description": product["product_description"]})

def extract_product_details_from_image(data):
    # Extract product details from the image
    try:
        response = multimodal_model.generate_content(
            [
                Part.from_data(data, "image/png"),
                "Identify" + headers_text + "for all products present in image.",
                "product_description length should not be more than 100 characters.",
                "Do not identify duplicate products.",
                "Strictly give output only in JSON array format without any other text"
            ]
        )
        if (response.candidates[0].finish_reason == 2): # enum MAX_TOKEN = 2
            raise Exception("Invalid Image: Too much products in the image")
        json_array_pattern = r'\[.*?\]'
        json_data = json.loads(re.findall(json_array_pattern, response.candidates[0].text, re.DOTALL)[0])
        return json_data

    except Exception as e:
        return str(e)
    
def extract_product_details_from_text(data):
    # Extract product details from the text
    response_str = translate_text('en-IN', data)  
    try:
        response = gemini_lang_model.generate_content(
             [
            "Given a text spoken by an individual about a grocery product/s",
            "Text:" + response_str,
            "Identify" + headers_text + "of the grocery product/s present in Text",
            "product_description length should not be more than 100 characters.",
            "Do not identify duplicate products.",
            "Strictly give output only in JSON array format without any other text"
            ]
        )
        if (response.candidates[0].finish_reason == 'FINISH_REASON_MAX_TOKENS'):
            raise Exception("Too much products in the image")
        json_array_pattern = r'\[.*?\]'
        json_data = json.loads(re.findall(json_array_pattern, response.candidates[0].text, re.DOTALL)[0])
        return json_data

    except Exception as e:
        return str(e)    

def extract_product_details_from_voice(data, lang="en-IN"):
    # Extract product details from the image
    try:
        speech_config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        language_code=lang)
        audio = speech.RecognitionAudio(content=data)
        response = client.recognize(config=speech_config, audio=audio)
        response_str = ""
        for result in response.results:
            response_str = response_str + result.alternatives[0].transcript + ","  
        response_str = translate_text('en-IN', response_str)          
        gemini_response = gemini_lang_model.generate_content(
             [
            "Given a text spoken by an individual about a grocery product/s",
            "Text:" + response_str,
            "Identify" + headers_text +"of the grocery product/s present in Text",
            "product_description length should not be more than 100 characters.",
            "Do not identify duplicate products.",
            "Strictly give output only in JSON array format without any other text"
            ]
        )
        if (response.candidates[0].finish_reason == 'FINISH_REASON_MAX_TOKENS'):
            raise Exception("Too much products in the image")
        json_array_pattern = r'\[.*?\]'
        json_data = json.loads(re.findall(json_array_pattern, gemini_response.candidates[0].text, re.DOTALL)[0])
        return json_data
    except Exception as e:
        return str(e)

def check_if_same_product(item, nearestItem):
    try:
        ques = '''
                I've extracted details of 2 grocery products in json format from their images. 
                Grocery Product 1 - ''' + getProductForLLModel(item) + '''
                Grocery Product 2 - ''' + getProductForLLModel(nearestItem) + '''
                If both represent same grocery product then say 'SAME'. Otherwise say 'DIFF'.
                - Different variation of same product should be considered as different product.
                - General or unspecified variant should be considered as same product.
                '''
        response = lang_model.predict(ques, max_output_tokens=1024)
        return response.text == "SAME"
    except Exception as e:
        return False

def merge_if_duplicate(item, nearestItem):
    try:
        ques = '''
                I've extracted details of 2 grocery products in json format from their images. 
                Grocery Product 1 - ''' + getProductForLLModel(item) + '''
                Grocery Product 2 - ''' + getProductForLLModel(nearestItem) + '''
                If both represent same grocery product then say 'SAME'. Otherwise say 'DIFF'.
                - Different variation of same product should be considered as different product.
                - General or unspecified variant should be considered as same product.
                '''
        response = lang_model.predict(ques, max_output_tokens=1024)
        if response.text == "DIFF":
            return [item, nearestItem]
        else:
            ques = '''
                Given 2 grocery products in json format that actually represent a same product. 
                Grocery Product 1 - ''' + getProductForLLModel(item) + '''
                Grocery Product 2 - ''' + getProductForLLModel(nearestItem) + '''
                Merge then into a single json.
                Strictly give output only in JSON format without any other text.
                '''
            response = lang_model.predict(ques, max_output_tokens=1024)
            json_data = json.loads(response.text)
            json_data['id'] = getUUID()
            json_data["barcode"] = json_data["id"]
            json_data["user_modified"] = "false"
            source_set = set(item["source_file"].split(",") + nearestItem["source_file"].split(","))
            json_data["source_file"] = ",".join(source_set)
            return  [json_data]  
    except Exception as e:
        return [item, nearestItem]

def is_grocery_image(data):
    try:
        response = multimodal_model.generate_content(
             [
                 Part.from_data(data, "image/png"),
                 "If image contains any grocery product say 'yes' otherwise say 'no'.",
                 "Strictly give output 'yes' or 'no' without any other text.",
             ]
        )
        ans = re.findall(r'\byes|no\b', response.candidates[0].text, re.IGNORECASE)[0]
        return ans == "yes"
    except Exception as e:
        return False

def addEmbeddingForNewProduct(new_products, embedding_map):
    # Extract values from the dictionary and convert it to a list of products   
    generated_product_embeddings = []
    for i in range(0, len(new_products), 5):
        batch_products = new_products[i:i + 5]

        # Create string representations for the current batch of products
        batch_product_str = [getProductForEmbedding(product) for product in batch_products]

        # Get embeddings for the current batch of string representations
        batch_embeddings = embedding_model.get_embeddings(batch_product_str)

        # Extend the list of embeddings
        generated_product_embeddings.extend(batch_embeddings)  
    i = 0
    for product in new_products:
        embedding_map[product['id']] = generated_product_embeddings[i].values
        i += 1   
    return embedding_map   

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

def getNewProductsFromSource(folder_id, unique_client_id, file_details, lang="en-IN"):
    # Get the list of image files in the folder
    response = drive_service.files().list(q=f"'{folder_id}' in parents",fields='files(id, name)').execute()
    files = response.get('files', [])

    pending_file_ids = []
    new_products = []
    
    for file in files:
        file_id = file['id']
        text = "" 
        if file_id in file_details:
            if file_details[file_id]['status'] == "processed" or file_details[file_id]['status'] == "error":
                continue

        url = f'https://drive.google.com/uc?id={file_id}'
        data_response = requests.get(url)
        data = data_response.content
        file_type = file.get('name').split(".")[-1]

        if file_id not in file_details:
            file_details[file_id] = dict()
            file_details[file_id]['name'] = file['name']
            custom_filename = unique_client_id + "/files/" + file['name']
            blob = bucket.blob(custom_filename)
            blob.upload_from_string(data)
            data_url = f"https://storage.googleapis.com/{bucket_name}/{custom_filename}"
            file_details[file_id]['data_url'] = data_url

        if file_type == "wav" or file_type == "mp3" or file_type == "ogg"  or file_type == "webm" or file_type == "m4a":
            response = extract_product_details_from_voice(convert_to_wav(data).read(), lang=lang)
        elif file_type == "png" or file_type == "jpg" or file_type == "jpeg":
            if not is_grocery_image(data):
                response = "Not a grocery image"  
            else:
                response = extract_product_details_from_image(data)
        elif file_type == "txt":
            text = data.decode("utf-8")
            response = extract_product_details_from_text(text)     
        if text:
            file_details[file_id]['content'] = text
        else:
            file_details[file_id]['content'] = ""  
            
        if isinstance(response, (dict, list)): 
            pending_file_ids.append(file_id)
            for current_item in response:
                current_item["source_file"] = file_details[file_id]['data_url']
                current_item["id"] = getUUID()
                current_item["barcode"] = current_item["id"]
                current_item["user_modified"] = "false"
                if not isinstance(current_item["item_count"], str): 
                    current_item["item_count"] = str(current_item["item_count"]) 
                if not isinstance(current_item["price"], str):
                    current_item["price"] = str(current_item["price"])   
                new_products.append(current_item)
                
            file_details[file_id]['status'] = "pending"      
                        
        else:
            file_details[file_id]['response'] = response
            file_details[file_id]['status'] = "error" 
            # Get current date and time

        now = datetime.now()
        # Convert to string
        date_time_string = now.strftime("%Y-%m-%d %H:%M:%S")
        file_details[file_id]["last_update_time"] = date_time_string

    saveDataToBucket(unique_client_id, "file_details.json", file_details)

    return {
        "file_details": file_details,
        "pending_file_ids": pending_file_ids,
        "new_products": new_products
    }    

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

def update_data_to_sheet(sheet_name, data):
        # Create/Get the global spreadsheet
    try:
        spreadsheet = gc.open(sheet_name)
    except gspread.exceptions.SpreadsheetNotFound:
        spreadsheet = gc.create(sheet_name)

    # Create a permission to share with anyone (use with caution)
    spreadsheet.share(None, perm_type='anyone', role='writer')  

    # Get the first global worksheet
    worksheet = spreadsheet.get_worksheet(0)

    csv_data = StringIO()
    csv_writer = csv.writer(csv_data)
    csv_writer.writerow(header)

    for key in data.keys():
        value = data[key]
        csv_writer.writerow([value.get(keyi, "") for keyi in header])   

    csv_data.seek(0)
    csv_list = list(csv.reader(csv_data))
    worksheet.clear()
    worksheet.append_rows(csv_list)
    return spreadsheet.url          

def compute_local_store(unique_client_id, folder_link, sheet_products, lang="en-IN"):
    # Extract the folder ID from the link
    folder_id = extract_folder_id_from_link(folder_link)

    # Get data from local store
    embedding_map = getDataFromBucket(unique_client_id, "embeddings.json")
    products_map = getDataFromBucket(unique_client_id, "products.json")
    file_details = getDataFromBucket(unique_client_id, "file_details.json")
    index = VectorSearch(embedding_map) 

    # Get new data from source   
    new_data = getNewProductsFromSource(folder_id, unique_client_id, file_details, lang=lang) 
    file_details = new_data['file_details']
    pending_file_ids = new_data['pending_file_ids']
    new_products = new_data['new_products'] + sheet_products   

    # Add embeddings for new products
    embedding_map = addEmbeddingForNewProduct(new_products, embedding_map)      
    
    for current_item in new_products:
        embedding = embedding_map[current_item['id']]
        match = index.vector_search(np.array(embedding))
        if match is not None:
            nearest_item = products_map[match]
            if current_item['user_modified'] == "true" and nearest_item['user_modified'] == "true":
                continue
            merge_response = merge_if_duplicate(current_item, nearest_item)
            if len(merge_response) == 1:
                non_duplicate_item = merge_response[0]
                if products_map.get(nearest_item['id']) and nearest_item['user_modified'] != "true":
                    products_map.pop(nearest_item['id'])
                    embedding_map.pop(nearest_item['id']) 
                    index.remove_vector(nearest_item['id'])
            else:
                non_duplicate_item = current_item    
            
            products_map[non_duplicate_item['id']] = non_duplicate_item
            if embedding_map.get(non_duplicate_item['id']):
                non_duplicate_item_embedding = embedding_map[non_duplicate_item['id']]
            else:
                non_duplicate_item_embedding = embedding_model.get_embeddings([getProductForEmbedding(non_duplicate_item)])[0].values
            embedding_map[non_duplicate_item['id']] = non_duplicate_item_embedding
            index.add_vector(non_duplicate_item['id'], np.array(non_duplicate_item_embedding))
        else:
           products_map[current_item['id']] = current_item
           index.add_vector(current_item['id'], np.array(embedding))

    for file_id in pending_file_ids:
        # Get current date and time
        now = datetime.now()
        # Convert to string
        date_time_string = now.strftime("%Y-%m-%d %H:%M:%S")
        file_details[file_id]["last_update_time"] = date_time_string
        file_details[file_id]['status'] = "processed"

    return {
        "file_details": file_details,
        "products_map": products_map,
        "embedding_map": embedding_map,
        "index": index
    }

def save_local_store(unique_client_id, products_map, file_details, embedding_map):
    update_data_to_sheet(unique_client_id, products_map)
    to_be_saved_embeddings = {}
    for key in embedding_map.keys():
        if key in products_map.keys():
            to_be_saved_embeddings[key] = embedding_map[key] 

    saveDataToBucket(unique_client_id, "file_details.json", file_details)
    saveDataToBucket(unique_client_id, "products.json", products_map)
    saveDataToBucket(unique_client_id, "embeddings.json", to_be_saved_embeddings)

def compute_global_store(products_map, embedding_map, index: VectorSearch):
    global_products_map = getDataFromBucket("global", "products.json")
    global_embedding_map = getDataFromBucket("global", "embeddings.json")
    global_index = VectorSearch(global_embedding_map)

    product_keys = list(products_map.keys())
    for key in product_keys:
        current_item = products_map[key]
        product_embedding = embedding_map[key]
        match = global_index.vector_search(np.array(product_embedding))
        if match is not None:
            nearest_item = global_products_map[match]
            merge_response = merge_if_duplicate(current_item, nearest_item)
            if len(merge_response) == 1:
                global_products_map.pop(nearest_item['id'])
                global_embedding_map.pop(nearest_item['id']) 
                global_index.remove_vector(nearest_item['id'])
                non_duplicate_item = merge_response[0]
            else:
                non_duplicate_item = current_item       
            
            global_products_map[non_duplicate_item['id']] = non_duplicate_item

            if  embedding_map.get(non_duplicate_item['id']):
                non_duplicate_item_embedding =  embedding_map[non_duplicate_item['id']]
            else:    
                non_duplicate_item_embedding = embedding_model.get_embeddings([getProductForEmbedding(non_duplicate_item)])[0].values

            if current_item['user_modified'] != "true":
                if products_map.get(current_item['id']):    
                    products_map.pop(current_item['id'])
                    embedding_map.pop(current_item['id'])
                    index.remove_vector(current_item['id']) 
                products_map[non_duplicate_item['id']] = non_duplicate_item
                embedding_map[non_duplicate_item['id']] = non_duplicate_item_embedding
                index.add_vector(non_duplicate_item['id'], np.array(non_duplicate_item_embedding))

            global_embedding_map[non_duplicate_item['id']] = non_duplicate_item_embedding
            global_index.add_vector(non_duplicate_item['id'], np.array(non_duplicate_item_embedding))
        else:
            global_products_map[current_item['id']] = current_item
            global_embedding_map[current_item['id']] = product_embedding
            global_index.add_vector(current_item['id'], np.array(product_embedding))
               
    return {
        "products_map": products_map,
        "embedding_map": embedding_map,
        "global_products_map": global_products_map,
        "global_embedding_map": global_embedding_map,
    }

def save_global_store(global_products_map, global_embedding_map):
    url = update_data_to_sheet("global", global_products_map)
    to_be_saved_embeddings = {}
    for key in global_embedding_map.keys():
        if key in global_products_map.keys():
            to_be_saved_embeddings[key] = global_embedding_map[key]        

    custom_filename = "global" + "/embeddings.json"
    blob = bucket.blob(custom_filename)
    blob.upload_from_string(json.dumps(to_be_saved_embeddings))

    custom_filename = "global" + "/products.json"
    blob = bucket.blob(custom_filename)
    blob.upload_from_string(json.dumps(global_products_map))     

    db.collection("global").document("info").set({"spreadsheet_url" : url}) 

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

def process_drive(request, verify):
    form_data = request.form.to_dict()
    lang = form_data.get('lang')

    info = db.collection(verify).document("info").get().to_dict()
    folder_link = info.get('upload_folder_url')
    sheet_link = info.get('upload_sheet_url')

    sheet_products = sheet_to_json(sheet_link)
    if isinstance(sheet_products, str):
        return ("Sheet Link Error: " + sheet_products, 400, headers) 

    # Compute the local store
    local_res = compute_local_store(verify, folder_link, sheet_products, lang)

    # Update the global store
    global_res = compute_global_store(local_res['products_map'], local_res['embedding_map'], local_res['index'])

    # Save the global store
    save_global_store(global_res['global_products_map'], global_res['global_embedding_map'])

    # Save the local store
    save_local_store(verify, global_res['products_map'], local_res['file_details'], global_res['embedding_map'])

    #Clear the sheet
    if sheet_link is not None and len(sheet_link) > 0:
        clear_sheet(sheet_link)
    return ("", 200, headers)

def getmatchedProducts(unique_client_id, search_products):

    search_embeddings = addEmbeddingForNewProduct(search_products, search_embeddings)
    matched_products = {}

    product_master = db.collection(unique_client_id).document("info").get().to_dict()
    products_map = product_master.get('products')
    if products_map is None:
        products_map = {}
        
    embeddings_map = product_master.get('embeddings')
    if embeddings_map is None:
        embeddings_map = {}

    index = VectorSearch(embeddings_map)
        
    for current_item in search_products:
        embedding = search_embeddings[current_item['id']]
        match = index.vector_search(np.array(embedding))
        if match is not None:
            nearest_item = products_map[match]
            merge_response = check_if_same_product(current_item, nearest_item)
            if len(merge_response) == 1:
                matched_products[nearest_item['id']] = nearest_item

    return matched_products

def image_search(request, verify):
    file = request.files['file']
    data = file.read()
    response = extract_product_details_from_image(data)
    if isinstance(response, (dict, list)):
        matched_products = getmatchedProducts(verify, response)
        return (matched_products, 200, headers)
    return ({}, 200, headers)

def text_search(request, verify):
    form_data = request.form.to_dict()
    text = form_data.get('text')
    response = extract_product_details_from_text(text)
    if isinstance(response, (dict, list)):
        matched_products = getmatchedProducts(verify, response)
        return (matched_products, 200, headers)
    return ({}, 200, headers)

def voice_search(request, verify):
    file = request.files['file']
    data = file.read()
    response = extract_product_details_from_voice(convert_to_wav(data).read())
    if isinstance(response, (dict, list)):
        matched_products = getmatchedProducts(verify, response)
        return (matched_products, 200, headers)
    return ({}, 200, headers)        
        
def digitizer(request):
    # Set CORS headers for the preflight request
    if request.method == "OPTIONS":
        # Allows GET requests from any origin with the Content-Type
        # header and caches preflight response for an 3600s
        return ("", 204, headers)
    
    if request.method == 'POST':

        verify = verify_token(request)
    
        if isinstance(verify, (dict, list)):
            return verify
        
        if not isinstance(verify, (str)):
            return ("No client Id Found", 404, headers)
        
        form_data = request.form.to_dict()
        action = form_data.get('action')

        if action is None:
            return ("Invalid action", 400, headers)

        if action == "process-drive":
            return process_drive(request, verify)
        
        elif action == "image-search":
            return image_search(request, verify)
        
        elif action == "text-search":
            return text_search(request, verify)
        
        elif action == "voice-search":
            return voice_search(request, verify)

        return ("", 404, headers)  
    