import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/warehouse/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/domain/repository/warehouse_repository.dart';

class WarehouseRepositoryImpl implements WarehouseRepository {
  final WarehouseDataSource dataSource;

  WarehouseRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<List<WarehouseEntity>>> getWarehouses() {
    return dataSource.fetchWarehouses();
  }
}