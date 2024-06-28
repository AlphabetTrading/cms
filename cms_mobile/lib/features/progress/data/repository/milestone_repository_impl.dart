import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/progress/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/progress/data/models/milestone.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/domain/repository/milestone_repository.dart';
import 'package:cms_mobile/features/projects/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/projects/data/models/project.dart';
import 'package:cms_mobile/features/projects/domain/repository/project_repository.dart';
import 'package:flutter/material.dart';

class MilestoneRepositoryImpl extends MilestoneRepository {
  final MilestoneDataSource dataSource;

  MilestoneRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<MilestoneModelListWithMeta>> getMilestones(
      {required GetMilestonesParamsEntity params}) {
    return dataSource.getMilestones(params: params);
  }

  @override
  Future<DataState<String>> createMilestone(
      {required CreateMilestoneParamsEntity params}) {
    return dataSource.createMilestone(
        createMilestoneParamsModel: CreateMilestoneParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<String>> deleteMilestone({required String milestoneId}) {
    return dataSource.deleteMilestone(milestoneId: milestoneId);
  }

  @override
  Future<DataState<String>> editMilestone(
      {required EditMilestoneParamsEntity params}) {
    return dataSource.editMilestone(
        editMilestoneParamsModel: EditMilestoneParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<MilestoneModel>> getMilestoneDetails(
      {required String params}) {
    return dataSource.getMilestoneDetails(params: params);
  }
}
