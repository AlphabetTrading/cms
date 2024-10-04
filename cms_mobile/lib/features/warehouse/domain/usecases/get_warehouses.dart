import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/warehouse/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/domain/repository/warehouse_repository.dart';

class GetWarehousesUseCase
    implements UseCase<List<WarehouseEntity>, WarehouseParams?> {
  final WarehouseRepository _warehouseRepository;

  GetWarehousesUseCase(this._warehouseRepository);
  @override
  Future<DataState<List<WarehouseEntity>>> call({WarehouseParams? params}) {
    return _warehouseRepository.getWarehouses(
      params?.filterWarehouseStoreInput,
      params?.orderBy,
      params?.paginationInput,
    );
  }
}

class WarehouseParams {
  FilterWarehouseStoreInput? filterWarehouseStoreInput;
  OrderByWarehouseStoreInput? orderBy;
  PaginationInput? paginationInput;

  WarehouseParams(
      {this.filterWarehouseStoreInput, this.orderBy, this.paginationInput});
}
