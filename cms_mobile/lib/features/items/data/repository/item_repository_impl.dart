import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/items/data/data_sources/remote_data_source.dart';
import 'package:cms_mobile/features/items/data/models/item.dart';
import 'package:cms_mobile/features/items/domain/entities/get_items_input.dart';
import 'package:cms_mobile/features/items/domain/repository/item_repository.dart';

class ItemRepositoryImpl extends ItemRepository{
  final ItemDataSource dataSource;
  ItemRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<List<WarehouseItemModel>>> getItems(GetItemsInputEntity? getItemsInput) {
    return dataSource.fetchItems(getItemsInput);
  }
  
  @override
  Future<DataState<List<WarehouseItemModel>>> getAllWarehouseItems() {
    return dataSource.fetchAllStockItems();
  }

}