import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_issue_repository.dart';

class CreateMaterialIssueUseCase implements UseCase<String, CreateMaterialIssueParamsEntity> {
  final MaterialIssueRepository repository;

  CreateMaterialIssueUseCase(this.repository);

  @override
  Future<DataState<String>> call({CreateMaterialIssueParamsEntity? params}) async {
    return await repository.createMaterialIssue(
      params: params!,
    );
  }
}

