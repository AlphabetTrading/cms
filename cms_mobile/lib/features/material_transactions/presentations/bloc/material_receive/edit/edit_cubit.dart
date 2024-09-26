import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/approve_material_receive.dart';
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
  final String editMaterialReceiveParamsEntity;

  EditMaterialReceiveEvent({required this.editMaterialReceiveParamsEntity});
}

//cubit
class EditMaterialReceiveCubit extends Cubit<EditMaterialReceiveState> {
  final EditMaterialReceiveUseCase editMaterialReceiveUseCase;
  final ApproveMaterialReceiveUseCase approveMaterialReceiveUseCase;


  EditMaterialReceiveCubit({required this.editMaterialReceiveUseCase, required this.approveMaterialReceiveUseCase})
      : super(EditMaterialReceiveInitial());

  void onApproveMaterialReceive(
      {required ApproveMaterialReceiveParamsEntity params}) async {
    emit(EditMaterialReceiveLoading());
    final dataState = await approveMaterialReceiveUseCase(
        params: params);
    if (dataState is DataSuccess) {
      emit(EditMaterialReceiveSuccess());
    } else if (dataState is DataFailed) {
      emit(EditMaterialReceiveFailed(
          error: dataState.error?.errorMessage ??
              'Failed to edit material receive'));
    }
  }
}
