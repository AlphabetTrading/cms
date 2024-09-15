import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_issue_repository.dart';

class ApproveMaterialIssueUseCase
    implements UseCase<String, ApproveMaterialIssueParamsModel> {
  final MaterialIssueRepository repository;

  ApproveMaterialIssueUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {ApproveMaterialIssueParamsModel? params}) async {
    return await repository.approveMaterialIssue(
      decision: params!.decision,
      materialIssueId: params.materialIssueId,
    );
  }
}
