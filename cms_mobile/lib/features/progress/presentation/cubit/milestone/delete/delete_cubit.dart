//state
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/domain/usecases/delete_milestone.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeleteMilestoneState extends Equatable {
  const DeleteMilestoneState();

  @override
  List<Object> get props => [];
}

class DeleteMilestoneInitial extends DeleteMilestoneState {}

class DeleteMilestoneLoading extends DeleteMilestoneState {}

class DeleteMilestoneSuccess extends DeleteMilestoneState {
  const DeleteMilestoneSuccess();
}

class DeleteMilestoneFailed extends DeleteMilestoneState {
  final String error;

  const DeleteMilestoneFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
class DeleteMilestoneEvent {
  final String milestoneId;

  DeleteMilestoneEvent({required this.milestoneId});
}

//cubit
class DeleteMilestoneCubit extends Cubit<DeleteMilestoneState> {
  final DeleteMilestoneUseCase _materialIssueDeleteUseCase;

  DeleteMilestoneCubit(this._materialIssueDeleteUseCase)
      : super(DeleteMilestoneInitial());

  void onDeleteMilestone(
      {required String milestoneId}) async {
    emit(DeleteMilestoneLoading());
    final dataState = await _materialIssueDeleteUseCase(params: milestoneId);
    if (dataState is DataSuccess) {
      emit(DeleteMilestoneSuccess());
    } else if (dataState is DataFailed) {
      emit(DeleteMilestoneFailed(
          error:
              dataState.error?.errorMessage ?? 'Failed to delete milestone '));
    }
  }
}
