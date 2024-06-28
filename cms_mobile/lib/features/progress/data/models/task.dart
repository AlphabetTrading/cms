import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/presentation/utils/progress_enums.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required String? id,
    required String? name,
    required Priority? priority,
    required CompletionStatus? status,
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
      priority: priorityFromString(json['priority']),
      status: completionStatusFromString(json['status']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      description: json['description'],
      milestoneId: json['milestoneId'],
      assignedTo: json['assignedTo'] != null
          ? UserModel.fromJson(json['assignedTo'])
          : null,
    );
  }
}
