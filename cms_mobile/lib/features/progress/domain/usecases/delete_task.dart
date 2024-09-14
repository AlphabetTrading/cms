
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/progress/domain/repository/task_repository.dart';

class DeleteTaskUseCase implements UseCase<String, String> {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  @override
  Future<DataState<String>> call({String? params}) async {
    return await repository.deleteTask(
      taskId: params!,
    );
  }
}

