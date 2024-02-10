// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProductStruct extends FFFirebaseStruct {
  ProductStruct({
    String? brand,
    String? category,
    String? productDescription,
    String? uniqueProductName,
    String? size,
    String? sourceFile,
    String? sourceFolder,
    String? price,
    String? barcode,
    String? itemCount,
    String? id,
    String? content,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _brand = brand,
        _category = category,
        _productDescription = productDescription,
        _uniqueProductName = uniqueProductName,
        _size = size,
        _sourceFile = sourceFile,
        _sourceFolder = sourceFolder,
        _price = price,
        _barcode = barcode,
        _itemCount = itemCount,
        _id = id,
        _content = content,
        super(firestoreUtilData);

  // "brand" field.
  String? _brand;
  String get brand => _brand ?? '';
  set brand(String? val) => _brand = val;
  bool hasBrand() => _brand != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;
  bool hasCategory() => _category != null;

  // "product_description" field.
  String? _productDescription;
  String get productDescription => _productDescription ?? '';
  set productDescription(String? val) => _productDescription = val;
  bool hasProductDescription() => _productDescription != null;

  // "unique_product_name" field.
  String? _uniqueProductName;
  String get uniqueProductName => _uniqueProductName ?? '';
  set uniqueProductName(String? val) => _uniqueProductName = val;
  bool hasUniqueProductName() => _uniqueProductName != null;

  // "size" field.
  String? _size;
  String get size => _size ?? '';
  set size(String? val) => _size = val;
  bool hasSize() => _size != null;

  // "source_file" field.
  String? _sourceFile;
  String get sourceFile => _sourceFile ?? '';
  set sourceFile(String? val) => _sourceFile = val;
  bool hasSourceFile() => _sourceFile != null;

  // "source_folder" field.
  String? _sourceFolder;
  String get sourceFolder => _sourceFolder ?? '';
  set sourceFolder(String? val) => _sourceFolder = val;
  bool hasSourceFolder() => _sourceFolder != null;

  // "price" field.
  String? _price;
  String get price => _price ?? '';
  set price(String? val) => _price = val;
  bool hasPrice() => _price != null;

  // "barcode" field.
  String? _barcode;
  String get barcode => _barcode ?? '';
  set barcode(String? val) => _barcode = val;
  bool hasBarcode() => _barcode != null;

  // "item_count" field.
  String? _itemCount;
  String get itemCount => _itemCount ?? '';
  set itemCount(String? val) => _itemCount = val;
  bool hasItemCount() => _itemCount != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;
  bool hasId() => _id != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  set content(String? val) => _content = val;
  bool hasContent() => _content != null;

  static ProductStruct fromMap(Map<String, dynamic> data) => ProductStruct(
        brand: data['brand'] as String?,
        category: data['category'] as String?,
        productDescription: data['product_description'] as String?,
        uniqueProductName: data['unique_product_name'] as String?,
        size: data['size'] as String?,
        sourceFile: data['source_file'] as String?,
        sourceFolder: data['source_folder'] as String?,
        price: data['price'] as String?,
        barcode: data['barcode'] as String?,
        itemCount: data['item_count'] as String?,
        id: data['id'] as String?,
        content: data['content'] as String?,
      );

  static ProductStruct? maybeFromMap(dynamic data) =>
      data is Map ? ProductStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'brand': _brand,
        'category': _category,
        'product_description': _productDescription,
        'unique_product_name': _uniqueProductName,
        'size': _size,
        'source_file': _sourceFile,
        'source_folder': _sourceFolder,
        'price': _price,
        'barcode': _barcode,
        'item_count': _itemCount,
        'id': _id,
        'content': _content,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'brand': serializeParam(
          _brand,
          ParamType.String,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'product_description': serializeParam(
          _productDescription,
          ParamType.String,
        ),
        'unique_product_name': serializeParam(
          _uniqueProductName,
          ParamType.String,
        ),
        'size': serializeParam(
          _size,
          ParamType.String,
        ),
        'source_file': serializeParam(
          _sourceFile,
          ParamType.String,
        ),
        'source_folder': serializeParam(
          _sourceFolder,
          ParamType.String,
        ),
        'price': serializeParam(
          _price,
          ParamType.String,
        ),
        'barcode': serializeParam(
          _barcode,
          ParamType.String,
        ),
        'item_count': serializeParam(
          _itemCount,
          ParamType.String,
        ),
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'content': serializeParam(
          _content,
          ParamType.String,
        ),
      }.withoutNulls;

  static ProductStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProductStruct(
        brand: deserializeParam(
          data['brand'],
          ParamType.String,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        productDescription: deserializeParam(
          data['product_description'],
          ParamType.String,
          false,
        ),
        uniqueProductName: deserializeParam(
          data['unique_product_name'],
          ParamType.String,
          false,
        ),
        size: deserializeParam(
          data['size'],
          ParamType.String,
          false,
        ),
        sourceFile: deserializeParam(
          data['source_file'],
          ParamType.String,
          false,
        ),
        sourceFolder: deserializeParam(
          data['source_folder'],
          ParamType.String,
          false,
        ),
        price: deserializeParam(
          data['price'],
          ParamType.String,
          false,
        ),
        barcode: deserializeParam(
          data['barcode'],
          ParamType.String,
          false,
        ),
        itemCount: deserializeParam(
          data['item_count'],
          ParamType.String,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        content: deserializeParam(
          data['content'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ProductStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProductStruct &&
        brand == other.brand &&
        category == other.category &&
        productDescription == other.productDescription &&
        uniqueProductName == other.uniqueProductName &&
        size == other.size &&
        sourceFile == other.sourceFile &&
        sourceFolder == other.sourceFolder &&
        price == other.price &&
        barcode == other.barcode &&
        itemCount == other.itemCount &&
        id == other.id &&
        content == other.content;
  }

  @override
  int get hashCode => const ListEquality().hash([
        brand,
        category,
        productDescription,
        uniqueProductName,
        size,
        sourceFile,
        sourceFolder,
        price,
        barcode,
        itemCount,
        id,
        content
      ]);
}

ProductStruct createProductStruct({
  String? brand,
  String? category,
  String? productDescription,
  String? uniqueProductName,
  String? size,
  String? sourceFile,
  String? sourceFolder,
  String? price,
  String? barcode,
  String? itemCount,
  String? id,
  String? content,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ProductStruct(
      brand: brand,
      category: category,
      productDescription: productDescription,
      uniqueProductName: uniqueProductName,
      size: size,
      sourceFile: sourceFile,
      sourceFolder: sourceFolder,
      price: price,
      barcode: barcode,
      itemCount: itemCount,
      id: id,
      content: content,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ProductStruct? updateProductStruct(
  ProductStruct? product, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    product
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addProductStructData(
  Map<String, dynamic> firestoreData,
  ProductStruct? product,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (product == null) {
    return;
  }
  if (product.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && product.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final productData = getProductFirestoreData(product, forFieldValue);
  final nestedData = productData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = product.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getProductFirestoreData(
  ProductStruct? product, [
  bool forFieldValue = false,
]) {
  if (product == null) {
    return {};
  }
  final firestoreData = mapToFirestore(product.toMap());

  // Add any Firestore field values
  product.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getProductListFirestoreData(
  List<ProductStruct>? products,
) =>
    products?.map((e) => getProductFirestoreData(e, true)).toList() ?? [];
