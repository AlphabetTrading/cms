//state
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/domain/usecases/edit_milestone.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EditMilestoneState extends Equatable {
  const EditMilestoneState();

  @override
  List<Object> get props => [];
}

class EditMilestoneInitial extends EditMilestoneState {}

class EditMilestoneLoading extends EditMilestoneState {}

class EditMilestoneSuccess extends EditMilestoneState {
  const EditMilestoneSuccess();
}

class EditMilestoneFailed extends EditMilestoneState {
  final String error;

  const EditMilestoneFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
class EditMilestoneEvent {
  final EditMilestoneParamsEntity editMilestoneInput;

  EditMilestoneEvent({required this.editMilestoneInput});
}

//cubit
class EditMilestoneCubit extends Cubit<EditMilestoneState> {
  final EditMilestoneUseCase _materialIssueDeleteUseCase;

  EditMilestoneCubit(this._materialIssueDeleteUseCase)
      : super(EditMilestoneInitial());

  void onEditMilestone(
      {required EditMilestoneParamsEntity params}) async {
    emit(EditMilestoneLoading());
    final dataState = await _materialIssueDeleteUseCase(params: params);
    if (dataState is DataSuccess) {
      emit(EditMilestoneSuccess());
    } else if (dataState is DataFailed) {
      emit(EditMilestoneFailed(
          error:
              dataState.error?.errorMessage ?? 'Failed to edit milestone '));
    }
  }
}
