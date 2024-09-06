import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/generate_purchase_order_pdf.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PurchaseOrderGeneratePdfState extends Equatable {
  const PurchaseOrderGeneratePdfState();

  @override
  List<Object> get props => [];
}

class PurchaseOrderGeneratePdfInitial extends PurchaseOrderGeneratePdfState {}

class PurchaseOrderGeneratePdfLoading extends PurchaseOrderGeneratePdfState {}

class PurchaseOrderGeneratePdfSuccess extends PurchaseOrderGeneratePdfState {
  final String purchaseOrder;

  const PurchaseOrderGeneratePdfSuccess({required this.purchaseOrder});

  @override
  List<Object> get props => [purchaseOrder];
}

class PurchaseOrderGeneratePdfFailed extends PurchaseOrderGeneratePdfState {
  final String error;

  const PurchaseOrderGeneratePdfFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class PurchaseOrderGeneratePdfEvent {}

class GetPurchaseOrderGeneratePdfEvent extends PurchaseOrderGeneratePdfEvent {
  final String purchaseOrderId;

  GetPurchaseOrderGeneratePdfEvent({required this.purchaseOrderId});
}

class PurchaseOrderGeneratePdfCubit extends Cubit<PurchaseOrderGeneratePdfState> {
  final GeneratePurchaseOrderPdfUseCase _generatePurchaseOrderPdfUseCase;

  PurchaseOrderGeneratePdfCubit(this._generatePurchaseOrderPdfUseCase)
      : super(PurchaseOrderGeneratePdfInitial());

  Future<void> onGetPurchaseOrderGeneratePdf({required String purchaseOrderId}) async {
    emit(PurchaseOrderGeneratePdfLoading());
    final dataState =
        await _generatePurchaseOrderPdfUseCase(params: purchaseOrderId);

    if (dataState is DataSuccess) {
      emit(PurchaseOrderGeneratePdfSuccess(
          purchaseOrder: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(PurchaseOrderGeneratePdfFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get purchase order pdf'));
    }
  }
}
