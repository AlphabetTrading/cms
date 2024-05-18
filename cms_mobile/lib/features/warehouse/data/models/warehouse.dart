import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';

class WarehouseModel extends WarehouseEntity {
  const WarehouseModel({
    required String id,
    required String name,
    required String location,
  }) : super(
          id: id,
          name: name,
          location: location,
        );

  factory WarehouseModel.fromJson(Map<String, dynamic> map) {
    return WarehouseModel(
      id: map['id'],
      name: map['name'],
      location: map['location'],
    );
  }

  factory WarehouseModel.fromEntity(WarehouseEntity entity) {
    return WarehouseModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
    );
  }
}
