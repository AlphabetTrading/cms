import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/items/data/models/item.dart';
import 'package:cms_mobile/features/items/domain/entities/get_items_input.dart';

abstract class ItemRepository{
  Future<DataState<List<ItemModel>>> getItems(GetItemsInputEntity getItemsInput);
}