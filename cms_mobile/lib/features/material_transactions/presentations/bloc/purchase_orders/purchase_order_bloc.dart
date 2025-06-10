import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/approve_purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/create_purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/get_purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseOrderBloc extends Bloc<PurchaseOrderEvent, PurchaseOrderState> {
  final GetPurchaseOrdersUseCase _purchaseOrderUseCase;
  final CreatePurchaseOrderUseCase _createPurchaseOrderUseCase;
  final ApprovePurchaseOrderUseCase _approvePurchaseOrderUseCase;
  DateTime? lastUpdated;

  PurchaseOrderBloc(this._purchaseOrderUseCase,
      this._createPurchaseOrderUseCase, this._approvePurchaseOrderUseCase)
      : super(const PurchaseOrderInitial()) {
    on<GetPurchaseOrdersEvent>(onGetPurchaseOrders);
    on<CreatePurchaseOrderEvent>(onCreatePurchaseOrder);
    on<ApprovePurchaseOrderEvent>(onApprovePurchaseOrder);
  }

  void onGetPurchaseOrders(
      GetPurchaseOrdersEvent event, Emitter<PurchaseOrderState> emit) async {
    emit(const PurchaseOrderLoading());

    final dataState = await _purchaseOrderUseCase(
      params: PurchaseOrderParams(
        filterPurchaseOrderInput: event.filterPurchaseOrderInput,
        orderBy: event.orderBy,
        paginationInput: event.paginationInput,
        mine: event.mine,
      ),
    );

    if (dataState is DataSuccess) {
      if (event.mine == true) {
        final myPurchaseOrders =
            (state.myPurchaseOrders ?? PurchaseOrderEntityListWithMeta.empty())
                .copyWith(
                    items: (state.myPurchaseOrders?.items ?? [])
                      ..addAll(dataState.data!.items));

        emit(PurchaseOrderSuccess(
            myPurchaseOrders: myPurchaseOrders,
            purchaseOrders: state.purchaseOrders ??
                PurchaseOrderEntityListWithMeta.empty()));
      } else {
        final purchaseOrders =
            (state.purchaseOrders ?? PurchaseOrderEntityListWithMeta.empty())
                .copyWith(
                    items: (state.purchaseOrders?.items ?? [])
                      ..addAll(dataState.data!.items));

        emit(PurchaseOrderSuccess(
            purchaseOrders: purchaseOrders,
            myPurchaseOrders: state.myPurchaseOrders ??
                PurchaseOrderEntityListWithMeta.empty()));
      }

      lastUpdated = DateTime.now();
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

  void onApprovePurchaseOrder(
      ApprovePurchaseOrderEvent event, Emitter<PurchaseOrderState> emit) async {
    emit(const ApprovePurchaseOrderLoading());

    final dataState = await _approvePurchaseOrderUseCase(
        params: ApprovePurchaseOrderParamsModel(
            decision: event.decision, purchaseOrderId: event.purchaseOrderId));

    debugPrint('Response: $dataState');

    if (dataState is DataSuccess) {
      emit(const ApprovePurchaseOrderSuccess());
    }

    if (dataState is DataFailed) {
      emit(ApprovePurchaseOrderFailed(error: dataState.error!));
    }
  }
}
