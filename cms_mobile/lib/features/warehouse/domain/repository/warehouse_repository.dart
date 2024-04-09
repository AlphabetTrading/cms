import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';

abstract class WarehouseRepository {
  Future<DataState<List<WarehouseEntity>>> getWarehouses();
  // Future<Warehouse> getWarehouse(String id);
  // Future<void> addWarehouse(Warehouse warehouse);
  // Future<void> updateWarehouse(Warehouse warehouse);
  // Future<void> deleteWarehouse(String id);
}