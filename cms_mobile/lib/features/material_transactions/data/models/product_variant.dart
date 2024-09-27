import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:flutter/material.dart';

class ProductVariantModel extends ProductVariantEntity {
  const ProductVariantModel({
    required super.id,
    super.description,
    super.unitOfMeasure,
    super.variant,
    super.productId,
    ProductModel? super.product,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    // debugPrint("ProductVariantModel.fromJson: ${json}");

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
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
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
