//state
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/domain/usecases/create_task.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CreateTaskState extends Equatable {
  const CreateTaskState();

  @override
  List<Object> get props => [];
}

class CreateTaskInitial extends CreateTaskState {}

class CreateTaskLoading extends CreateTaskState {}

class CreateTaskSuccess extends CreateTaskState {
  const CreateTaskSuccess();
}

class CreateTaskFailed extends CreateTaskState {
  final String error;

  const CreateTaskFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
class CreateTaskEvent {
  final CreateTaskParamsEntity createTaskInput;

  CreateTaskEvent({required this.createTaskInput});
}

//cubit
class CreateTaskCubit extends Cubit<CreateTaskState> {
  final CreateTaskUseCase _materialIssueDeleteUseCase;

  CreateTaskCubit(this._materialIssueDeleteUseCase)
      : super(CreateTaskInitial());

  void onCreateTask(
      {required CreateTaskParamsEntity params}) async {
    emit(CreateTaskLoading());
    final dataState = await _materialIssueDeleteUseCase(params: params);
    if (dataState is DataSuccess) {
      emit(CreateTaskSuccess());
    } else if (dataState is DataFailed) {
      emit(CreateTaskFailed(
          error:
              dataState.error?.errorMessage ?? 'Failed to create task '));
    }
  }
}
