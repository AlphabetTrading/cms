import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_issue_repository.dart';

class EditMaterialIssueUseCase implements UseCase<String, EditMaterialIssueParamsEntity> {
  final MaterialIssueRepository repository;

  EditMaterialIssueUseCase(this.repository);

  @override
  Future<DataState<String>> call({EditMaterialIssueParamsEntity? params}) async {
    return await repository.editMaterialIssue(
      params: params!,
    );
  }
}

