// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

Future<FFUploadedFile> audioPathToUploadedFile(String audioPath) async {
  // Read the audio file as bytes

  if (kIsWeb) {
    final Uint8List bytes = await getUint8ListFromBlobUrl(audioPath);
    final String fileName = audioPath.split('/').last;

    // Create the FFUploadedFile object
    final FFUploadedFile uploadedFile =
        FFUploadedFile(name: fileName, bytes: bytes);
    return uploadedFile;
  } else {
    final File file = File(audioPath);
    final String fileName = file.path.split('/').last;

    // Create the FFUploadedFile object
    final FFUploadedFile uploadedFile =
        FFUploadedFile(name: fileName, bytes: await file.readAsBytes());
    return uploadedFile;
  }
}

Future<Uint8List> getUint8ListFromBlobUrl(String blobUrl) async {
  final response = await http.get(Uri.parse(blobUrl));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to download the file');
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
