import 'package:cms_mobile/features/material_transactions/domain/usecases/material_return/delete_material_return.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class DeleteMaterialReturnState extends Equatable {
  const DeleteMaterialReturnState();

  @override
  List<Object> get props => [];
}

class DeleteMaterialReturnInitial extends DeleteMaterialReturnState {}

class DeleteMaterialReturnLoading extends DeleteMaterialReturnState {}

class DeleteMaterialReturnSuccess extends DeleteMaterialReturnState {
  const DeleteMaterialReturnSuccess();
}

class DeleteMaterialReturnFailed extends DeleteMaterialReturnState {
  final String error;

  const DeleteMaterialReturnFailed({required this.error});

  @override
  List<Object> get props => [error];
}


//event
class DeleteMaterialReturnEvent {
  final String materialReturnId;

  DeleteMaterialReturnEvent({required this.materialReturnId});
}


//cubit
class DeleteMaterialReturnCubit extends Cubit<DeleteMaterialReturnState> {
  final DeleteMaterialReturnUseCase _materialReturnDeleteUseCase;

  DeleteMaterialReturnCubit(this._materialReturnDeleteUseCase)
      : super(DeleteMaterialReturnInitial());

  void onMaterialReturnDelete({required String materialReturnId}) async {
    emit(DeleteMaterialReturnLoading());
    final dataState =
        await _materialReturnDeleteUseCase(params: materialReturnId);
    if (dataState is DataSuccess) {
      emit(DeleteMaterialReturnSuccess());
    } else if (dataState is DataFailed) {
      emit(DeleteMaterialReturnFailed(
          error: dataState.error?.errorMessage ??
              'Failed to delete material return '));
    }
  }
}
