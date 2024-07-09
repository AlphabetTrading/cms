import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:cms_mobile/features/progress/data/models/task.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';

class MilestoneModel extends MilestoneEntity {
  const MilestoneModel({
    required String? id,
    required double? progress,
    required UseType? stage,
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
        progress: json['progress'].toDouble(),
        stage: useTypeFromString(json['stage']),
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
        tasks: json['Tasks'] != null
            ? json['Tasks']
                .map<TaskModel>((item) => TaskModel.fromJson(item))
                .toList() as List<TaskModel>
            : null);
  }
}

class MilestoneModelListWithMeta extends MilestoneEntityListWithMeta {
  MilestoneModelListWithMeta({
    required MetaModel super.meta,
    required List<MilestoneModel> super.items,
  });
  factory MilestoneModelListWithMeta.fromJson(Map<String, dynamic> json) {
    return MilestoneModelListWithMeta(
        meta: MetaModel.fromJson(json['meta']),
        items: json['items']
            .map<MilestoneModel>((item) => MilestoneModel.fromJson(item))
            .toList() as List<MilestoneModel>);
  }
}

class CreateMilestoneParamsModel extends CreateMilestoneParamsEntity {
  const CreateMilestoneParamsModel(
      {required super.createdById,
      required super.description,
      required super.dueDate,
      required super.name,
      required super.projectId,
      required super.stage});

  Map<String, dynamic> toJson() {
    return {
      'createdById': createdById,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'name': name,
      'projectId': projectId,
      'stage': stage.name,
    };
  }

  factory CreateMilestoneParamsModel.fromEntity(
      CreateMilestoneParamsEntity entity) {
    return CreateMilestoneParamsModel(
      createdById: entity.createdById,
      description: entity.description,
      dueDate: entity.dueDate,
      name: entity.name,
      projectId: entity.projectId,
      stage: entity.stage,
    );
  }
}

class EditMilestoneParamsModel extends EditMilestoneParamsEntity {
  EditMilestoneParamsModel(
      {required super.id,
      required super.createdById,
      required super.description,
      required super.dueDate,
      required super.name,
      required super.stage});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdById': createdById,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'name': name,
      'stage': stage.name,
    };
  }

  factory EditMilestoneParamsModel.fromEntity(
      EditMilestoneParamsEntity entity) {
    return EditMilestoneParamsModel(
      id: entity.id,
      createdById: entity.createdById,
      description: entity.description,
      dueDate: entity.dueDate,
      name: entity.name,
      stage: entity.stage,
    );
  }
}

class GetMilestoneParamsModel extends GetMilestonesParamsEntity {
  GetMilestoneParamsModel(
      {required super.filterMilestoneInput,
      required super.paginationInput,
      required super.orderBy});
}
