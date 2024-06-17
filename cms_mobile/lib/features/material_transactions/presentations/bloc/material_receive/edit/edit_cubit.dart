import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/edit_material_receiving.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class EditMaterialReceiveState extends Equatable {
  const EditMaterialReceiveState();

  @override
  List<Object> get props => [];
}

class EditMaterialReceiveInitial extends EditMaterialReceiveState {}

class EditMaterialReceiveLoading extends EditMaterialReceiveState {}

class EditMaterialReceiveSuccess extends EditMaterialReceiveState {}

class EditMaterialReceiveFailed extends EditMaterialReceiveState {
  final String error;

  const EditMaterialReceiveFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
// abstract class EditMaterialReceiveEvent {}

class EditMaterialReceiveEvent {
  final EditMaterialReceiveParamsEntity editMaterialReceiveParamsEntity;

  EditMaterialReceiveEvent({required this.editMaterialReceiveParamsEntity});
}

//cubit
class EditMaterialReceiveCubit extends Cubit<EditMaterialReceiveState> {
  final EditMaterialReceiveUseCase _editMaterialReceiveUseCase;

  EditMaterialReceiveCubit(this._editMaterialReceiveUseCase)
      : super(EditMaterialReceiveInitial());

  void onEditMaterialReceive(
      {required EditMaterialReceiveParamsEntity
          editMaterialReceiveParamsEntity}) async {
    emit(EditMaterialReceiveLoading());
    final dataState = await _editMaterialReceiveUseCase(
        params: editMaterialReceiveParamsEntity);
    if (dataState is DataSuccess) {
      emit(EditMaterialReceiveSuccess());
    } else if (dataState is DataFailed) {
      emit(EditMaterialReceiveFailed(
          error: dataState.error?.errorMessage ??
              'Failed to edit material issue '));
    }
  }
}
