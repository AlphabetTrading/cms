import 'package:cms_mobile/features/products/data/models/product.dart';
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
}


class ProductVariantEntity extends Equatable {
  final String id;
  final String? description;
  final UnitOfMeasure? unitOfMeasure;
  final ProductEntity? product;
  final String? variant;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? productId;

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
