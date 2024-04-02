import 'package:cms_mobile/features/home/domain/entities/task.dart';
import 'package:equatable/equatable.dart';

class MilestoneEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime dueDate;
  final String status;
  final String projectId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TaskEntity> tasks;

  const MilestoneEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.projectId,
    required this.createdAt,
    required this.updatedAt,
    required this.tasks,
  });

  MilestoneEntity copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? dueDate,
    String? status,
    String? projectId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TaskEntity>? tasks,
  }) {
    return MilestoneEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      projectId: projectId ?? this.projectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MilestoneEntity &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.dueDate == dueDate &&
        other.status == status &&
        other.projectId == projectId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.tasks == tasks;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        dueDate.hashCode ^
        status.hashCode ^
        projectId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        tasks.hashCode;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        dueDate,
        status,
        projectId,
        createdAt,
        updatedAt,
        tasks,
      ];
}
