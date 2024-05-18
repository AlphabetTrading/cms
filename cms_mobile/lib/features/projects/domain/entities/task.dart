import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final DateTime? startDate;
  final DateTime? dueDate;
  final String? status;
  final String? priority;
  final String? assignedToId;
  final String? milestoneId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TaskEntity({
    this.id,
    this.name,
    this.description,
    this.startDate,
    this.dueDate,
    this.status,
    this.priority,
    this.assignedToId,
    this.milestoneId,
    this.createdAt,
    this.updatedAt,
  });

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
}
