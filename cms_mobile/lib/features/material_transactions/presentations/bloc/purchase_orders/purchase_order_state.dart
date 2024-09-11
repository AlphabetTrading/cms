import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:equatable/equatable.dart';

abstract class PurchaseOrderState extends Equatable {
  final PurchaseOrderEntityListWithMeta? purchaseOrders;
  final PurchaseOrderEntity? purchaseOrder;

  final Failure? error;

  const PurchaseOrderState(
      {this.purchaseOrders, this.purchaseOrder, this.error});

  @override
  List<Object?> get props => [purchaseOrders, purchaseOrder, error];
}

class PurchaseOrderInitial extends PurchaseOrderState {
  const PurchaseOrderInitial();
}

class PurchaseOrderLoading extends PurchaseOrderState {
  const PurchaseOrderLoading();
}

class PurchaseOrderSuccess extends PurchaseOrderState {
  const PurchaseOrderSuccess(
      {required PurchaseOrderEntityListWithMeta purchaseOrders})
      : super(purchaseOrders: purchaseOrders);
}

class PurchaseOrderFailed extends PurchaseOrderState {
  const PurchaseOrderFailed({required Failure error}) : super(error: error);
}

class PurchaseOrderEmpty extends PurchaseOrderState {
  const PurchaseOrderEmpty();
}

class CreatePurchaseOrderLoading extends PurchaseOrderState {
  const CreatePurchaseOrderLoading();
}

class CreatePurchaseOrderSuccess extends PurchaseOrderState {
  const CreatePurchaseOrderSuccess();
}

class CreatePurchaseOrderFailed extends PurchaseOrderState {
  const CreatePurchaseOrderFailed({required Failure error})
      : super(error: error);
}

