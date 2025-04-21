import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_model.freezed.dart';
part 'catalog_model.g.dart';

@freezed
class CatalogModel with _$CatalogModel {
  const factory CatalogModel({
    @JsonKey(name: 'products') @Default([]) List<ProductData> products,
  }) = _CatalogModel;

  factory CatalogModel.fromJson(Map<String, dynamic> json) => _$CatalogModelFromJson(json);

}


@freezed
class ProductData with _$ProductData {
  const factory ProductData({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'description') @Default('') String description,
    @JsonKey(name: 'category') @Default('') String category,
    @JsonKey(name: 'price') @Default(0) double price,
    @JsonKey(name: 'discountPercentage') @Default(0) double discountPercentage,
    @JsonKey(name: 'rating') @Default(0) double rating,
    @JsonKey(name: 'stock') @Default(0) double stock,
    @JsonKey(name: 'brand') @Default('') String brand,
    @JsonKey(name: 'sku') @Default('') String sku,
    @JsonKey(name: 'weight') @Default(0) double weight,
    @JsonKey(name: 'warrantyInformation') @Default('') String warrantyInformation,
    @JsonKey(name: 'shippingInformation') @Default('') String shippingInformation,
    @JsonKey(name: 'availabilityStatus') @Default('') String availabilityStatus,
    @JsonKey(name: 'thumbnail') @Default('') String thumbnail,
    @JsonKey(name: 'returnPolicy') @Default('') String returnPolicy,
    @JsonKey(name: 'minimumOrderQuantity') @Default(1) int minimumOrderQuantity,
    @JsonKey(name: 'tags') @Default([]) List<String> tags,
    @JsonKey(name: 'reviews') @Default(<Review>[]) List<Review> reviews,
    @JsonKey(name: 'dimensions') @Default(Dimensions()) Dimensions dimensions,
    @JsonKey(name: 'images') @Default([]) List<String> images,
    @JsonKey(name: 'meta') @Default(Meta()) Meta meta,
  }) = _ProductData;

  factory ProductData.fromJson(Map<String, dynamic> json) => _$ProductDataFromJson(json);

  const ProductData._();

  // Iterable<int> get productIds => products.map((e) => e.productId);
}

@freezed
class Meta with _$Meta {
  const factory Meta({
    @JsonKey(name: 'createdAt') @Default('') String createdAt,
    @JsonKey(name: 'updatedAt') @Default('') String updatedAt,
    @JsonKey(name: 'barcode') @Default('') String barcode,
    @JsonKey(name: 'qrCode') @Default('') String qrCode,
  }) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}

@freezed
class Dimensions with _$Dimensions {
  const factory Dimensions({
    @JsonKey(name: 'width') @Default(0) double width,
    @JsonKey(name: 'height') @Default(0) double height,
    @JsonKey(name: 'depth') @Default(0) double depth,
  }) = _Dimensions;

  factory Dimensions.fromJson(Map<String, dynamic> json) => _$DimensionsFromJson(json);
}

@freezed
class Review with _$Review {
  const factory Review({
    @JsonKey(name: 'rating') @Default(0) int rating,
    @JsonKey(name: 'comment') @Default('') String comment,
    @JsonKey(name: 'date') @Default('') String date,
    @JsonKey(name: 'reviewerName') @Default('') String reviewerName,
    @JsonKey(name: 'reviewerEmail') @Default('') String reviewerEmail,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}


// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'product_model.freezed.dart';

// part 'product_model.g.dart';

// @freezed
// class ProductModel with _$ProductModel {
//   factory ProductModel({
//     required String accountId,
//   }) = _ProductModel;

//   factory ProductModel.empty() => ProductModel(accountId: '');

//   ProductModel._();

//   factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

// }

// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'product_model.freezed.dart';
// part 'product_model.g.dart';

// @freezed
// class ProductModel with _$ProductModel {
//   const factory ProductModel({
//     required String accountId,
//   }) = _ProductModel;

//   factory ProductModel.empty() => const ProductModel(accountId: '');

//   factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
// }

// ignore_for_file: invalid_annotation_target
