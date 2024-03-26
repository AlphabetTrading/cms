import 'package:equatable/equatable.dart';

class MaterialEntity extends Equatable {
  final String? id;
  final String? name;
  final double? quantity;

  const MaterialEntity({
    this.id,
    this.name,
    this.quantity,
  });

  @override
  List<Object?> get props => [id, name, quantity];
}
