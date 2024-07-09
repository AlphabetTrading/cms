import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';

abstract class TaskRepository {
  Future<DataState<String>> createTask(
      {required CreateTaskParamsEntity params});
  
  // Future<DataState<TaskEntityListWithMeta>> getTasks(
  //     {required GetTasksParamsEntity params});

  // Future<DataState<TaskEntity>> getTaskDetails(
  //     {required String params});

  Future<DataState<String>> editTask(
      {required EditTaskParamsEntity params});

  Future<DataState<String>> deleteTask({required String taskId});
}
