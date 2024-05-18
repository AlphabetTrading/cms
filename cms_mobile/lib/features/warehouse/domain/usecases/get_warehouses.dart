import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/domain/repository/warehouse_repository.dart';

class GetWarehousesUseCase implements UseCase<List<WarehouseEntity>,void>{
  
  final WarehouseRepository _warehouseRepository;

  GetWarehousesUseCase(this._warehouseRepository);
  @override
  Future<DataState<List<WarehouseEntity>>> call({void params}) {
    return _warehouseRepository.getWarehouses();
  }

}