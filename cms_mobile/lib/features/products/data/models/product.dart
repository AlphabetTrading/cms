import 'package:cms_mobile/features/material_transactions/data/models/product_variant.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';

class ProductModel extends ProductEntity {
  const ProductModel(
      {required String? id, required String? name, String? iconSrc})
      : super(id: id, name: name, iconSrc: iconSrc);

  @override
  List<Object?> get props {
    return [id, name, iconSrc];
  }

  factory ProductModel.fromJson(Map<String, dynamic>? json) {
    return ProductModel(
      id: json?['id'],
      name: json?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'iconSrc': iconSrc};
  }
}

enum UnitOfMeasure { berga, kg, liter, m2, m3, pcs, packet, quintal }

UnitOfMeasure toUnitOfMeasure(String value) {
  switch (value) {
    case 'BERGA':
      return UnitOfMeasure.berga;
    case 'KG':
      return UnitOfMeasure.kg;
    case 'LITER':
      return UnitOfMeasure.liter;
    case 'M2':
      return UnitOfMeasure.m2;
    case 'M3':
      return UnitOfMeasure.m3;
    case 'PCS':
      return UnitOfMeasure.pcs;
    case 'PACKET':
      return UnitOfMeasure.packet;
    case 'QUINTAL':
      return UnitOfMeasure.quintal;
    default:
      throw Exception('Invalid UnitOfMeasure');
  }
}

String fromUnitOfMeasure(UnitOfMeasure? value) {
  if (value == null) {
    return '';
  }
  switch (value) {
    case UnitOfMeasure.berga:
      return 'BERGA';
    case UnitOfMeasure.kg:
      return 'KG';
    case UnitOfMeasure.liter:
      return 'LITER';
    case UnitOfMeasure.m2:
      return 'M2';
    case UnitOfMeasure.m3:
      return 'M3';
    case UnitOfMeasure.pcs:
      return 'PCS';
    case UnitOfMeasure.packet:
      return 'PACKET';
    case UnitOfMeasure.quintal:
      return 'QUINTAL';
  }
}

class WarehouseProductModel extends WarehouseProductEntity {
  const WarehouseProductModel(
      {required ProductVariantModel productVariant,
      required double quantity,
      required double currentPrice})
      : super(
            productVariant: productVariant,
            quantity: quantity,
            currentPrice: currentPrice);

  Map<String, dynamic> toJson() {
    return {
      'productVariant': (productVariant as ProductVariantModel).toJson(),
      'quantity': quantity,
      'currentPrice': currentPrice
    };
  }

  factory WarehouseProductModel.fromJson(Map<String, dynamic> json) {
    return WarehouseProductModel(
      productVariant: ProductVariantModel.fromJson(json['productVariant']),
      quantity: json['quantity'],
      currentPrice: json['currentPrice'],
    );
  }
}
