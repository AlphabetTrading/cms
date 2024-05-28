import 'package:cms_mobile/features/items/domain/entities/item.dart';

class ItemModel extends ItemEntity {
  const ItemModel({required String id, required String name, String? iconSrc})
      : super(id: id, name: name, iconSrc: iconSrc);

  @override
  List<Object?> get props {
    return [id, name, iconSrc];
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'iconSrc': iconSrc};
  }
}

class ItemVariantModel extends ItemVariantEntity {
  const ItemVariantModel(
      {required String id,
      required String variant,
      required String unit,
      ItemModel? item})
      : super(id: id, variant: variant, item: item, unit: unit);

  @override
  List<Object?> get props {
    return [id, variant, item, unit];
  }

  factory ItemVariantModel.fromJson(Map<String, dynamic> json) {
    return ItemVariantModel(
        id: json['id'],
        variant: json['variant'],
        item: ItemModel.fromJson(json['product']),
        // unit: "Unit",
        unit: json['unitOfMeasure']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'variant': variant, 'item': item, 'unitOfMeasure': unit};
  }
}

class WarehouseItemModel extends WarehouseItemEntity {
  const WarehouseItemModel(
      {required ItemVariantModel itemVariant, required double quantity, required double currentPrice})
      : super(itemVariant: itemVariant, quantity: quantity, currentPrice: currentPrice);

  Map<String, dynamic> toJson() {
    return {
      'productVariant': (itemVariant as ItemVariantModel).toJson(),
      'quantity': quantity,
      'currentPrice':currentPrice
    };
  }

  factory WarehouseItemModel.fromJson(Map<String, dynamic> json) {
    return WarehouseItemModel(
      itemVariant: ItemVariantModel.fromJson(json['productVariant']),
      quantity: json['quantity'],
      currentPrice: json['currentPrice'],
    );
  }
}
