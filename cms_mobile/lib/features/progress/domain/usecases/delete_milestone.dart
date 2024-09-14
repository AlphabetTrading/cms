
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/progress/domain/repository/milestone_repository.dart';

class DeleteMilestoneUseCase implements UseCase<String, String> {
  final MilestoneRepository repository;

  DeleteMilestoneUseCase(this.repository);

  @override
  Future<DataState<String>> call({String? params}) async {
    return await repository.deleteMilestone(
      milestoneId: params!,
    );
  }
}

