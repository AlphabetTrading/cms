import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/projects/domain/entities/project.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.status,
    required super.clientId,
    UserModel? super.client,
    // required double? budget,
    List<UserModel>? super.projectUsers,
    // List<MilestoneModel>? milestones,
    required super.projectManagerId,
    UserModel? super.projectManager,
    required super.startDate,
    required super.endDate,
    required super.createdAt,
    required super.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
  
      return ProjectModel(
        id: json['id'],
        name: json['name'],
        clientId: json['clientId'],
        client: json['Client'] != null
            ? UserModel.fromJson(json['issuedTo'])
            : null,
        // budget: json['budget'],
        projectUsers:json['ProjectUsers']!=null? json['ProjectUsers'].map<UserModel>((item) {
          return UserModel.fromJson(item['user']);
        }).toList() as List<UserModel>:[],
        // milestones: json['milestones'].map<MilestoneModel>((item) {
        //   return MilestoneModel.fromJson(item);
        // }).toList() as List<MilestoneModel>,
        projectManagerId: json['projectManagerId'],
        projectManager: json['projectManager'] != null
            ? UserModel.fromJson(json['projectManager'])
            : null,
        status: json['status'],
        startDate:json['startDate']!=null? DateTime.parse(json['startDate']):null,
        endDate: json['endDate']!=null?DateTime.parse(json['endDate']):null,
        createdAt:json['createdAt']!=null? DateTime.parse(json['createdAt']):null,
        updatedAt: json['updatedAt']!=null?DateTime.parse(json['updatedAt']):null,
      );
   
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
    required MetaModel meta,
    required List<ProjectModel> items,
  }) : super(meta: meta, items: items);

  factory ProjectListWithMeta.fromJson(Map<String, dynamic> json) {
    return ProjectListWithMeta(
      meta: MetaModel.fromJson(json['meta']),
      items: json['items']
          .map<ProjectModel>((item) => ProjectModel.fromJson(item))
          .toList(),
    );
  }
}
