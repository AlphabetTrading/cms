import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/items/domain/entities/item.dart';
import 'package:cms_mobile/features/items/domain/repository/item_repository.dart';

class GetAllWarehouseItemsUseCase implements UseCase<List<WarehouseItemEntity>, void> {
  final ItemRepository repository;

  GetAllWarehouseItemsUseCase(this.repository);

  @override
  Future<DataState<List<WarehouseItemEntity>>> call({void params}) {
    return repository.getAllWarehouseItems();
  }
}
