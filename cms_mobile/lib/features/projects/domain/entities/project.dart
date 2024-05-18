import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/projects/domain/entities/milestone.dart';
import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final String? id;
  final String? name;
  final String? status;
  final String? clientId;
  final UserEntity? client;
  final double? budget;
  final List<UserEntity>? projectUsers;
  final String? projectManagerId;
  final UserEntity? projectManager;
  final DateTime? endDate;
  final DateTime? startDate;
  final List<MilestoneEntity>? milestones;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProjectEntity({
    this.id,
    this.name,
    this.status,
    this.clientId,
    this.client,
    this.budget,
    this.projectUsers,
    this.projectManagerId,
    this.projectManager,
    this.startDate,
    this.endDate,
    this.milestones,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}

class ProjectEntityListWithMeta {
  final List<ProjectEntity> items;
  final Meta meta;

  ProjectEntityListWithMeta({
    required this.meta,
    required this.items,
  });
}
