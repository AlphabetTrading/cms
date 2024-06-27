
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/domain/repository/milestone_repository.dart';

class CreateMilestoneUseCase implements UseCase<String, CreateMilestoneParamsEntity> {
  final MilestoneRepository repository;

  CreateMilestoneUseCase(this.repository);

  @override
  Future<DataState<String>> call({CreateMilestoneParamsEntity? params}) async {
    return await repository.createMilestone(
      params: params!,
    );
  }
}

