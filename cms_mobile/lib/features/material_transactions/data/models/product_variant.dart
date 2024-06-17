import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:flutter/material.dart';

class ProductVariantModel extends ProductVariantEntity {
  const ProductVariantModel({
    required String id,
    String? description,
    UnitOfMeasure? unitOfMeasure,
    String? variant,
    String? productId,
    ProductModel? product,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
            id: id,
            description: description,
            unitOfMeasure: UnitOfMeasure.kg,
            variant: variant,
            createdAt: createdAt,
            updatedAt: updatedAt,
            productId: productId,
            product: product);

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    debugPrint("ProductVariantModel.fromJson: ${json}");

    final ProductVariantModel productVariantModel = ProductVariantModel(
      id: json['id'],
      description: json['description'],
      unitOfMeasure: json['unitOfMeasure'] != null
          ? toUnitOfMeasure(json['unitOfMeasure'])
          : null,
      variant: json['variant'],
      productId: json['productId'],
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );

    return productVariantModel;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'unitOfMeasure': fromUnitOfMeasure(unitOfMeasure),
      'variant': variant,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'productId': productId,
      'product': product,
    };
  }
}
