import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class GoogleAICall {
  static Future<ApiCallResponse> call({
    String? lang = '',
    String? token = '',
    String? action = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Google AI',
      apiUrl: 'https://us-central1-ondc-409004.cloudfunctions.net/digitizer',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {
        'lang': lang,
        'action': action,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class AppCall {
  static Future<ApiCallResponse> call({
    String? action = '',
    FFUploadedFile? imageFile,
    FFUploadedFile? audioFile,
    String? uniqueClientId = '',
    String? password = '',
    dynamic? productJson,
    String? lang = '',
    String? text = '',
    String? token = '',
    dynamic? infoJson,
    String? productId = '',
  }) async {
    final product = _serializeJson(productJson);
    final info = _serializeJson(infoJson);

    return ApiManager.instance.makeApiCall(
      callName: 'app',
      apiUrl: 'https://us-central1-ondc-409004.cloudfunctions.net/app',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {
        'action': action,
        'image_file': imageFile,
        'email': uniqueClientId,
        'password': password,
        'product': product,
        'audio_file': audioFile,
        'lang': lang,
        'text': text,
        'info': info,
        'productId': productId,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
