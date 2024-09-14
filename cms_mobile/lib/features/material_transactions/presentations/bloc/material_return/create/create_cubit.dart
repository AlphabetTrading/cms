import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_return/create_material_return.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class CreateMaterialReturnState extends Equatable {
  const CreateMaterialReturnState();

  @override
  List<Object> get props => [];
}

class CreateMaterialReturnInitial extends CreateMaterialReturnState {}

class CreateMaterialReturnLoading extends CreateMaterialReturnState {}

class CreateMaterialReturnSuccess extends CreateMaterialReturnState {}

class CreateMaterialReturnFailed extends CreateMaterialReturnState {
  final String error;

  const CreateMaterialReturnFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
// abstract class CreateMaterialReturnEvent {}

class CreateMaterialReturnEvent {
  final CreateMaterialReturnParamsEntity createMaterialReturnParamsEntity;

  CreateMaterialReturnEvent({required this.createMaterialReturnParamsEntity});
}

//cubit
class CreateMaterialReturnCubit extends Cubit<CreateMaterialReturnState> {
  final CreateMaterialReturnUseCase _createMaterialReturnUseCase;

  CreateMaterialReturnCubit(this._createMaterialReturnUseCase)
      : super(CreateMaterialReturnInitial());

  void onCreateMaterialReturn(
      {required CreateMaterialReturnParamsEntity
          createMaterialReturnParamsEntity}) async {
    emit(CreateMaterialReturnLoading());
    final dataState = await _createMaterialReturnUseCase(
        params: createMaterialReturnParamsEntity);
    if (dataState is DataSuccess) {
      emit(CreateMaterialReturnSuccess());
    } else if (dataState is DataFailed) {
      emit(CreateMaterialReturnFailed(
          error: dataState.error?.errorMessage ??
              'Failed to create material proforma '));

    }
  }
}
