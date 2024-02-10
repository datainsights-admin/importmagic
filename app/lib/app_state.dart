import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _uniqueClientId = prefs.getString('ff_uniqueClientId') ?? _uniqueClientId;
    });
    _safeInit(() {
      _sheetUrl = prefs.getString('ff_sheetUrl') ?? _sheetUrl;
    });
    _safeInit(() {
      _products = prefs
              .getStringList('ff_products')
              ?.map((x) {
                try {
                  return ProductStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _products;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_currentProduct')) {
        try {
          final serializedData = prefs.getString('ff_currentProduct') ?? '{}';
          _currentProduct =
              ProductStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _driveFolderLink =
          prefs.getString('ff_driveFolderLink') ?? _driveFolderLink;
    });
    _safeInit(() {
      _driveSheetLink = prefs.getString('ff_driveSheetLink') ?? _driveSheetLink;
    });
    _safeInit(() {
      _globalProducts = prefs
              .getStringList('ff_globalProducts')
              ?.map((x) {
                try {
                  return ProductStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _globalProducts;
    });
    _safeInit(() {
      _language = prefs.getString('ff_language') ?? _language;
    });
    _safeInit(() {
      _systemProducts = prefs
              .getStringList('ff_systemProducts')
              ?.map((x) {
                try {
                  return ProductStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _systemProducts;
    });
    _safeInit(() {
      _progress = prefs
              .getStringList('ff_progress')
              ?.map((x) {
                try {
                  return ProgressStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _progress;
    });
    _safeInit(() {
      _token = prefs.getString('ff_token') ?? _token;
    });
    _safeInit(() {
      _pendingAudioText =
          prefs.getStringList('ff_pendingAudioText') ?? _pendingAudioText;
    });
    _safeInit(() {
      _pendingImages = prefs.getStringList('ff_pendingImages')?.map((x) {
            try {
              return jsonDecode(x);
            } catch (e) {
              print("Can't decode persisted json. Error: $e.");
              return {};
            }
          }).toList() ??
          _pendingImages;
    });
    _safeInit(() {
      _password = prefs.getString('ff_password') ?? _password;
    });
    _safeInit(() {
      _fullName = prefs.getString('ff_fullName') ?? _fullName;
    });
    _safeInit(() {
      _globalSystemProduct = prefs
              .getStringList('ff_globalSystemProduct')
              ?.map((x) {
                try {
                  return ProductStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _globalSystemProduct;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _uniqueClientId = '';
  String get uniqueClientId => _uniqueClientId;
  set uniqueClientId(String _value) {
    _uniqueClientId = _value;
    prefs.setString('ff_uniqueClientId', _value);
  }

  String _sheetUrl = '';
  String get sheetUrl => _sheetUrl;
  set sheetUrl(String _value) {
    _sheetUrl = _value;
    prefs.setString('ff_sheetUrl', _value);
  }

  List<ProductStruct> _products = [];
  List<ProductStruct> get products => _products;
  set products(List<ProductStruct> _value) {
    _products = _value;
    prefs.setStringList(
        'ff_products', _value.map((x) => x.serialize()).toList());
  }

  void addToProducts(ProductStruct _value) {
    _products.add(_value);
    prefs.setStringList(
        'ff_products', _products.map((x) => x.serialize()).toList());
  }

  void removeFromProducts(ProductStruct _value) {
    _products.remove(_value);
    prefs.setStringList(
        'ff_products', _products.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromProducts(int _index) {
    _products.removeAt(_index);
    prefs.setStringList(
        'ff_products', _products.map((x) => x.serialize()).toList());
  }

  void updateProductsAtIndex(
    int _index,
    ProductStruct Function(ProductStruct) updateFn,
  ) {
    _products[_index] = updateFn(_products[_index]);
    prefs.setStringList(
        'ff_products', _products.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInProducts(int _index, ProductStruct _value) {
    _products.insert(_index, _value);
    prefs.setStringList(
        'ff_products', _products.map((x) => x.serialize()).toList());
  }

  ProductStruct _currentProduct =
      ProductStruct.fromSerializableMap(jsonDecode('{}'));
  ProductStruct get currentProduct => _currentProduct;
  set currentProduct(ProductStruct _value) {
    _currentProduct = _value;
    prefs.setString('ff_currentProduct', _value.serialize());
  }

  void updateCurrentProductStruct(Function(ProductStruct) updateFn) {
    updateFn(_currentProduct);
    prefs.setString('ff_currentProduct', _currentProduct.serialize());
  }

  String _driveFolderLink = '';
  String get driveFolderLink => _driveFolderLink;
  set driveFolderLink(String _value) {
    _driveFolderLink = _value;
    prefs.setString('ff_driveFolderLink', _value);
  }

  String _driveSheetLink = '';
  String get driveSheetLink => _driveSheetLink;
  set driveSheetLink(String _value) {
    _driveSheetLink = _value;
    prefs.setString('ff_driveSheetLink', _value);
  }

  List<ProductStruct> _globalProducts = [];
  List<ProductStruct> get globalProducts => _globalProducts;
  set globalProducts(List<ProductStruct> _value) {
    _globalProducts = _value;
    prefs.setStringList(
        'ff_globalProducts', _value.map((x) => x.serialize()).toList());
  }

  void addToGlobalProducts(ProductStruct _value) {
    _globalProducts.add(_value);
    prefs.setStringList('ff_globalProducts',
        _globalProducts.map((x) => x.serialize()).toList());
  }

  void removeFromGlobalProducts(ProductStruct _value) {
    _globalProducts.remove(_value);
    prefs.setStringList('ff_globalProducts',
        _globalProducts.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromGlobalProducts(int _index) {
    _globalProducts.removeAt(_index);
    prefs.setStringList('ff_globalProducts',
        _globalProducts.map((x) => x.serialize()).toList());
  }

  void updateGlobalProductsAtIndex(
    int _index,
    ProductStruct Function(ProductStruct) updateFn,
  ) {
    _globalProducts[_index] = updateFn(_globalProducts[_index]);
    prefs.setStringList('ff_globalProducts',
        _globalProducts.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInGlobalProducts(int _index, ProductStruct _value) {
    _globalProducts.insert(_index, _value);
    prefs.setStringList('ff_globalProducts',
        _globalProducts.map((x) => x.serialize()).toList());
  }

  String _language = 'en-IN';
  String get language => _language;
  set language(String _value) {
    _language = _value;
    prefs.setString('ff_language', _value);
  }

  List<ProductStruct> _systemProducts = [];
  List<ProductStruct> get systemProducts => _systemProducts;
  set systemProducts(List<ProductStruct> _value) {
    _systemProducts = _value;
    prefs.setStringList(
        'ff_systemProducts', _value.map((x) => x.serialize()).toList());
  }

  void addToSystemProducts(ProductStruct _value) {
    _systemProducts.add(_value);
    prefs.setStringList('ff_systemProducts',
        _systemProducts.map((x) => x.serialize()).toList());
  }

  void removeFromSystemProducts(ProductStruct _value) {
    _systemProducts.remove(_value);
    prefs.setStringList('ff_systemProducts',
        _systemProducts.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromSystemProducts(int _index) {
    _systemProducts.removeAt(_index);
    prefs.setStringList('ff_systemProducts',
        _systemProducts.map((x) => x.serialize()).toList());
  }

  void updateSystemProductsAtIndex(
    int _index,
    ProductStruct Function(ProductStruct) updateFn,
  ) {
    _systemProducts[_index] = updateFn(_systemProducts[_index]);
    prefs.setStringList('ff_systemProducts',
        _systemProducts.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInSystemProducts(int _index, ProductStruct _value) {
    _systemProducts.insert(_index, _value);
    prefs.setStringList('ff_systemProducts',
        _systemProducts.map((x) => x.serialize()).toList());
  }

  List<ProgressStruct> _progress = [];
  List<ProgressStruct> get progress => _progress;
  set progress(List<ProgressStruct> _value) {
    _progress = _value;
    prefs.setStringList(
        'ff_progress', _value.map((x) => x.serialize()).toList());
  }

  void addToProgress(ProgressStruct _value) {
    _progress.add(_value);
    prefs.setStringList(
        'ff_progress', _progress.map((x) => x.serialize()).toList());
  }

  void removeFromProgress(ProgressStruct _value) {
    _progress.remove(_value);
    prefs.setStringList(
        'ff_progress', _progress.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromProgress(int _index) {
    _progress.removeAt(_index);
    prefs.setStringList(
        'ff_progress', _progress.map((x) => x.serialize()).toList());
  }

  void updateProgressAtIndex(
    int _index,
    ProgressStruct Function(ProgressStruct) updateFn,
  ) {
    _progress[_index] = updateFn(_progress[_index]);
    prefs.setStringList(
        'ff_progress', _progress.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInProgress(int _index, ProgressStruct _value) {
    _progress.insert(_index, _value);
    prefs.setStringList(
        'ff_progress', _progress.map((x) => x.serialize()).toList());
  }

  String _token = '';
  String get token => _token;
  set token(String _value) {
    _token = _value;
    prefs.setString('ff_token', _value);
  }

  List<String> _pendingAudioText = [];
  List<String> get pendingAudioText => _pendingAudioText;
  set pendingAudioText(List<String> _value) {
    _pendingAudioText = _value;
    prefs.setStringList('ff_pendingAudioText', _value);
  }

  void addToPendingAudioText(String _value) {
    _pendingAudioText.add(_value);
    prefs.setStringList('ff_pendingAudioText', _pendingAudioText);
  }

  void removeFromPendingAudioText(String _value) {
    _pendingAudioText.remove(_value);
    prefs.setStringList('ff_pendingAudioText', _pendingAudioText);
  }

  void removeAtIndexFromPendingAudioText(int _index) {
    _pendingAudioText.removeAt(_index);
    prefs.setStringList('ff_pendingAudioText', _pendingAudioText);
  }

  void updatePendingAudioTextAtIndex(
    int _index,
    String Function(String) updateFn,
  ) {
    _pendingAudioText[_index] = updateFn(_pendingAudioText[_index]);
    prefs.setStringList('ff_pendingAudioText', _pendingAudioText);
  }

  void insertAtIndexInPendingAudioText(int _index, String _value) {
    _pendingAudioText.insert(_index, _value);
    prefs.setStringList('ff_pendingAudioText', _pendingAudioText);
  }

  List<dynamic> _pendingImages = [];
  List<dynamic> get pendingImages => _pendingImages;
  set pendingImages(List<dynamic> _value) {
    _pendingImages = _value;
    prefs.setStringList(
        'ff_pendingImages', _value.map((x) => jsonEncode(x)).toList());
  }

  void addToPendingImages(dynamic _value) {
    _pendingImages.add(_value);
    prefs.setStringList(
        'ff_pendingImages', _pendingImages.map((x) => jsonEncode(x)).toList());
  }

  void removeFromPendingImages(dynamic _value) {
    _pendingImages.remove(_value);
    prefs.setStringList(
        'ff_pendingImages', _pendingImages.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromPendingImages(int _index) {
    _pendingImages.removeAt(_index);
    prefs.setStringList(
        'ff_pendingImages', _pendingImages.map((x) => jsonEncode(x)).toList());
  }

  void updatePendingImagesAtIndex(
    int _index,
    dynamic Function(dynamic) updateFn,
  ) {
    _pendingImages[_index] = updateFn(_pendingImages[_index]);
    prefs.setStringList(
        'ff_pendingImages', _pendingImages.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInPendingImages(int _index, dynamic _value) {
    _pendingImages.insert(_index, _value);
    prefs.setStringList(
        'ff_pendingImages', _pendingImages.map((x) => jsonEncode(x)).toList());
  }

  String _password = '';
  String get password => _password;
  set password(String _value) {
    _password = _value;
    prefs.setString('ff_password', _value);
  }

  String _fullName = '';
  String get fullName => _fullName;
  set fullName(String _value) {
    _fullName = _value;
    prefs.setString('ff_fullName', _value);
  }

  List<ProductStruct> _globalSystemProduct = [];
  List<ProductStruct> get globalSystemProduct => _globalSystemProduct;
  set globalSystemProduct(List<ProductStruct> _value) {
    _globalSystemProduct = _value;
    prefs.setStringList(
        'ff_globalSystemProduct', _value.map((x) => x.serialize()).toList());
  }

  void addToGlobalSystemProduct(ProductStruct _value) {
    _globalSystemProduct.add(_value);
    prefs.setStringList('ff_globalSystemProduct',
        _globalSystemProduct.map((x) => x.serialize()).toList());
  }

  void removeFromGlobalSystemProduct(ProductStruct _value) {
    _globalSystemProduct.remove(_value);
    prefs.setStringList('ff_globalSystemProduct',
        _globalSystemProduct.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromGlobalSystemProduct(int _index) {
    _globalSystemProduct.removeAt(_index);
    prefs.setStringList('ff_globalSystemProduct',
        _globalSystemProduct.map((x) => x.serialize()).toList());
  }

  void updateGlobalSystemProductAtIndex(
    int _index,
    ProductStruct Function(ProductStruct) updateFn,
  ) {
    _globalSystemProduct[_index] = updateFn(_globalSystemProduct[_index]);
    prefs.setStringList('ff_globalSystemProduct',
        _globalSystemProduct.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInGlobalSystemProduct(int _index, ProductStruct _value) {
    _globalSystemProduct.insert(_index, _value);
    prefs.setStringList('ff_globalSystemProduct',
        _globalSystemProduct.map((x) => x.serialize()).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
