import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/domain/repository/milestone_repository.dart';

class GetMilestoneDetailsUseCase
    implements UseCase<MilestoneEntity, String?> {
  
  final MilestoneRepository _milestoneRepository;

  GetMilestoneDetailsUseCase(this._milestoneRepository);

  @override
  Future<DataState<MilestoneEntity>> call(
      {String? params}) {
    return _milestoneRepository.getMilestoneDetails(params: params!);
  }
}
