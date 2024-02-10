// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProgressStruct extends FFFirebaseStruct {
  ProgressStruct({
    String? name,
    String? response,
    String? status,
    String? content,
    String? lastUpdateTime,
    String? audioUrl,
    String? imageUrl,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _response = response,
        _status = status,
        _content = content,
        _lastUpdateTime = lastUpdateTime,
        _audioUrl = audioUrl,
        _imageUrl = imageUrl,
        super(firestoreUtilData);

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;
  bool hasName() => _name != null;

  // "response" field.
  String? _response;
  String get response => _response ?? '';
  set response(String? val) => _response = val;
  bool hasResponse() => _response != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;
  bool hasStatus() => _status != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  set content(String? val) => _content = val;
  bool hasContent() => _content != null;

  // "lastUpdateTime" field.
  String? _lastUpdateTime;
  String get lastUpdateTime => _lastUpdateTime ?? '';
  set lastUpdateTime(String? val) => _lastUpdateTime = val;
  bool hasLastUpdateTime() => _lastUpdateTime != null;

  // "audioUrl" field.
  String? _audioUrl;
  String get audioUrl => _audioUrl ?? '';
  set audioUrl(String? val) => _audioUrl = val;
  bool hasAudioUrl() => _audioUrl != null;

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;
  bool hasImageUrl() => _imageUrl != null;

  static ProgressStruct fromMap(Map<String, dynamic> data) => ProgressStruct(
        name: data['name'] as String?,
        response: data['response'] as String?,
        status: data['status'] as String?,
        content: data['content'] as String?,
        lastUpdateTime: data['lastUpdateTime'] as String?,
        audioUrl: data['audioUrl'] as String?,
        imageUrl: data['imageUrl'] as String?,
      );

  static ProgressStruct? maybeFromMap(dynamic data) =>
      data is Map ? ProgressStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'response': _response,
        'status': _status,
        'content': _content,
        'lastUpdateTime': _lastUpdateTime,
        'audioUrl': _audioUrl,
        'imageUrl': _imageUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'response': serializeParam(
          _response,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'content': serializeParam(
          _content,
          ParamType.String,
        ),
        'lastUpdateTime': serializeParam(
          _lastUpdateTime,
          ParamType.String,
        ),
        'audioUrl': serializeParam(
          _audioUrl,
          ParamType.String,
        ),
        'imageUrl': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static ProgressStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProgressStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        response: deserializeParam(
          data['response'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        content: deserializeParam(
          data['content'],
          ParamType.String,
          false,
        ),
        lastUpdateTime: deserializeParam(
          data['lastUpdateTime'],
          ParamType.String,
          false,
        ),
        audioUrl: deserializeParam(
          data['audioUrl'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['imageUrl'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ProgressStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProgressStruct &&
        name == other.name &&
        response == other.response &&
        status == other.status &&
        content == other.content &&
        lastUpdateTime == other.lastUpdateTime &&
        audioUrl == other.audioUrl &&
        imageUrl == other.imageUrl;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [name, response, status, content, lastUpdateTime, audioUrl, imageUrl]);
}

ProgressStruct createProgressStruct({
  String? name,
  String? response,
  String? status,
  String? content,
  String? lastUpdateTime,
  String? audioUrl,
  String? imageUrl,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ProgressStruct(
      name: name,
      response: response,
      status: status,
      content: content,
      lastUpdateTime: lastUpdateTime,
      audioUrl: audioUrl,
      imageUrl: imageUrl,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ProgressStruct? updateProgressStruct(
  ProgressStruct? progress, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    progress
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addProgressStructData(
  Map<String, dynamic> firestoreData,
  ProgressStruct? progress,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (progress == null) {
    return;
  }
  if (progress.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && progress.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final progressData = getProgressFirestoreData(progress, forFieldValue);
  final nestedData = progressData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = progress.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getProgressFirestoreData(
  ProgressStruct? progress, [
  bool forFieldValue = false,
]) {
  if (progress == null) {
    return {};
  }
  final firestoreData = mapToFirestore(progress.toMap());

  // Add any Firestore field values
  progress.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getProgressListFirestoreData(
  List<ProgressStruct>? progresss,
) =>
    progresss?.map((e) => getProgressFirestoreData(e, true)).toList() ?? [];
