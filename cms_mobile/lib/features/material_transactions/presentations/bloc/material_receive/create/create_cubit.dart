import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/create_material_receive.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class CreateMaterialReceiveState extends Equatable {
  const CreateMaterialReceiveState();

  @override
  List<Object> get props => [];
}

class CreateMaterialReceiveInitial extends CreateMaterialReceiveState {}

class CreateMaterialReceiveLoading extends CreateMaterialReceiveState {}

class CreateMaterialReceiveSuccess extends CreateMaterialReceiveState {}

class CreateMaterialReceiveFailed extends CreateMaterialReceiveState {
  final String error;

  const CreateMaterialReceiveFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
// abstract class CreateMaterialReceiveEvent {}

class CreateMaterialReceiveEvent {
  final CreateMaterialReceiveParamsEntity createMaterialReceiveParamsEntity;

  CreateMaterialReceiveEvent({required this.createMaterialReceiveParamsEntity});
}

//cubit
class CreateMaterialReceiveCubit extends Cubit<CreateMaterialReceiveState> {
  final CreateMaterialReceiveUseCase _createMaterialReceiveUseCase;

  CreateMaterialReceiveCubit(this._createMaterialReceiveUseCase)
      : super(CreateMaterialReceiveInitial());

  void onCreateMaterialReceive(
      {required CreateMaterialReceiveParamsEntity
          createMaterialReceiveParamsEntity}) async {
    emit(CreateMaterialReceiveLoading());
    final dataState = await _createMaterialReceiveUseCase(
        params: createMaterialReceiveParamsEntity);
    if (dataState is DataSuccess) {
      emit(CreateMaterialReceiveSuccess());
    } else if (dataState is DataFailed) {
      emit(CreateMaterialReceiveFailed(
          error: dataState.error?.errorMessage ??
              'Failed to create material issue '));
    }
  }
}
