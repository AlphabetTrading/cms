import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final String? id;
  final String? name;
  final String? iconSrc;

  const ItemEntity({
    required this.id,
    required this.name,
    this.iconSrc,
  });

  @override
  List<Object?> get props => [id, name, iconSrc];
}

class ItemVariantEntity extends Equatable {
  final String? id;
  final String? variant;
  final ItemEntity? item;
  final String? unit;

  const ItemVariantEntity({
    required this.id,
    required this.variant,
    required this.unit,
    this.item,
  });

  @override
  List<Object?> get props => [id, variant, item, unit];
}

class WarehouseItemEntity extends Equatable {

  final ItemVariantEntity itemVariant;
  final double quantity;
  final double currentPrice;

  const WarehouseItemEntity({
    required this.itemVariant,
    required this.quantity,
    required this.currentPrice,
  });

  @override
  List<Object?> get props => [itemVariant, quantity, currentPrice];


}
