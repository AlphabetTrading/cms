import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/delete_material_receive.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeleteMaterialReceiveState extends Equatable {
  const DeleteMaterialReceiveState();

  @override
  List<Object> get props => [];
}

class DeleteMaterialReceiveInitial extends DeleteMaterialReceiveState {}

class DeleteMaterialReceiveLoading extends DeleteMaterialReceiveState {}

class DeleteMaterialReceiveSuccess extends DeleteMaterialReceiveState {
  const DeleteMaterialReceiveSuccess();
}

class DeleteMaterialReceiveFailed extends DeleteMaterialReceiveState {
  final String error;

  const DeleteMaterialReceiveFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class DeleteMaterialReceiveEvent {
  final String materialReceiveId;

  DeleteMaterialReceiveEvent({required this.materialReceiveId});
}

class DeleteMaterialReceiveCubit extends Cubit<DeleteMaterialReceiveState> {
  final DeleteMaterialReceiveUseCase _materialReceiveDeleteUseCase;

  DeleteMaterialReceiveCubit(this._materialReceiveDeleteUseCase)
      : super(DeleteMaterialReceiveInitial());

  void onDeleteMaterialReceive({required String materialReceiveId}) async {
    // print('DeleteMaterialReceiveCubit ${materialReceiveId}');
    emit(DeleteMaterialReceiveLoading());
    final dataState =
        await _materialReceiveDeleteUseCase(params: materialReceiveId);
    if (dataState is DataSuccess) {
    // print('DeleteMaterialReceiveCubit Success');
      emit(DeleteMaterialReceiveSuccess());
    } else if (dataState is DataFailed) {
    // print('DeleteMaterialReceiveCubit Failed');
      emit(DeleteMaterialReceiveFailed(
          error: dataState.error?.errorMessage ??
              'Failed to delete material issue '));
    }
  }
}
