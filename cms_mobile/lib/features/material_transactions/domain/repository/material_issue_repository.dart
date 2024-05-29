import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';

abstract class MaterialIssueRepository{
  Future<DataState<String>> createMaterialIssue({
    required CreateMaterialIssueParamsEntity params
  });
  
  Future<DataState<MaterialIssueEntity>> getMaterialIssueDetails({
    required String params
  });

}