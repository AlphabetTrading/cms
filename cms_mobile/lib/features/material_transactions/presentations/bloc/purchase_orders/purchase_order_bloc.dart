import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/create_purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/get_purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseOrderBloc extends Bloc<PurchaseOrderEvent, PurchaseOrderState> {
  final GetPurchaseOrdersUseCase _purchaseOrderUseCase;
  final CreatePurchaseOrderUseCase _createPurchaseOrderUseCase;

  PurchaseOrderBloc(
      this._purchaseOrderUseCase, this._createPurchaseOrderUseCase)
      : super(const PurchaseOrderInitial()) {
    on<GetPurchaseOrdersEvent>(onGetPurchaseOrders);
    on<CreatePurchaseOrderEvent>(onCreatePurchaseOrder);
  }

  void onGetPurchaseOrders(
      GetPurchaseOrdersEvent event, Emitter<PurchaseOrderState> emit) async {
    emit(const PurchaseOrderLoading());

    final dataState = await _purchaseOrderUseCase(
      params: PurchaseOrderParams(
        filterPurchaseOrderInput: event.filterPurchaseOrderInput,
        orderBy: event.orderBy,
        paginationInput: event.paginationInput,
      ),
    );

    if (dataState is DataSuccess) {
      emit(PurchaseOrderSuccess(purchaseOrders: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(PurchaseOrderFailed(error: dataState.error!));
    }
  }

  void onCreatePurchaseOrder(
      CreatePurchaseOrderEvent event, Emitter<PurchaseOrderState> emit) async {
    emit(const CreatePurchaseOrderLoading());
    final dataState = await _createPurchaseOrderUseCase(
        params: event.createPurchaseOrderParamsEntity);

    if (dataState is DataSuccess) {
      emit(const CreatePurchaseOrderSuccess());
    }

    if (dataState is DataFailed) {
      emit(CreatePurchaseOrderFailed(error: dataState.error!));
    }
  }
}
