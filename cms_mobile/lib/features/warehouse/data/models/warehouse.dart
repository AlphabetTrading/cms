import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';

class WarehouseModel extends WarehouseEntity {
  const WarehouseModel({
    required super.id,
    required super.name,
    required super.location,
    required super.createdAt,
    required super.updatedAt,
    super.warehouseStoreManagers,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> map) {
    return WarehouseModel(
      id: map['id'],
      name: map['name'],
      location: map['location'] ?? "",
      warehouseStoreManagers: map["warehouseStoreManagers"] ?? [],
      createdAt:
          map["createdAt"] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map["updatedAt"] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  factory WarehouseModel.fromEntity(WarehouseEntity entity) {
    return WarehouseModel(
        id: entity.id,
        name: entity.name,
        location: entity.location,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        warehouseStoreManagers: entity.warehouseStoreManagers);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'warehouseStoreManagers': warehouseStoreManagers,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class WarehouseStoreManagerModel extends WarehouseStoreManagerEntity {
  const WarehouseStoreManagerModel(
      {super.id, super.storeManager, super.createdAt, super.updatedAt});

  factory WarehouseStoreManagerModel.fromJson(Map<String, dynamic> map) {
    return WarehouseStoreManagerModel(
      id: map['id'],
      storeManager: map['storeManager'],
      createdAt:
          map["createdAt"] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map["updatedAt"] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  factory WarehouseStoreManagerModel.fromEntity(
      WarehouseStoreManagerEntity entity) {
    return WarehouseStoreManagerModel(
      id: entity.id,
      storeManager: entity.storeManager,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeManager': storeManager,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class CreateWarehouseParamsModel
    extends CreateWarehouseParamsEntity<WarehouseModel> {
  const CreateWarehouseParamsModel(
      {required super.companyId,
      required super.storeManagers,
      required super.name,
      required super.location});

  Map<String, dynamic> toJson() {
    return {
      "companyId": companyId,
      "name": name,
      "location": location,
      "storeManagers": storeManagers
    };
  }

  @override
  List<Object?> get props => [companyId, name, location, storeManagers];

  factory CreateWarehouseParamsModel.fromEntity(
      CreateWarehouseParamsEntity entity) {
    return CreateWarehouseParamsModel(
      companyId: entity.companyId,
      name: entity.name,
      location: entity.location,
      storeManagers: entity.storeManagers,
    );
  }
}
