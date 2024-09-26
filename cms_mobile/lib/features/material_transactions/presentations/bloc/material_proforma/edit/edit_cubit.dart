import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_proforma/approve_material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_proforma/edit_material_proforma.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class EditMaterialProformaState extends Equatable {
  const EditMaterialProformaState();

  @override
  List<Object> get props => [];
}

class EditMaterialProformaInitial extends EditMaterialProformaState {}

class EditMaterialProformaLoading extends EditMaterialProformaState {}

class EditMaterialProformaSuccess extends EditMaterialProformaState {}

class EditMaterialProformaFailed extends EditMaterialProformaState {
  final String error;

  const EditMaterialProformaFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
// abstract class EditMaterialProformaEvent {}

class EditMaterialProformaEvent {
  final String editMaterialProformaParamsEntity;

  EditMaterialProformaEvent({required this.editMaterialProformaParamsEntity});
}

//cubit
class EditMaterialProformaCubit extends Cubit<EditMaterialProformaState> {
  final EditMaterialProformaUseCase editMaterialProformaUseCase;
  final ApproveMaterialProformaUseCase approveMaterialProformaUseCase;


  EditMaterialProformaCubit({required this.editMaterialProformaUseCase, required this.approveMaterialProformaUseCase})
      : super(EditMaterialProformaInitial());

  void onApproveMaterialProforma(
      {required ApproveMaterialProformaParamsEntity params}) async {
    emit(EditMaterialProformaLoading());
    final dataState = await approveMaterialProformaUseCase(
        params: params);
    if (dataState is DataSuccess) {
      emit(EditMaterialProformaSuccess());
    } else if (dataState is DataFailed) {
      emit(EditMaterialProformaFailed(
          error: dataState.error?.errorMessage ??
              'Failed to edit material proforma'));
    }
  }
}
