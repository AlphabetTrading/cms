import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/items/domain/entities/get_items_input.dart';
import 'package:cms_mobile/features/items/domain/entities/item.dart';
import 'package:cms_mobile/features/items/domain/repository/item_repository.dart';

class GetItemsUseCase implements UseCase<List<WarehouseItemEntity>, GetWarehouseItemsInputEntity?> {
  final ItemRepository repository;

  GetItemsUseCase(this.repository);

  @override
  Future<DataState<List<WarehouseItemEntity>>> call({GetWarehouseItemsInputEntity? params}) {
    return repository.getWarehouseItems(params);
  }
}
