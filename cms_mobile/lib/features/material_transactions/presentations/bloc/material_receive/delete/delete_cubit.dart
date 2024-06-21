import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/delete_material_receive.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialReceiveDeleteState extends Equatable {
  const MaterialReceiveDeleteState();

  @override
  List<Object> get props => [];
}

class MaterialReceiveDeleteInitial extends MaterialReceiveDeleteState {}

class MaterialReceiveDeleteLoading extends MaterialReceiveDeleteState {}

class MaterialReceiveDeleteSuccess extends MaterialReceiveDeleteState {
  const MaterialReceiveDeleteSuccess();
}

class MaterialReceiveDeleteFailed extends MaterialReceiveDeleteState {
  final String error;

  const MaterialReceiveDeleteFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class MaterialReceiveDeleteEvent {
  final String materialReceiveId;

  MaterialReceiveDeleteEvent({required this.materialReceiveId});
}

class MaterialReceiveDeleteCubit extends Cubit<MaterialReceiveDeleteState> {
  final DeleteMaterialReceiveUseCase _materialReceiveDeleteUseCase;

  MaterialReceiveDeleteCubit(this._materialReceiveDeleteUseCase)
      : super(MaterialReceiveDeleteInitial());

  void onMaterialReceiveDelete({required String materialReceiveId}) async {
    emit(MaterialReceiveDeleteLoading());
    final dataState =
        await _materialReceiveDeleteUseCase(params: materialReceiveId);
    if (dataState is DataSuccess) {
      emit(MaterialReceiveDeleteSuccess());
    } else if (dataState is DataFailed) {
      emit(MaterialReceiveDeleteFailed(
          error: dataState.error?.errorMessage ??
              'Failed to delete material issue '));
    }
  }
}
