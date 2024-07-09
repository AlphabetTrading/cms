import 'package:cms_mobile/features/material_transactions/domain/usecases/material_proforma/delete_material_proforma.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class DeleteMaterialProformaState extends Equatable {
  const DeleteMaterialProformaState();

  @override
  List<Object> get props => [];
}

class DeleteMaterialProformaInitial extends DeleteMaterialProformaState {}

class DeleteMaterialProformaLoading extends DeleteMaterialProformaState {}

class DeleteMaterialProformaSuccess extends DeleteMaterialProformaState {
  final String materialProformaId;
  const DeleteMaterialProformaSuccess({required this.materialProformaId});
}

class DeleteMaterialProformaFailed extends DeleteMaterialProformaState {
  final String error;

  const DeleteMaterialProformaFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
class DeleteMaterialProformaEvent {
  final String materialProformaId;

  DeleteMaterialProformaEvent({required this.materialProformaId});
}

//cubit
class DeleteMaterialProformaCubit extends Cubit<DeleteMaterialProformaState> {
  final DeleteMaterialProformaUseCase _materialProformaDeleteUseCase;

  DeleteMaterialProformaCubit(this._materialProformaDeleteUseCase)
      : super(DeleteMaterialProformaInitial());

  void onMaterialProformaDelete({required String materialProformaId}) async {
    emit(DeleteMaterialProformaLoading());
    final dataState =
        await _materialProformaDeleteUseCase(params: materialProformaId);
    if (dataState is DataSuccess) {
      emit(DeleteMaterialProformaSuccess(
          materialProformaId: materialProformaId));
    } else if (dataState is DataFailed) {
      emit(DeleteMaterialProformaFailed(
          error: dataState.error?.errorMessage ??
              'Failed to delete material return '));
    }
  }
}
