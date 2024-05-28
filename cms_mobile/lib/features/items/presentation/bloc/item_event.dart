import 'package:cms_mobile/features/items/domain/entities/get_items_input.dart';

abstract class ItemEvent {
  const ItemEvent();
}

class GetWarehouseItems extends ItemEvent {
  final GetWarehouseItemsInputEntity? getItemsInputEntity;
  const GetWarehouseItems({this.getItemsInputEntity});
}

class GetAllWarehouseItems extends ItemEvent {
  final String projectId;
  const GetAllWarehouseItems(this.projectId);
}


class GetItem extends ItemEvent {
  final String id;
  const GetItem(this.id);
}

class CreateItem extends ItemEvent {
  final String id;
  const CreateItem(this.id);
}

class UpdateItem extends ItemEvent {
  final String id;
  const UpdateItem(this.id);
}

class DeleteItem extends ItemEvent {
  final String id;
  const DeleteItem(this.id);
}
