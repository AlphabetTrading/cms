import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_issue_repository.dart';

class DeleteMaterialIssueUseCase implements UseCase<String, String> {
  final MaterialIssueRepository repository;

  DeleteMaterialIssueUseCase(this.repository);

  @override
  Future<DataState<String>> call({String? params}) async {
    return await repository.deleteMaterialIssue(
      materialId: params!,
    );
  }
}

