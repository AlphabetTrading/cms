import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_issues/material_issue_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';

abstract class MaterialIssueRepository {
  Future<DataState<MaterialIssueListWithMeta>> getMaterialIssues(
    FilterMaterialIssueInput? filterMaterialIssueInput,
    OrderByMaterialIssueInput? orderBy,
    PaginationInput? paginationInput,
    bool? mine,
  );

  Future<DataState<String>> createMaterialIssue(
      {required CreateMaterialIssueParamsEntity params});

  Future<DataState<MaterialIssueEntity>> getMaterialIssueDetails(
      {required String params});

  Future<DataState<String>> editMaterialIssue(
      {required EditMaterialIssueParamsEntity params});

  Future<DataState<String>> deleteMaterialIssue(
      {required String materialIssueId});

  Future<DataState<String>> generateMaterialIssuePdf({required String id});
  Future<DataState<String>> approveMaterialIssue(
      {required ApproveMaterialIssueStatus decision,
      required String materialIssueId});
}
