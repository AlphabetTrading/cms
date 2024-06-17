import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

class ProductVariantEntity extends Equatable {
  final String id;
  final String? description;
  final UnitOfMeasure? unitOfMeasure;
  final ProductEntity? product;
  final String? productId;
  final String? variant;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductVariantEntity(
      {required this.id,
      required this.variant,
      required this.description,
      required this.unitOfMeasure,
      required this.product,
      required this.createdAt,
      required this.updatedAt,
      required this.productId});

  @override
  List<Object?> get props => [id, description, variant, productId];

  ProductVariantEntity copyWith({
    String? id,
    String? description,
    UnitOfMeasure? unitOfMeasure,
    ProductEntity? product,
    String? productId,
    String? variant,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductVariantEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      product: product ?? this.product,
      productId: productId ?? this.productId,
      variant: variant ?? this.variant,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ProductVariantEntity.fromJson(Map<String, dynamic> json) {
    return ProductVariantEntity(
      id: json['id'],
      description: json['description'],
      unitOfMeasure: UnitOfMeasure.values
          .firstWhere((e) => e.toString() == json['unitOfMeasure']),
      product: ProductEntity.fromJson(json['product']),
      productId: json['productId'],
      variant: json['variant'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'unitOfMeasure': unitOfMeasure,
      'product': product,
      'productId': productId,
      'variant': variant,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  
}
