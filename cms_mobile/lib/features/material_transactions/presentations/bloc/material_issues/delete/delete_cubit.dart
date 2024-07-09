import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/delete_material_issue.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class DeleteMaterialIssueState extends Equatable {
  const DeleteMaterialIssueState();

  @override
  List<Object> get props => [];
}

class DeleteMaterialIssueInitial extends DeleteMaterialIssueState {}

class DeleteMaterialIssueLoading extends DeleteMaterialIssueState {}

class DeleteMaterialIssueSuccess extends DeleteMaterialIssueState {
  final String materialIssueId;
  const DeleteMaterialIssueSuccess({required this.materialIssueId});
}

class DeleteMaterialIssueFailed extends DeleteMaterialIssueState {
  final String error;

  const DeleteMaterialIssueFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
class DeleteMaterialIssueEvent {
  final String materialIssueId;

  DeleteMaterialIssueEvent({required this.materialIssueId});
}

//cubit
class DeleteMaterialIssueCubit extends Cubit<DeleteMaterialIssueState> {
  final DeleteMaterialIssueUseCase _materialIssueDeleteUseCase;

  DeleteMaterialIssueCubit(this._materialIssueDeleteUseCase)
      : super(DeleteMaterialIssueInitial());

  void onMaterialIssueDelete({required String materialIssueId}) async {
    emit(DeleteMaterialIssueLoading());
    final dataState =
        await _materialIssueDeleteUseCase(params: materialIssueId);
    if (dataState is DataSuccess) {
      emit(DeleteMaterialIssueSuccess(materialIssueId: materialIssueId));
    } else if (dataState is DataFailed) {
      emit(DeleteMaterialIssueFailed(
          error: dataState.error?.errorMessage ??
              'Failed to delete material return '));
    }
  }
}
