import 'package:cms_mobile/features/items/domain/entities/get_items_input.dart';

abstract class ItemEvent{
  const ItemEvent();
}

class GetItems extends ItemEvent{
  final GetItemsInputEntity getItemsInputEntity;
  const GetItems(this.getItemsInputEntity);
}

class GetItem extends ItemEvent{
  final String id;
  const GetItem(this.id); 
}
class CreateItem extends ItemEvent{
  final String id;
  const CreateItem(this.id);
}

class UpdateItem extends ItemEvent{
  final String id;
  const UpdateItem(this.id);
}

class DeleteItem extends ItemEvent{
  final String id;
  const DeleteItem(this.id);
}