import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/purchase_order/create_purchase_order.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class CreatePurchaseOrderState extends Equatable {
  const CreatePurchaseOrderState();

  @override
  List<Object> get props => [];
}

class CreatePurchaseOrderInitial extends CreatePurchaseOrderState {}

class CreatePurchaseOrderLoading extends CreatePurchaseOrderState {}

class CreatePurchaseOrderSuccess extends CreatePurchaseOrderState {}

class CreatePurchaseOrderFailed extends CreatePurchaseOrderState {
  final String error;

  const CreatePurchaseOrderFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
// abstract class CreatePurchaseOrderEvent {}

class CreatePurchaseOrderEvent {
  final CreatePurchaseOrderParamsEntity createPurchaseOrderParamsEntity;

  CreatePurchaseOrderEvent({required this.createPurchaseOrderParamsEntity});
}

//cubit
class CreatePurchaseOrderCubit extends Cubit<CreatePurchaseOrderState> {
  final CreatePurchaseOrderUseCase _createPurchaseOrderUseCase;

  CreatePurchaseOrderCubit(this._createPurchaseOrderUseCase)
      : super(CreatePurchaseOrderInitial());

  void onCreatePurchaseOrder(
      {required CreatePurchaseOrderParamsEntity
          createPurchaseOrderParamsEntity}) async {
    emit(CreatePurchaseOrderLoading());
    final dataState =
        await _createPurchaseOrderUseCase(params: createPurchaseOrderParamsEntity);
    if (dataState is DataSuccess) {
      emit(CreatePurchaseOrderSuccess());
    } else if (dataState is DataFailed) {
      emit(CreatePurchaseOrderFailed(
          error: dataState.error?.errorMessage ??
              'Failed to create material issue '));
    }
  }
}
