import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';

abstract class PurchaseOrderEvent {
  const PurchaseOrderEvent();
}

class GetPurchaseOrdersEvent extends PurchaseOrderEvent {
  final FilterPurchaseOrderInput? filterPurchaseOrderInput;
  final OrderByPurchaseOrderInput? orderBy;
  final PaginationInput? paginationInput;
  final bool? mine;
  const GetPurchaseOrdersEvent({
    this.filterPurchaseOrderInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
  });
}

class GetPurchaseOrderEvent extends PurchaseOrderEvent {
  final String id;
  const GetPurchaseOrderEvent(this.id);
}

class CreatePurchaseOrderEvent extends PurchaseOrderEvent {
  final CreatePurchaseOrderParamsEntity createPurchaseOrderParamsEntity;

  const CreatePurchaseOrderEvent(
      {required this.createPurchaseOrderParamsEntity});
}

class UpdatePurchaseOrderEvent extends PurchaseOrderEvent {
  final String id;
  const UpdatePurchaseOrderEvent(this.id);
}

class DeletePurchaseOrderEvent extends PurchaseOrderEvent {
  final String id;
  const DeletePurchaseOrderEvent(this.id);
}
