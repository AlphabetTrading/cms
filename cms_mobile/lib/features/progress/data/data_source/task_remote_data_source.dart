import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/progress/data/models/task.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class TaskDataSource {
  Future<DataState<String>> createTask(
      {required CreateTaskParamsModel createTaskParamsModel});

  // Future<DataState<TaskModelListWithMeta>> getTasks(
  //     {required GetTasksParamsEntity params});

  // Future<DataState<TaskModel>> getTaskDetails(
  //     {required String params});

  Future<DataState<String>> editTask(
      {required EditTaskParamsModel editTaskParamsModel});

  Future<DataState<String>> deleteTask({required String taskId});
}

class TaskDataSourceImpl extends TaskDataSource {
  late final GraphQLClient _client;
// Define the mutation
  TaskDataSourceImpl({required GraphQLClient client}) {
    _client = client;
  }

  static const String _createTaskMutation = r'''
mutation CreateTask($createTaskInput: CreateTaskInput!) {
  createTask(createTaskInput: $createTaskInput) {
    id
  }
}

  ''';

  static const String _deleteTaskMutation = r'''
mutation DeleteTask($deleteTaskId: String!) {
  deleteTask(id: $deleteTaskId) {
    id
  }
}
''';

  static const String _editTaskMutation = r'''
mutation UpdateTask($updateTaskInput: UpdateTaskInput!) {
  updateTask(updateTaskInput: $updateTaskInput) {
    id
  }
}
''';

  // Override the function in the implementation class
  @override
  Future<DataState<String>> createTask(
      {required CreateTaskParamsModel createTaskParamsModel}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_createTaskMutation),
      variables: {"createTaskInput": createTaskParamsModel.toJson()},
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['createTask']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  // @override
  // Future<DataState<TaskModelListWithMeta>> getTasks(
  //     {required GetTasksParamsEntity params}) {
  //   String fetchTasksQuery = r'''

  //   ''';

  //   return _client
  //       .query(QueryOptions(
  //     document: gql(fetchTasksQuery),
  //     fetchPolicy: FetchPolicy.networkOnly
    
  //     // variables: {"": params},
  //   ))
  //       .then((response) {
  //     if (response.hasException) {
  //       return DataFailed(
  //         ServerFailure(
  //           errorMessage: response.exception.toString(),
  //         ),
  //       );
  //     }
  //     final materialIssue =
  //         TaskModelListWithMeta.fromJson(response.data!['getTasks']);

  //     return DataSuccess(materialIssue);
  //   });
  // }


  // @override
  // Future<DataState<TaskModel>> getTaskDetails(
  //     {required String params}) {
  //   String fetchTaskDetailsQuery = r'''

  //   ''';

  //   return _client
  //       .query(QueryOptions(
  //     document: gql(fetchTaskDetailsQuery),
  //     variables: {"getTaskId": params},
  //   ))
  //       .then((response) {
  //     if (response.hasException) {
  //       return DataFailed(
  //         ServerFailure(
  //           errorMessage: response.exception.toString(),
  //         ),
  //       );
  //     }

  //     final task = TaskModel.fromJson(response.data!['getTask']);

  //     return DataSuccess(task);
  //   });
  // }

  @override
  Future<DataState<String>> editTask(
      {required EditTaskParamsModel editTaskParamsModel}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_editTaskMutation),
      variables: {"updateTaskInput": editTaskParamsModel.toJson()},
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['updateTask']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<DataState<String>> deleteTask(
      {required String taskId}) async {
    final MutationOptions options = MutationOptions(
      document: gql(_deleteTaskMutation),
      variables: {"deleteTaskId": taskId},
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return DataFailed(
            ServerFailure(errorMessage: result.exception.toString()));
      }

      // Assuming `MaterialRequestModel.fromJson` is a constructor to parse JSON into a model
      final String id = result.data!['deleteTask']['id'];

      return DataSuccess(id);
    } catch (e) {
      // In case of any other errors, return a DataFailed state
      return DataFailed(ServerFailure(errorMessage: e.toString()));
    }
  }
}
