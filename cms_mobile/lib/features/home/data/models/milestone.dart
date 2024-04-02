import 'package:cms_mobile/features/home/domain/entities/milestone.dart';
import 'package:cms_mobile/features/home/domain/entities/task.dart';

class MilestoneModel extends MilestoneEntity {
  const MilestoneModel({
    required String id,
    required String name,
    required String description,
    required DateTime dueDate,
    required String status,
    required String projectId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<TaskEntity> tasks,
  }) : super(
          id: id,
          name: name,
          description: description,
          dueDate: dueDate,
          status: status,
          projectId: projectId,
          createdAt: createdAt,
          updatedAt: updatedAt,
          tasks: tasks,
        );

  factory MilestoneModel.fromJson(Map<String, dynamic> json) {
    return MilestoneModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      dueDate: json['dueDate'],
      status: json['status'],
      projectId: json['projectId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      tasks: json['tasks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate,
      'status': status,
      'projectId': projectId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'tasks': tasks,
    };
  }
}
