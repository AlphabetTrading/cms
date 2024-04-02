abstract class PurchaseOrderEvent{
  const PurchaseOrderEvent();
}

class GetPurchaseOrders extends PurchaseOrderEvent{
  const GetPurchaseOrders();
}

class GetPurchaseOrder extends PurchaseOrderEvent{
  final String id;
  const GetPurchaseOrder(this.id);
}

class CreatePurchaseOrder extends PurchaseOrderEvent{
  final String id;
  const CreatePurchaseOrder(this.id);
}

class UpdatePurchaseOrder extends PurchaseOrderEvent{
  final String id;
  const UpdatePurchaseOrder(this.id);
}

class DeletePurchaseOrder extends PurchaseOrderEvent{
  final String id;
  const DeletePurchaseOrder(this.id);
}
