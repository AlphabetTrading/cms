import 'package:cms_mobile/features/material_transactions/domain/usecases/material_transfer/delete_material_transfer.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialTransferDeleteState extends Equatable {
  const MaterialTransferDeleteState();

  @override
  List<Object> get props => [];
}

class MaterialTransferDeleteInitial extends MaterialTransferDeleteState {}

class MaterialTransferDeleteLoading extends MaterialTransferDeleteState {}

class MaterialTransferDeleteSuccess extends MaterialTransferDeleteState {
  const MaterialTransferDeleteSuccess();
}

class MaterialTransferDeleteFailed extends MaterialTransferDeleteState {
  final String error;

  const MaterialTransferDeleteFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class MaterialTransferDeleteEvent {
  final String materialTransferId;

  MaterialTransferDeleteEvent({required this.materialTransferId});
}

class MaterialTransferDeleteCubit extends Cubit<MaterialTransferDeleteState> {
  final DeleteMaterialTransferUseCase _materialTransferDeleteUseCase;

  MaterialTransferDeleteCubit(this._materialTransferDeleteUseCase)
      : super(MaterialTransferDeleteInitial());

  void onMaterialTransferDelete({required String materialTransferId}) async {
    emit(MaterialTransferDeleteLoading());
    final dataState =
        await _materialTransferDeleteUseCase(params: materialTransferId);
    if (dataState is DataSuccess) {
      emit(MaterialTransferDeleteSuccess());
    } else if (dataState is DataFailed) {
      emit(MaterialTransferDeleteFailed(
          error: dataState.error?.errorMessage ??
              'Failed to delete material issue '));
    }
  }
}
