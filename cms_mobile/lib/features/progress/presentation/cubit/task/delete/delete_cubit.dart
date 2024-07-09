//state
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/domain/usecases/delete_task.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeleteTaskState extends Equatable {
  const DeleteTaskState();

  @override
  List<Object> get props => [];
}

class DeleteTaskInitial extends DeleteTaskState {}

class DeleteTaskLoading extends DeleteTaskState {}

class DeleteTaskSuccess extends DeleteTaskState {
  const DeleteTaskSuccess();
}

class DeleteTaskFailed extends DeleteTaskState {
  final String error;

  const DeleteTaskFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
class DeleteTaskEvent {
  final String taskId;

  DeleteTaskEvent({required this.taskId});
}

//cubit
class DeleteTaskCubit extends Cubit<DeleteTaskState> {
  final DeleteTaskUseCase _materialIssueDeleteUseCase;

  DeleteTaskCubit(this._materialIssueDeleteUseCase)
      : super(DeleteTaskInitial());

  void onDeleteTask(
      {required String taskId}) async {
    emit(DeleteTaskLoading());
    final dataState = await _materialIssueDeleteUseCase(params: taskId);
    if (dataState is DataSuccess) {
      emit(DeleteTaskSuccess());
    } else if (dataState is DataFailed) {
      emit(DeleteTaskFailed(
          error:
              dataState.error?.errorMessage ?? 'Failed to delete task '));
    }
  }
}
