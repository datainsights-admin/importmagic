from flask import Flask, request, jsonify
from cloud_functions.cloud_func_app import (
    create_user,
    authenticate_user,
    change_password,
    delete_user,
    upload_image,
    upload_audio,
    upload_text,
    edit_product,
    delete_product,
    add_product,
    get_local,
    get_global,
    get_history,
    extract_product_details_from_voice,
    update_user,
    get_user_info
)
from cloud_functions.cloud_func_digitizer import (
    process_drive,
    image_search,
    text_search,
    voice_search
)

app = Flask(__name__)

@app.route('/create-user', methods=['POST'])
def create_user_route():
    form_data = request.form.to_dict()
    response = create_user(form_data)
    return jsonify(response[0]), response[1], response[2]

@app.route('/authenticate-user', methods=['POST'])
def authenticate_user_route():
    form_data = request.form.to_dict()
    response = authenticate_user(form_data)
    return jsonify(response[0]), response[1], response[2]

@app.route('/change-password', methods=['POST'])
def change_password_route():
    response = change_password(request)
    return jsonify(response[0]), response[1], response[2]

@app.route('/delete-user', methods=['POST'])
def delete_user_route():
    verify = verify_token(request)
    response = delete_user(request, verify)
    return jsonify(response[0]), response[1], response[2]

@app.route('/upload-image', methods=['POST'])
def upload_image_route():
    verify = verify_token(request)
    response = upload_image(verify, request.files.get('image_file'))
    return jsonify(response[0]), response[1], response[2]

@app.route('/upload-audio', methods=['POST'])
def upload_audio_route():
    verify = verify_token(request)
    response = upload_audio(verify, request.files.get('audio_file'))
    return jsonify(response[0]), response[1], response[2]

@app.route('/upload-text', methods=['POST'])
def upload_text_route():
    verify = verify_token(request)
    form_data = request.form.to_dict()
    response = upload_text(verify, form_data.get('text'))
    return jsonify(response[0]), response[1], response[2]

@app.route('/edit-products', methods=['POST'])
def edit_product_route():
    verify = verify_token(request)
    form_data = request.form.to_dict()
    response = edit_product(verify, json.loads(form_data.get('product')))
    return jsonify(response[0]), response[1], response[2]

@app.route('/delete-products', methods=['POST'])
def delete_product_route():
    verify = verify_token(request)
    form_data = request.form.to_dict()
    response = delete_product(verify, form_data.get('productId'))
    return jsonify(response[0]), response[1], response[2]

@app.route('/add-products', methods=['POST'])
def add_product_route():
    verify = verify_token(request)
    form_data = request.form.to_dict()
    response = add_product(verify, json.loads(form_data.get('product')))
    return jsonify(response[0]), response[1], response[2]

@app.route('/get-local', methods=['POST'])
def get_local_route():
    verify = verify_token(request)
    form_data = request.form.to_dict()
    response = get_local(form_data, verify)
    return jsonify(response[0]), response[1], response[2]

@app.route('/get-global', methods=['POST'])
def get_global_route():
    form_data = request.form.to_dict()
    response = get_global(form_data)
    return jsonify(response[0]), response[1], response[2]

@app.route('/get-history', methods=['POST'])
def get_history_route():
    verify = verify_token(request)
    response = get_history(verify)
    return jsonify(response[0]), response[1], response[2]

@app.route('/transcribe', methods=['POST'])
def transcribe_route():
    verify = verify_token(request)
    response = extract_product_details_from_voice(request.files.get('audio_file'), request.form.get('lang'))
    return jsonify(response[0]), response[1], response[2]

@app.route('/update-user', methods=['POST'])
def update_user_route():
    verify = verify_token(request)
    response = update_user(request, verify)
    return jsonify(response[0]), response[1], response[2]

@app.route('/get-user-info', methods=['POST'])
def get_user_info_route():
    verify = verify_token(request)
    response = get_user_info(verify)
    return jsonify(response[0]), response[1], response[2]

@app.route('/process-drive', methods=['POST'])
def process_drive_route():
    verify = verify_token(request)
    response = process_drive(request, verify)
    return jsonify(response[0]), response[1], response[2]

@app.route('/image-search', methods=['POST'])
def image_search_route():
    verify = verify_token(request)
    response = image_search(request, verify)
    return jsonify(response[0]), response[1], response[2]

@app.route('/text-search', methods=['POST'])
def text_search_route():
    verify = verify_token(request)
    response = text_search(request, verify)
    return jsonify(response[0]), response[1], response[2]

@app.route('/voice-search', methods=['POST'])
def voice_search_route():
    verify = verify_token(request)
    response = voice_search(request, verify)
    return jsonify(response[0]), response[1], response[2]

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
