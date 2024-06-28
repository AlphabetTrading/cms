
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/domain/repository/milestone_repository.dart';

class EditMilestoneUseCase implements UseCase<String, EditMilestoneParamsEntity> {
  final MilestoneRepository repository;

  EditMilestoneUseCase(this.repository);

  @override
  Future<DataState<String>> call({EditMilestoneParamsEntity? params}) async {
    return await repository.editMilestone(
      params: params!,
    );
  }
}

