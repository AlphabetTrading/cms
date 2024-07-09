import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:flutter/material.dart';

class WarehouseModel extends WarehouseEntity {
  const WarehouseModel({
    required super.id,
    required super.name,
    required super.location,
    required super.createdAt,
    required super.updatedAt,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> map) {
    return WarehouseModel(
      id: map['id'],
      name: map['name'],
      location: map['location'] ?? "",
      createdAt: map["createdAt"] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map["updatedAt"] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
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
