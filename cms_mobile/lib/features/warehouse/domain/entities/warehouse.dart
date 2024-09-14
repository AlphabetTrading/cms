import 'package:equatable/equatable.dart';

class WarehouseEntity extends Equatable {
  final String id;
  final String name;
  final String? location;
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


  factory WarehouseEntity.fromJson(Map<String, dynamic> json) {
    return WarehouseEntity(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      createdAt: json['createdAt']!=null?DateTime.parse(json['createdAt']):null,
      updatedAt: json['updatedAt']!=null?DateTime.parse(json['updatedAt']):null,
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
