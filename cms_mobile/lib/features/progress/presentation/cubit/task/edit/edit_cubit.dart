//state
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/domain/usecases/edit_task.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EditTaskState extends Equatable {
  const EditTaskState();

  @override
  List<Object> get props => [];
}

class EditTaskInitial extends EditTaskState {}

class EditTaskLoading extends EditTaskState {}

class EditTaskSuccess extends EditTaskState {
  const EditTaskSuccess();
}

class EditTaskFailed extends EditTaskState {
  final String error;

  const EditTaskFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
class EditTaskEvent {
  final EditTaskParamsEntity editTaskInput;

  EditTaskEvent({required this.editTaskInput});
}

//cubit
class EditTaskCubit extends Cubit<EditTaskState> {
  final EditTaskUseCase _materialIssueDeleteUseCase;

  EditTaskCubit(this._materialIssueDeleteUseCase)
      : super(EditTaskInitial());

  void onEditTask(
      {required EditTaskParamsEntity params}) async {
    emit(EditTaskLoading());
    final dataState = await _materialIssueDeleteUseCase(params: params);
    if (dataState is DataSuccess) {
      emit(EditTaskSuccess());
    } else if (dataState is DataFailed) {
      emit(EditTaskFailed(
          error:
              dataState.error?.errorMessage ?? 'Failed to edit task '));
    }
  }
}
