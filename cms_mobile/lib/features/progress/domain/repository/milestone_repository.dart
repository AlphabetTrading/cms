import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';

abstract class MilestoneRepository {
  Future<DataState<String>> createMilestone(
      {required CreateMilestoneParamsEntity params});
  
  Future<DataState<MilestoneEntityListWithMeta>> getMilestones(
      {required GetMilestonesParamsEntity params});

  Future<DataState<MilestoneEntity>> getMilestoneDetails(
      {required String params});

  Future<DataState<String>> editMilestone(
      {required EditMilestoneParamsEntity params});

  Future<DataState<String>> deleteMilestone({required String milestoneId});
}
