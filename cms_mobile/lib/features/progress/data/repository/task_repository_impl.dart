import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/progress/data/data_source/task_remote_data_source.dart';
import 'package:cms_mobile/features/progress/data/models/task.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/domain/repository/task_repository.dart';


class TaskRepositoryImpl extends TaskRepository {
  final TaskDataSource dataSource;

  TaskRepositoryImpl({required this.dataSource});

  // @override
  // Future<DataState<TaskModelListWithMeta>> getTasks(
  //     {required GetTasksParamsEntity params}) {
  //   return dataSource.getTasks(params: params);
  // }

  @override
  Future<DataState<String>> createTask(
      {required CreateTaskParamsEntity params}) {
    return dataSource.createTask(
        createTaskParamsModel: CreateTaskParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<String>> deleteTask({required String taskId}) {
    return dataSource.deleteTask(taskId: taskId);
  }

  @override
  Future<DataState<String>> editTask(
      {required EditTaskParamsEntity params}) {
    return dataSource.editTask(
        editTaskParamsModel: EditTaskParamsModel.fromEntity(params));
  }

  // @override
  // Future<DataState<TaskModel>> getTaskDetails(
  //     {required String params}) {
  //   return dataSource.getTaskDetails(params: params);
  // }
}
