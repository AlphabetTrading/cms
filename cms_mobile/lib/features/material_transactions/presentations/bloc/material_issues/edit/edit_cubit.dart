import 'package:cms_mobile/features/material_transactions/domain/usecases/material_issue/edit_material_issue.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class EditMaterialIssueState extends Equatable {
  const EditMaterialIssueState();

  @override
  List<Object> get props => [];
}

class EditMaterialIssueInitial extends EditMaterialIssueState {}

class EditMaterialIssueLoading extends EditMaterialIssueState {}

class EditMaterialIssueSuccess extends EditMaterialIssueState {}

class EditMaterialIssueFailed extends EditMaterialIssueState {
  final String error;

  const EditMaterialIssueFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
// abstract class EditMaterialIssueEvent {}

class EditMaterialIssueEvent {
  final EditMaterialIssueParamsEntity editMaterialIssueParamsEntity;

  EditMaterialIssueEvent({required this.editMaterialIssueParamsEntity});
}

//cubit
class EditMaterialIssueCubit extends Cubit<EditMaterialIssueState> {
  final EditMaterialIssueUseCase _editMaterialIssueUseCase;

  EditMaterialIssueCubit(this._editMaterialIssueUseCase)
      : super(EditMaterialIssueInitial());

  void onEditMaterialIssue(
      {required EditMaterialIssueParamsEntity
          editMaterialIssueParamsEntity}) async {
    emit(EditMaterialIssueLoading());
    final dataState =
        await _editMaterialIssueUseCase(params: editMaterialIssueParamsEntity);
    if (dataState is DataSuccess) {
      emit(EditMaterialIssueSuccess());
    } else if (dataState is DataFailed) {
      emit(EditMaterialIssueFailed(
          error: dataState.error?.errorMessage ??
              'Failed to edit material issue '));
    }
  }
}
