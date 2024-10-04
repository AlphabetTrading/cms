import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';

abstract class WarehouseLocalEvent {
  const WarehouseLocalEvent();
}

class GetWarehouseLocal extends WarehouseLocalEvent {
  const GetWarehouseLocal();
}

class DeleteWarehouseLocal extends WarehouseLocalEvent {
  final int index;
  const DeleteWarehouseLocal(this.index);
}

class AddWarehouseLocal extends WarehouseLocalEvent {
  final WarehouseEntity warehouse;
  const AddWarehouseLocal(this.warehouse);
}

class AddWarehousesLocal extends WarehouseLocalEvent {
  final List<WarehouseEntity> warehouses;
  const AddWarehousesLocal(this.warehouses);
}

class EditWarehouseLocal extends WarehouseLocalEvent {
  final WarehouseEntity warehouse;
  final int index;
  const EditWarehouseLocal(this.warehouse, this.index);
}

class ClearWarehouseLocal extends WarehouseLocalEvent {
  const ClearWarehouseLocal();
}
