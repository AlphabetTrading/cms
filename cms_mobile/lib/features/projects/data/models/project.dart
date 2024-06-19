import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/progress/data/models/milestone.dart';
import 'package:cms_mobile/features/projects/domain/entities/project.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required String? id,
    required String? name,
    required String? status,
    required String? clientId,
    UserModel? client,
    required double? budget,
    List<UserModel>? projectUsers,
    List<MilestoneModel>? milestones,
    required String? projectManagerId,
    UserModel? projectManager,
    required DateTime? startDate,
    required DateTime? endDate,
    required DateTime? createdAt,
    required DateTime? updatedAt,
  }) : super(
            id: id,
            status: status,
            name: name,
            clientId: clientId,
            client: client,
            budget: budget,
            projectManagerId: projectManagerId,
            projectManager: projectManager,
            startDate: startDate,
            endDate: endDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            projectUsers: projectUsers,
            milestones: milestones);

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    try {
      return ProjectModel(
        id: json['id'],
        name: json['name'],
        clientId: json['clientId'],
        client: json['Client'] != null
            ? UserModel.fromJson(json['issuedTo'])
            : null,
        budget: json['budget'],
        projectUsers: json['projectUsers'].map<UserModel>((item) {
          return UserModel.fromJson(item);
        }).toList() as List<UserModel>,
        milestones: json['milestones'].map<MilestoneModel>((item) {
          return MilestoneModel.fromJson(item);
        }).toList() as List<MilestoneModel>,
        projectManagerId: json['projectManagerId'],
        projectManager: json['projectManager'] != null
            ? UserModel.fromJson(json['projectManager'])
            : null,
        status: json['status'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
    } catch (e) {
      return ProjectModel(
        id: json['id'],
        name: json['name'],
        clientId: json['clientId'],
        client:
            json['client'] != null ? UserModel.fromJson(json['client']) : null,
        budget: json['budget'],
        projectUsers: json['projectUsers'] != null
            ? json['projectUsers'].map<UserModel>((item) {
                return UserModel.fromJson(item);
              }).toList() as List<UserModel>
            : [],
        milestones: json['milestones'] != null
            ? json['milestones'].map<MilestoneModel>((item) {
                return MilestoneModel.fromJson(item);
              }).toList() as List<MilestoneModel>
            : [],
        projectManagerId: json['projectManagerId'],
        projectManager: json['projectManager'] != null
            ? UserModel.fromJson(json['projectManager'])
            : null,
        status: json['status'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class ProjectListWithMeta extends ProjectEntityListWithMeta {
  ProjectListWithMeta({
    required Meta meta,
    required List<ProjectModel> items,
  }) : super(meta: meta, items: items);

  factory ProjectListWithMeta.fromJson(Map<String, dynamic> json) {
    return ProjectListWithMeta(
      meta: Meta.fromJson(json['meta']),
      items: json['items']
          .map<ProjectModel>((item) => ProjectModel.fromJson(item))
          .toList(),
    );
  }
}
