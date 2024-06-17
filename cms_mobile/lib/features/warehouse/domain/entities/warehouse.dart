import 'package:equatable/equatable.dart';

class WarehouseEntity extends Equatable {
  final String id;
  final String name;
  final String location;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WarehouseEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });



  @override
  List<Object?> get props => [id, name, location];


  factory WarehouseEntity.fromJson(Map<String, dynamic> map) {
    return WarehouseEntity(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
