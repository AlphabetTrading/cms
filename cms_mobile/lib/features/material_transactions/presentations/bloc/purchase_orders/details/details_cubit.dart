import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/get_purchase_order_details.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PurchaseOrderDetailsState extends Equatable {
  const PurchaseOrderDetailsState();

  @override
  List<Object> get props => [];
}

class PurchaseOrderDetailsInitial extends PurchaseOrderDetailsState {}

class PurchaseOrderDetailsLoading extends PurchaseOrderDetailsState {}

class PurchaseOrderDetailsSuccess extends PurchaseOrderDetailsState {
  final PurchaseOrderEntity? purchaseOrder;

  const PurchaseOrderDetailsSuccess({this.purchaseOrder});

  @override
  List<Object> get props => [purchaseOrder!];
}

class PurchaseOrderDetailsFailed extends PurchaseOrderDetailsState {
  final String error;

  const PurchaseOrderDetailsFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class PurchaseOrderDetailsEvent {}

class GetPurchaseOrderDetailsEvent extends PurchaseOrderDetailsEvent {
  final String purchaseOrderId;

  GetPurchaseOrderDetailsEvent({required this.purchaseOrderId});
}

class PurchaseOrderDetailsCubit extends Cubit<PurchaseOrderDetailsState> {
  final GetPurchaseOrderDetailsUseCase _getPurchaseOrderDetailsUseCase;

  PurchaseOrderDetailsCubit(this._getPurchaseOrderDetailsUseCase)
      : super(PurchaseOrderDetailsInitial());

  void onGetPurchaseOrderDetails({required String purchaseOrderId}) async {
    emit(PurchaseOrderDetailsLoading());
    final dataState =
        await _getPurchaseOrderDetailsUseCase(params: purchaseOrderId);
    if (dataState is DataSuccess) {
      emit(PurchaseOrderDetailsSuccess(
          purchaseOrder: dataState.data as PurchaseOrderEntity));
    } else if (dataState is DataFailed) {
      emit(PurchaseOrderDetailsFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get purchase order details'));
    }
  }
}
