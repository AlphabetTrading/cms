import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

class WarehouseEntity extends Equatable {
  final String? id;
  final String? name;
  final String? location;
  final String? companyId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<WarehouseStoreManagerEntity>? warehouseStoreManagers;

  const WarehouseEntity({
    this.id,
    this.name,
    this.companyId,
    this.location,
    this.warehouseStoreManagers,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, name, location, companyId, warehouseStoreManagers];

  factory WarehouseEntity.fromJson(Map<String, dynamic> json) {
    return WarehouseEntity(
      id: json['id'],
      companyId: json['companyId'],
      name: json['name'],
      location: json['location'],
      warehouseStoreManagers: json['warehouseStoreManagers'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'name': name,
      'warehouseStoreManagers': warehouseStoreManagers,
      'location': location,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class WarehouseStoreManagerEntity extends Equatable {
  final UserEntity? storeManager;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WarehouseStoreManagerEntity({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.storeManager,
  });

  @override
  List<Object?> get props => [id, storeManager];

  factory WarehouseStoreManagerEntity.fromJson(Map<String, dynamic> json) {
    return WarehouseStoreManagerEntity(
      id: json['id'],
      storeManager: json['storeManager'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeManager': storeManager,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class CreateWarehouseParamsEntity<T extends WarehouseEntity> extends Equatable {
  final String companyId;
  final String name;
  final String location;
  final List<WarehouseStoreManagerEntity> storeManagers;

  const CreateWarehouseParamsEntity(
      {required this.companyId,
      required this.name,
      required this.storeManagers,
      required this.location});

  @override
  List<Object?> get props => [name, location, companyId, storeManagers];
}
