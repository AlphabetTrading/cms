import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/domain/repository/warehouse_repository.dart';

class CreateWarehouseUseCase
    implements UseCase<String, CreateWarehouseParamsEntity> {
  final WarehouseRepository repository;

  CreateWarehouseUseCase(this.repository);

  @override
  Future<DataState<String>> call({CreateWarehouseParamsEntity? params}) async {
    return await repository.createWarehouse(
      params: params!,
    );
  }
}
