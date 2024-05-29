import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_issue_repository.dart';

class GetMaterialIssueDetailsUseCase implements UseCase<MaterialIssueEntity, String> {
  final MaterialIssueRepository repository;

  GetMaterialIssueDetailsUseCase(this.repository);

  @override
  Future<DataState<MaterialIssueEntity>> call({String? params}) async {
    return await repository.getMaterialIssueDetails(
      params: params!,
    );
  }
}

