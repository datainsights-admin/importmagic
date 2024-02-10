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

Future<FFUploadedFile> jsonToUploadedFile(dynamic fileJson) async {
  Uint8List? uint8List = Uint8List.fromList(fileJson["bytes"].cast<int>());
  FFUploadedFile uFile =
      new FFUploadedFile(name: fileJson["name"], bytes: uint8List);
  return uFile;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
