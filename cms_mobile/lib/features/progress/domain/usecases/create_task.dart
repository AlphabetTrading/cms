
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/domain/repository/task_repository.dart';

class CreateTaskUseCase implements UseCase<String, CreateTaskParamsEntity> {
  final TaskRepository repository;

  CreateTaskUseCase(this.repository);

  @override
  Future<DataState<String>> call({CreateTaskParamsEntity? params}) async {
    return await repository.createTask(
      params: params!,
    );
  }
}

