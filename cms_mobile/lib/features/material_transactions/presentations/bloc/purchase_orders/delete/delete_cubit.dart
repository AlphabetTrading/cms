import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/delete_purchase_order.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PurchaseOrderDeleteState extends Equatable {
  const PurchaseOrderDeleteState();

  @override
  List<Object> get props => [];
}

class PurchaseOrderDeleteInitial extends PurchaseOrderDeleteState {}

class PurchaseOrderDeleteLoading extends PurchaseOrderDeleteState {}

class PurchaseOrderDeleteSuccess extends PurchaseOrderDeleteState {
  const PurchaseOrderDeleteSuccess();
}

class PurchaseOrderDeleteFailed extends PurchaseOrderDeleteState {
  final String error;

  const PurchaseOrderDeleteFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class PurchaseOrderDeleteEvent {
  final String purchaseOrderId;

  PurchaseOrderDeleteEvent({required this.purchaseOrderId});
}

class PurchaseOrderDeleteCubit extends Cubit<PurchaseOrderDeleteState> {
  final DeletePurchaseOrderUseCase _purchaseOrderDeleteUseCase;

  PurchaseOrderDeleteCubit(this._purchaseOrderDeleteUseCase)
      : super(PurchaseOrderDeleteInitial());

  void onPurchaseOrderDelete({required String purchaseOrderId}) async {
    emit(PurchaseOrderDeleteLoading());
    final dataState =
        await _purchaseOrderDeleteUseCase(params: purchaseOrderId);
    if (dataState is DataSuccess) {
      emit(PurchaseOrderDeleteSuccess());
    } else if (dataState is DataFailed) {
      emit(PurchaseOrderDeleteFailed(
          error: dataState.error?.errorMessage ??
              'Failed to delete material issue '));
    }
  }
}
