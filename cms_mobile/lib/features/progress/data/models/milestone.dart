import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/progress/data/models/task.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';

class MilestoneModel extends MilestoneEntity {
  const MilestoneModel({
    required String? id,
    required double? progress,
    required String? stage,
    required DateTime? dueDate,
    required DateTime? createdAt,
    required String? name,
    required UserModel? createdBy,
    required String? description,
    required List<TaskModel>? tasks,
  }) : super(
          id: id,
          progress: progress,
          stage: stage,
          dueDate: dueDate,
          createdAt: createdAt,
          name: name,
          createdBy: createdBy,
          description: description,
          tasks: tasks,
        );
  factory MilestoneModel.fromJson(Map<String, dynamic> json) {
    return MilestoneModel(
        id: json['id'],
        progress: json['progress'],
        stage: json['stage'],
        dueDate:
            json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        name: json['name'],
        createdBy: json['createdBy'] != null
            ? UserModel.fromJson(json['createdBy'])
            : null,
        description: json['description'],
        tasks: json['tasks'] != null
            ? json['tasks']
                .map<TaskModel>((item) => TaskModel.fromJson(item))
                .toList() as List<TaskModel>
            : null);
  }
}

class MilestoneModelListWithMeta extends MilestoneEntityListWithMeta {
  MilestoneModelListWithMeta({
    required Meta meta,
    required List<MilestoneModel> items,
  }) : super(meta: meta, items: items);
  factory MilestoneModelListWithMeta.fromJson(Map<String, dynamic> json) {
    return MilestoneModelListWithMeta(
        meta: Meta.fromJson(json['meta']),
        items: json['items']
            .map<MilestoneModel>((item) => MilestoneModel.fromJson(item))
            .toList() as List<MilestoneModel>);
  }
}

class CreateMilestoneParamsModel extends CreateMilestoneParamsEntity {}

class EditMilestoneParamsModel extends EditMilestoneParamsEntity {}

class GetMilestoneParamsModel extends GetMilestonesParamsEntity {
  GetMilestoneParamsModel(
      {required super.filterMilestoneInput,
      required super.paginationInput,
      required super.orderBy});
}
