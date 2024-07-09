import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_issues/material_issue_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';

abstract class MaterialIssueEvent {
  const MaterialIssueEvent();
}

class GetMaterialIssues extends MaterialIssueEvent {
  final FilterMaterialIssueInput? filterMaterialIssueInput;
  final OrderByMaterialIssueInput? orderBy;
  final PaginationInput? paginationInput;
  final bool? mine;
  const GetMaterialIssues({
    this.filterMaterialIssueInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
  });
}

class GetMaterialIssue extends MaterialIssueEvent {
  final FilterMaterialIssueInput filterMaterialIssueInput;
  final OrderByMaterialIssueInput orderBy;
  final PaginationInput paginationInput;
  const GetMaterialIssue(
    this.filterMaterialIssueInput,
    this.orderBy,
    this.paginationInput,
  );
}

class GetMaterialIssueDetailsEvent extends MaterialIssueEvent {
  final String materialIssueId;
  const GetMaterialIssueDetailsEvent({required this.materialIssueId});
}

class UpdateMaterialIssue extends MaterialIssueEvent {
  final String id;
  const UpdateMaterialIssue(this.id);
}

class DeleteMaterialIssue extends MaterialIssueEvent {
  final String id;
  const DeleteMaterialIssue(this.id);
}

class CreateMaterialIssueEvent extends MaterialIssueEvent {
  final CreateMaterialIssueParamsEntity createMaterialIssueParamsEntity;

  const CreateMaterialIssueEvent(
      {required this.createMaterialIssueParamsEntity});
}

class UpdateMaterialIssueEvent extends MaterialIssueEvent {
  final String id;
  const UpdateMaterialIssueEvent(this.id);
}

class DeleteMaterialIssueEventLocal extends MaterialIssueEvent {
  final String materialIssueId;
  final bool isMine;
  const DeleteMaterialIssueEventLocal({
    required this.materialIssueId,
    required this.isMine,
  });
}
