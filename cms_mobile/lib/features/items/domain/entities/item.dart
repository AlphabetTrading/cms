import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final String id;
  final String name;
  final double quantity;
  final String? unit;
  final String? iconSrc;

  const ItemEntity({required this.id, required this.name, required this.quantity, this.iconSrc, this.unit});

  @override
  List<Object?> get props => [id, name, quantity, iconSrc,unit];
}
