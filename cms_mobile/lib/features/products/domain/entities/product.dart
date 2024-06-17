import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? id;
  final String? name;
  final String? iconSrc;

  const ProductEntity({
    required this.id,
    required this.name,
    this.iconSrc,
  });

  @override
  List<Object?> get props => [id, name, iconSrc];

  ProductEntity copyWith({
    String? id,
    String? name,
    String? iconSrc,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconSrc: iconSrc ?? this.iconSrc,
    );
  }

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'],
      name: json['name'],
      iconSrc: json['iconSrc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconSrc': iconSrc,
    };
  }
}

class WarehouseProductEntity extends Equatable {
  final ProductVariantEntity productVariant;
  final double quantity;
  final double currentPrice;

  const WarehouseProductEntity({
    required this.productVariant,
    required this.quantity,
    required this.currentPrice,
  });

  @override
  List<Object?> get props => [productVariant, quantity, currentPrice];
}
