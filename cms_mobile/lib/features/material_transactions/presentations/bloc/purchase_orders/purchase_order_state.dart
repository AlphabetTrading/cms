import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:equatable/equatable.dart';

class PurchaseOrderState extends Equatable {
  final PurchaseOrderEntityListWithMeta? purchaseOrders;
  final PurchaseOrderEntityListWithMeta? myPurchaseOrders;
  final PurchaseOrderEntity? purchaseOrder;
  final bool hasReachedMax;

  final Failure? error;

  const PurchaseOrderState(
      {this.purchaseOrders,
      this.myPurchaseOrders,
      this.purchaseOrder,
      this.error,
      this.hasReachedMax = false});

  @override
  List<Object?> get props =>
      [purchaseOrders, myPurchaseOrders, purchaseOrder, error, hasReachedMax];

  @override
  String toString() {
    return 'PurchaseOrderState { purchaseOrders: $purchaseOrders, myPurchaseOrders: $myPurchaseOrders, error: $error, purchaseOrder: $purchaseOrder, hasReachedMax: $hasReachedMax }';
  }

  PurchaseOrderState copyWith({
    PurchaseOrderEntityListWithMeta? purchaseOrders,
    PurchaseOrderEntityListWithMeta? myPurchaseOrders,
    PurchaseOrderEntity? purchaseOrder,
    bool? hasReachedMax,
    Failure? error,
  }) {
    return PurchaseOrderState(
      purchaseOrders: purchaseOrders ?? this.purchaseOrders,
      myPurchaseOrders: myPurchaseOrders ?? this.myPurchaseOrders,
      purchaseOrder: purchaseOrder ?? this.purchaseOrder,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error ?? this.error,
    );
  }
}

class PurchaseOrderInitial extends PurchaseOrderState {
  const PurchaseOrderInitial();
}

class PurchaseOrderLoading extends PurchaseOrderState {
  const PurchaseOrderLoading();
}

class PurchaseOrderSuccess extends PurchaseOrderState {
  const PurchaseOrderSuccess(
      {required PurchaseOrderEntityListWithMeta purchaseOrders,
      required PurchaseOrderEntityListWithMeta myPurchaseOrders})
      : super(
            purchaseOrders: purchaseOrders, myPurchaseOrders: myPurchaseOrders);
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

class ApprovePurchaseOrderLoading extends PurchaseOrderState {
  const ApprovePurchaseOrderLoading();
}

class ApprovePurchaseOrderSuccess extends PurchaseOrderState {
  const ApprovePurchaseOrderSuccess();
}

class ApprovePurchaseOrderFailed extends PurchaseOrderState {
  const ApprovePurchaseOrderFailed({required Failure error})
      : super(error: error);
}
