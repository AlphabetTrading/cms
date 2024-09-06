import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_issue_repository.dart';

class GenerateMaterialIssuePdfUseCase implements UseCase<String, String> {
  final MaterialIssueRepository repository;

  GenerateMaterialIssuePdfUseCase(this.repository);

  @override
  Future<DataState<String>> call({String? params}) async {
    return await repository.generateMaterialIssuePdf(
      id: params!,
    );
  }
}
