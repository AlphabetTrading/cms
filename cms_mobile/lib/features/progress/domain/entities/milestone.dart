import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/progress/domain/entities/Task.dart';
import 'package:equatable/equatable.dart';

class MilestoneEntity extends Equatable {
  final String? id;
  final double? progress;
  final String? stage;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final String? name;
  final UserEntity? createdBy;
  final String? description;
  final List<TaskEntity>? tasks;

  const MilestoneEntity({
    required this.id,
    required this.progress,
    required this.stage,
    required this.dueDate,
    required this.createdAt,
    required this.name,
    required this.createdBy,
    required this.description,
    required this.tasks,
  });

  @override
  List<Object?> get props => [
        id,
        progress,
        stage,
        dueDate,
        createdAt,
        name,
        createdBy,
        description,
        tasks
      ];
}

class MilestoneEntityListWithMeta {
  final List<MilestoneEntity> items;
  final Meta meta;

  MilestoneEntityListWithMeta({
    required this.meta,
    required this.items,
  });
}

class CreateMilestoneParamsEntity extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EditMilestoneParamsEntity extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetMilestonesParamsEntity extends Equatable {
  final FilterMilestoneInput? filterMilestoneInput;
  final PaginationInput? paginationInput;
  final OrderBy? orderBy;
  GetMilestonesParamsEntity({
    required this.filterMilestoneInput,
    required this.paginationInput,
    required this.orderBy,
  });

  @override
  List<Object?> get props => [filterMilestoneInput, paginationInput, orderBy];
}

class FilterMilestoneInput {
  String? name;

  FilterMilestoneInput({
    required this.name,
  });
}

class OrderBy {
  String? createdAt;
  String? name;
  String? updatedAt;

  OrderBy({
    required this.createdAt,
    required this.name,
    required this.updatedAt,
  });
}
