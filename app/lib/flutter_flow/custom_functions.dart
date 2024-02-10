import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

List<ProductStruct> getProducts(dynamic response) {
  // Convert JSON array response["json_data"] to List<ProductStruct>
  List<ProductStruct> products = [];

  List<dynamic> jsonList = response["trans_json_data"];

  for (var json in jsonList) {
    ProductStruct product = ProductStruct(
      id: json['id'],
      sourceFile: json['source_file'],
      sourceFolder: json['source_folder'],
      uniqueProductName: json['unique_product_name'],
      brand: json['brand'],
      price: json['price'],
      size: json['size'],
      category: json['category'],
      itemCount: json["item_count"],
      barcode: json["barcode"],
      content: json["content"],
      productDescription: json['product_description'],
    );
    products.add(product);
  }

  return products;
}

List<String> getSource(
  String sources,
  String content,
) {
  List<String> result = List<String>.empty(growable: true);

  for (String filename in sources.split(",")) {
    if (!filename.contains(".txt")) {
      result.add(filename);
    }
  }
  if (content.length > 0) {
    for (String data in content.split(";")) {
      if (data.length > 0) {
        result.add(data);
      }
    }
  }
  return result;
  // check if audio file from filename
}

String getAudioPathFromPath(String filename) {
  return filename;
  // check if audio file from filename
}

List<ProductStruct> getGlobalProducts(dynamic response) {
  // Convert JSON array response["json_data"] to List<ProductStruct>
  List<ProductStruct> products = [];

  List<dynamic> jsonList = response["trans_global_json_data"];

  for (var json in jsonList) {
    ProductStruct product = ProductStruct(
      id: json['id'],
      sourceFile: json['source_file'],
      sourceFolder: json['source_folder'],
      uniqueProductName: json['unique_product_name'],
      brand: json['brand'],
      price: json['price'],
      size: json['size'],
      category: json['category'],
      itemCount: json["item_count"],
      barcode: json["barcode"],
      content: json["content"],
      productDescription: json['product_description'],
    );
    products.add(product);
  }

  return products;
}

List<ProductStruct> getSystemProducts(dynamic response) {
  // Convert JSON array response["json_data"] to List<ProductStruct>
  List<ProductStruct> products = [];

  List<dynamic> jsonList = response["json_data"];

  for (var json in jsonList) {
    ProductStruct product = ProductStruct(
      id: json['id'],
      sourceFile: json['source_file'],
      sourceFolder: json['source_folder'],
      uniqueProductName: json['unique_product_name'],
      brand: json['brand'],
      price: json['price'],
      size: json['size'],
      category: json['category'],
      itemCount: json["item_count"],
      barcode: json["barcode"],
      content: json["content"],
      productDescription: json['product_description'],
    );
    products.add(product);
  }

  return products;
}

List<ProgressStruct> getProgress(dynamic response) {
  // Convert JSON array response["json_data"] to List<ProductStruct>
  List<ProgressStruct> progress = [];

  for (var json in response) {
    ProgressStruct product = ProgressStruct(
        audioUrl: json["data_url"],
        imageUrl: json["data_url"],
        status: json["status"],
        name: json["name"],
        content: json["content"],
        lastUpdateTime: json["last_update_time"],
        response: json["response"]);
    progress.add(product);
  }

  return progress;
}

ProductStruct? getCurrentProduct(
  String productID,
  List<ProductStruct> systemProducts,
) {
  var result = new ProductStruct();
  for (var product in systemProducts) {
    if (product.id == productID) {
      result = product;
    }
  }
  return result;
}

List<ProductStruct> getSystemGlobalProducts(dynamic response) {
  // Convert JSON array response["json_data"] to List<ProductStruct>
  List<ProductStruct> products = [];

  List<dynamic> jsonList = response["global_json_data"];

  for (var json in jsonList) {
    ProductStruct product = ProductStruct(
      id: json['id'],
      sourceFile: json['source_file'],
      sourceFolder: json['source_folder'],
      uniqueProductName: json['unique_product_name'],
      brand: json['brand'],
      price: json['price'],
      size: json['size'],
      category: json['category'],
      itemCount: json["item_count"],
      barcode: json["barcode"],
      content: json["content"],
      productDescription: json['product_description'],
    );
    products.add(product);
  }

  return products;
}

bool? isAudioFile(String filename) {
  // check if audio file from filename
  final audioExtensions = ['mp3', 'wav', 'ogg', 'webm', 'm4a'];
  final extension = filename.split('.').last.toLowerCase();
  return audioExtensions.contains(extension);
}

String getImagePathFromPath(String filename) {
  return filename;
  // check if audio file from filename
}

bool? isImageFile(String filename) {
  // check if audio file from filename
  final audioExtensions = ['png', 'jpg', 'jpeg'];
  final extension = filename.split('.').last.toLowerCase();
  return audioExtensions.contains(extension);
}
