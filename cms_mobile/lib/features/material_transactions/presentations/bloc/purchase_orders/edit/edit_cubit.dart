import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/edit_purchase_order.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class EditPurchaseOrderState extends Equatable {
  const EditPurchaseOrderState();

  @override
  List<Object> get props => [];
}

class EditPurchaseOrderInitial extends EditPurchaseOrderState {}

class EditPurchaseOrderLoading extends EditPurchaseOrderState {}

class EditPurchaseOrderSuccess extends EditPurchaseOrderState {}

class EditPurchaseOrderFailed extends EditPurchaseOrderState {
  final String error;

  const EditPurchaseOrderFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
// abstract class EditPurchaseOrderEvent {}

class EditPurchaseOrderEvent {
  final EditPurchaseOrderParamsEntity editPurchaseOrderParamsEntity;

  EditPurchaseOrderEvent({required this.editPurchaseOrderParamsEntity});
}

//cubit
class EditPurchaseOrderCubit extends Cubit<EditPurchaseOrderState> {
  final EditPurchaseOrderUseCase _editPurchaseOrderUseCase;

  EditPurchaseOrderCubit(this._editPurchaseOrderUseCase)
      : super(EditPurchaseOrderInitial());

  void onEditPurchaseOrder(
      {required EditPurchaseOrderParamsEntity
          editPurchaseOrderParamsEntity}) async {
    emit(EditPurchaseOrderLoading());
    final dataState =
        await _editPurchaseOrderUseCase(params: editPurchaseOrderParamsEntity);
    if (dataState is DataSuccess) {
      emit(EditPurchaseOrderSuccess());
    } else if (dataState is DataFailed) {
      emit(EditPurchaseOrderFailed(
          error: dataState.error?.errorMessage ??
              'Failed to edit material issue '));
    }
  }
}
