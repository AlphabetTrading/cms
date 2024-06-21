import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart'; 
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/domain/repository/milestone_repository.dart';

class GetMilestonesUseCase
    implements UseCase<MilestoneEntityListWithMeta, GetMilestonesParamsEntity?> {
  
  final MilestoneRepository _milestoneRepository;

  GetMilestonesUseCase(this._milestoneRepository);

  @override
  Future<DataState<MilestoneEntityListWithMeta>> call(
      {GetMilestonesParamsEntity? params}) {
    return _milestoneRepository.getMilestones(params: params!);
  }
}


