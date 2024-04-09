import 'package:equatable/equatable.dart';

class WarehouseEntity extends Equatable {
  final String id;
  final String name;
  final String location;

  const WarehouseEntity({
    required this.id,
    required this.name,
    required this.location,
  });

  @override
  List<Object?> get props => [id, name, location];
}
