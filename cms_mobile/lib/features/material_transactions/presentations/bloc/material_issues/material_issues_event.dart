import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/remote_data_source.dart';

abstract class MaterialIssueEvent {
  const MaterialIssueEvent();
}

class GetMaterialIssues extends MaterialIssueEvent {
  final FilterMaterialIssueInput? filterMaterialIssueInput;
  final OrderByMaterialIssueInput? orderBy;
  final PaginationInput? paginationInput;
  const GetMaterialIssues({
    this.filterMaterialIssueInput,
    this.orderBy,
    this.paginationInput,
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

class CreateMaterialIssue extends MaterialIssueEvent {
  final String id;
  const CreateMaterialIssue(this.id);
}

class UpdateMaterialIssue extends MaterialIssueEvent {
  final String id;
  const UpdateMaterialIssue(this.id);
}

class DeleteMaterialIssue extends MaterialIssueEvent {
  final String id;
  const DeleteMaterialIssue(this.id);
}
