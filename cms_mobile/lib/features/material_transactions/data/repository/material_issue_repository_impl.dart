import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_issues/material_issue_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_issue_repository.dart';
import 'package:flutter/material.dart';

class MaterialIssueRepositoryImpl extends MaterialIssueRepository {
  final MaterialIssueDataSource dataSource;

  MaterialIssueRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<MaterialIssueListWithMeta>> getMaterialIssues(
      FilterMaterialIssueInput? filterMaterialIssueInput,
      OrderByMaterialIssueInput? orderBy,
      PaginationInput? paginationInput) {
    debugPrint(
        'getMaterialIssues, filterMaterialIssueInput: $filterMaterialIssueInput, orderBy: $orderBy, paginationInput: $paginationInput');

    return dataSource.fetchMaterialIssues(
      filterMaterialIssueInput: filterMaterialIssueInput,
      orderBy: orderBy,
      paginationInput: paginationInput,
    );
  }

  @override
  Future<DataState<String>> createMaterialIssue(
      {required CreateMaterialIssueParamsEntity params}) {
    return dataSource.createMaterialIssue(
        createMaterialIssueParamsModel:
            CreateMaterialIssueParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<MaterialIssueModel>> getMaterialIssueDetails(
      {required String params}) {
    return dataSource.getMaterialIssueDetails(params: params);
  }

  @override
  Future<DataState<String>> editMaterialIssue(
      {required EditMaterialIssueParamsEntity params}) {
    return dataSource.editMaterialIssue(
        editMaterialIssueParamsModel:
            EditMaterialIssueParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<String>> deleteMaterialIssue({required String materialIssueId}) {
    return dataSource.deleteMaterialIssue(materialIssueId:materialIssueId);
  }
}
