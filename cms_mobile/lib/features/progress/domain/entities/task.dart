import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
    final String? id;
    final String? name;
    final String? priority;
    final String? status;
    final DateTime? dueDate;
    final String? description;
    final String? milestoneId;
    final UserEntity? assignedTo;

    const TaskEntity({
        required this.id,
        required this.name,
        required this.priority,
        required this.status,
        required this.dueDate,
        required this.description,
        required this.milestoneId,
        required this.assignedTo,
    });
    
      @override
      List<Object?> get props => [id,name,priority,status,dueDate,description,milestoneId,assignedTo];

}
