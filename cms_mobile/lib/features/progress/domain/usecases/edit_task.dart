
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/domain/repository/task_repository.dart';

class EditTaskUseCase implements UseCase<String, EditTaskParamsEntity> {
  final TaskRepository repository;

  EditTaskUseCase(this.repository);

  @override
  Future<DataState<String>> call({EditTaskParamsEntity? params}) async {
    return await repository.editTask(
      params: params!,
    );
  }
}

