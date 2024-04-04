import 'package:equatable/equatable.dart';

class MaterialEntity extends Equatable {
  final String id;
  final String name;
  final double quantity;
  final String? iconSrc;

  const MaterialEntity({required this.id, required this.name, required this.quantity, this.iconSrc});

  @override
  List<Object?> get props => [id, name, quantity, iconSrc];
}
