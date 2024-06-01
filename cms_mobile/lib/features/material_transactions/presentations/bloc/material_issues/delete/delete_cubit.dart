import 'package:cms_mobile/features/material_transactions/domain/usecases/delete_material_issue.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialIssueDeleteState extends Equatable {
  const MaterialIssueDeleteState();

  @override
  List<Object> get props => [];
}

class MaterialIssueDeleteInitial extends MaterialIssueDeleteState {}

class MaterialIssueDeleteLoading extends MaterialIssueDeleteState {}

class MaterialIssueDeleteSuccess extends MaterialIssueDeleteState {
  const MaterialIssueDeleteSuccess();
}

class MaterialIssueDeleteFailed extends MaterialIssueDeleteState {
  final String error;

  const MaterialIssueDeleteFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class MaterialIssueDeleteEvent {
  final String materialIssueId;

  MaterialIssueDeleteEvent({required this.materialIssueId});
}

class MaterialIssueDeleteCubit extends Cubit<MaterialIssueDeleteState> {
  final DeleteMaterialIssueUseCase _materialIssueDeleteUseCase;

  MaterialIssueDeleteCubit(this._materialIssueDeleteUseCase)
      : super(MaterialIssueDeleteInitial());

  void onMaterialIssueDelete({required String materialIssueId}) async {
    emit(MaterialIssueDeleteLoading());
    final dataState =
        await _materialIssueDeleteUseCase(params: materialIssueId);
    if (dataState is DataSuccess) {
      emit(MaterialIssueDeleteSuccess());
    } else if (dataState is DataFailed) {
      emit(MaterialIssueDeleteFailed(
          error: dataState.error?.errorMessage ??
              'Failed to delete material issue '));
    }
  }
}
