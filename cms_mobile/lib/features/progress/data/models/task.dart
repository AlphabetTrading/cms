import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/progress/domain/entities/Task.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required String? id,
    required String? name,
    required String? priority,
    required String? status,
    required DateTime? dueDate,
    required String? description,
    required String? milestoneId,
    required UserModel? assignedTo,
  }) : super(
          id: id,
          name: name,
          priority: priority,
          status: status,
          dueDate: dueDate,
          description: description,
          milestoneId: milestoneId,
          assignedTo: assignedTo,
        );
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      name: json['name'],
      priority: json['priority'],
      status: json['status'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      description: json['description'],
      milestoneId: json['milestoneId'],
      assignedTo: json['assignedTo'] != null
          ? UserModel.fromJson(json['assignedTo'])
          : null,
    );
  }
}
