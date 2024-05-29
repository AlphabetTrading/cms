import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_issue_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_issue_repository.dart';

class MaterialIssueRepositoryImpl extends MaterialIssueRepository {
  final MaterialIssueDataSource dataSource;

  MaterialIssueRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<String>> createMaterialIssue(
      {required CreateMaterialIssueParamsEntity params}) {

    return dataSource.createMaterialIssue(
      createMaterialIssueParamsModel:CreateMaterialIssueParamsModel.fromEntity(params)
    );
  }
  
  @override
  Future<DataState<MaterialIssueModel>> getMaterialIssueDetails({required String params}) {
    return dataSource.getMaterialIssueDetails(params:params);
  }
}
