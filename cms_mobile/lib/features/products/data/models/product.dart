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

class ProductVariantModel extends ProductVariantEntity {
  const ProductVariantModel({
    required String id,
    required String? description,
    required UnitOfMeasure? unitOfMeasure,
    required String? variant,
    required DateTime? createdAt,
    required DateTime? updatedAt,
    required String? productId,
    required ProductModel? product,
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
    final ProductVariantModel productVariantModel = ProductVariantModel(
      id: json['id'],
      description: json['description'],
      unitOfMeasure: json['unitOfMeasure'] != null
          ? toUnitOfMeasure(json['unitOfMeasure'])
          : null,
      variant: json['variant'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      productId: json['productId'],
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
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
