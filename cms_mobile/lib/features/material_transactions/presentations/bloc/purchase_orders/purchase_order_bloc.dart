import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/get_purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseOrderBloc extends Bloc<PurchaseOrderEvent, PurchaseOrderState> {
  final GetPurchaseOrderUseCase _purchaseOrderUseCase;

  PurchaseOrderBloc(this._purchaseOrderUseCase)
      : super(const PurchaseOrderInitial()) {
    on<GetPurchaseOrder>(onGetPurchaseOrders);
  }

  void onGetPurchaseOrders(
      GetPurchaseOrder event, Emitter<PurchaseOrderState> emit) async {
    final dataState = await _purchaseOrderUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(PurchaseOrderSuccess(purchaseOrders: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(PurchaseOrderFailed(error: dataState.error!));
    }
  }
}
