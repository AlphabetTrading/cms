import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_transfer/edit_material_transfer.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class EditMaterialTransferState extends Equatable {
  const EditMaterialTransferState();

  @override
  List<Object> get props => [];
}

class EditMaterialTransferInitial extends EditMaterialTransferState {}

class EditMaterialTransferLoading extends EditMaterialTransferState {}

class EditMaterialTransferSuccess extends EditMaterialTransferState {}

class EditMaterialTransferFailed extends EditMaterialTransferState {
  final String error;

  const EditMaterialTransferFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
// abstract class EditMaterialTransferEvent {}

class EditMaterialTransferEvent {
  final EditMaterialTransferParamsEntity editMaterialTransferParamsEntity;

  EditMaterialTransferEvent({required this.editMaterialTransferParamsEntity});
}

//cubit
class EditMaterialTransferCubit extends Cubit<EditMaterialTransferState> {
  final EditMaterialTransferUseCase _editMaterialTransferUseCase;

  EditMaterialTransferCubit(this._editMaterialTransferUseCase)
      : super(EditMaterialTransferInitial());

  void onEditMaterialTransfer(
      {required EditMaterialTransferParamsEntity
          editMaterialTransferParamsEntity}) async {
    emit(EditMaterialTransferLoading());
    final dataState = await _editMaterialTransferUseCase(
        params: editMaterialTransferParamsEntity);
    if (dataState is DataSuccess) {
      emit(EditMaterialTransferSuccess());
    } else if (dataState is DataFailed) {
      emit(EditMaterialTransferFailed(
          error: dataState.error?.errorMessage ??
              'Failed to edit material issue '));
    }
  }
}
