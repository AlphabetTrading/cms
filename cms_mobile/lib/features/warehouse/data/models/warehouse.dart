import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';

class WarehouseModel extends WarehouseEntity {
  const WarehouseModel({
    required String id,
    required String name,
    required String location,
    required DateTime? createdAt,
    required DateTime? updatedAt,
  }) : super(
          id: id,
          name: name,
          location: location,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory WarehouseModel.fromJson(Map<String, dynamic> map) {
    return WarehouseModel(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  factory WarehouseModel.fromEntity(WarehouseEntity entity) {
    return WarehouseModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
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
