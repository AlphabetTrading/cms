import 'package:cms_mobile/features/material_transactions/domain/usecases/material_request/delete_material_request.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialRequestDeleteState extends Equatable {
  const MaterialRequestDeleteState();

  @override
  List<Object> get props => [];
}

class MaterialRequestDeleteInitial extends MaterialRequestDeleteState {}

class MaterialRequestDeleteLoading extends MaterialRequestDeleteState {}

class MaterialRequestDeleteSuccess extends MaterialRequestDeleteState {
  const MaterialRequestDeleteSuccess();
}

class MaterialRequestDeleteFailed extends MaterialRequestDeleteState {
  final String error;

  const MaterialRequestDeleteFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class MaterialRequestDeleteEvent {
  final String materialRequestId;

  MaterialRequestDeleteEvent({required this.materialRequestId});
}

class MaterialRequestDeleteCubit extends Cubit<MaterialRequestDeleteState> {
  final DeleteMaterialRequestUseCase _materialRequestDeleteUseCase;

  MaterialRequestDeleteCubit(this._materialRequestDeleteUseCase)
      : super(MaterialRequestDeleteInitial());

  void onMaterialRequestDelete({required String materialRequestId}) async {
    emit(MaterialRequestDeleteLoading());
    final dataState =
        await _materialRequestDeleteUseCase(params: materialRequestId);
    if (dataState is DataSuccess) {
      emit(MaterialRequestDeleteSuccess());
    } else if (dataState is DataFailed) {
      emit(MaterialRequestDeleteFailed(
          error: dataState.error?.errorMessage ??
              'Failed to delete material request '));
    }
  }
}
