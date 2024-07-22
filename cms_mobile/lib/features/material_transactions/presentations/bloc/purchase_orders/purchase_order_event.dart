import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';

abstract class PurchaseOrderEvent {
  const PurchaseOrderEvent();
}

class GetPurchaseOrders extends PurchaseOrderEvent {
  final FilterPurchaseOrderInput? filterPurchaseOrderInput;
  final OrderByPurchaseOrderInput? orderBy;
  final PaginationInput? paginationInput;
  final bool? mine;
  const GetPurchaseOrders({
    this.filterPurchaseOrderInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
  });
}

class GetPurchaseOrder extends PurchaseOrderEvent {
  final String id;
  const GetPurchaseOrder(this.id);
}

class CreatePurchaseOrder extends PurchaseOrderEvent {
  final String id;
  const CreatePurchaseOrder(this.id);
}

class UpdatePurchaseOrder extends PurchaseOrderEvent {
  final String id;
  const UpdatePurchaseOrder(this.id);
}

class DeletePurchaseOrder extends PurchaseOrderEvent {
  final String id;
  const DeletePurchaseOrder(this.id);
}
