import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart.dart';
import 'package:equatable/equatable.dart';

abstract class PurchaseOrderState extends Equatable {
  final List<PurchaseOrderEntity>? purchaseOrders;
  final Failure? error;

  const PurchaseOrderState({this.purchaseOrders, this.error});

  @override
  List<Object?> get props => [purchaseOrders, error];
}

class PurchaseOrderInitial extends PurchaseOrderState {
  const PurchaseOrderInitial();
}

class PurchaseOrderLoading extends PurchaseOrderState {
  const PurchaseOrderLoading();
}

class PurchaseOrderSuccess extends PurchaseOrderState {
  const PurchaseOrderSuccess(
      {required List<PurchaseOrderEntity> purchaseOrders})
      : super(purchaseOrders: purchaseOrders);
}

class PurchaseOrderFailed extends PurchaseOrderState {
  const PurchaseOrderFailed({required Failure error}) : super(error: error);
}

class PurchaseOrderEmpty extends PurchaseOrderState {
  const PurchaseOrderEmpty();
}
