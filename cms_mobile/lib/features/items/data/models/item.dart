import 'package:cms_mobile/features/items/domain/entities/item.dart';

class ItemModel extends ItemEntity {
  const ItemModel(
      {required String id,
      required String name,
      required double quantity,
      String? unit})
      : super(id: id, name: name, quantity: quantity, unit: unit);

  @override
  List<Object?> get props {
    return [id, name, quantity, unit];
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['product']['name'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'quantity': quantity, 'unit': unit};
  }
}
