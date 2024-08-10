import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_proforma/create_material_proforma.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class CreateMaterialProformaState extends Equatable {
  const CreateMaterialProformaState();

  @override
  List<Object> get props => [];
}

class CreateMaterialProformaInitial extends CreateMaterialProformaState {}

class CreateMaterialProformaLoading extends CreateMaterialProformaState {}

class CreateMaterialProformaSuccess extends CreateMaterialProformaState {}

class CreateMaterialProformaFailed extends CreateMaterialProformaState {
  final String error;

  const CreateMaterialProformaFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
// abstract class CreateMaterialProformaEvent {}

class CreateMaterialProformaEvent {
  final CreateMaterialProformaParamsEntity createMaterialProformaParamsEntity;

  CreateMaterialProformaEvent({required this.createMaterialProformaParamsEntity});
}

//cubit
class CreateMaterialProformaCubit extends Cubit<CreateMaterialProformaState> {
  final CreateMaterialProformaUseCase _createMaterialProformaUseCase;

  CreateMaterialProformaCubit(this._createMaterialProformaUseCase)
      : super(CreateMaterialProformaInitial());

  void onCreateMaterialProforma(
      {required CreateMaterialProformaParamsEntity
          createMaterialProformaParamsEntity}) async {
    emit(CreateMaterialProformaLoading());
    final dataState = await _createMaterialProformaUseCase(
        params: createMaterialProformaParamsEntity);
    if (dataState is DataSuccess) {
      emit(CreateMaterialProformaSuccess());
    } else if (dataState is DataFailed) {
      emit(CreateMaterialProformaFailed(
          error: dataState.error?.errorMessage ??
              'Failed to create material proforma '));

    }
  }
}
