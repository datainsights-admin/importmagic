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

import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

Future<FFUploadedFile> editImage(FFUploadedFile uploadedFile) async {
  final String filePath =
      path.join(Directory.systemTemp.path, uploadedFile.name);

  await File(filePath).writeAsBytes(uploadedFile.bytes!);
  ImageCropper imageCropper = ImageCropper();

  CroppedFile? croppedFile = await imageCropper.cropImage(
      sourcePath: filePath,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      compressQuality: 70,
      compressFormat: ImageCompressFormat.jpg);

  if (croppedFile != null) {
    FFUploadedFile result = new FFUploadedFile(
        name: uploadedFile.name, bytes: await croppedFile.readAsBytes());
    await File(croppedFile.path).delete();
    await File(filePath).delete();
    return result;
  } else {
    await File(filePath).delete();
    return uploadedFile;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
