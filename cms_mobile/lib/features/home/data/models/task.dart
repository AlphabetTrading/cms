import 'package:cms_mobile/features/home/domain/entities/task.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required String id,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime dueDate,
    required String status,
    required String priority,
    required String assignedToId,
    required String milestoneId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          name: name,
          description: description,
          startDate: startDate,
          dueDate: dueDate,
          status: status,
          priority: priority,
          assignedToId: assignedToId,
          milestoneId: milestoneId,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      startDate,
      dueDate,
      status,
      priority,
      assignedToId,
      milestoneId,
      createdAt,
      updatedAt,
    ];
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: json['startDate'],
      dueDate: json['dueDate'],
      status: json['status'],
      priority: json['priority'],
      assignedToId: json['assignedToId'],
      milestoneId: json['milestoneId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate,
      'dueDate': dueDate,
      'status': status,
      'priority': priority,
      'assignedToId': assignedToId,
      'milestoneId': milestoneId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
