import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_issues/material_issue_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_issue_repository.dart';

class GetMaterialIssuesUseCase
    implements UseCase<MaterialIssueEntityListWithMeta, MaterialIssueParams?> {
  final MaterialIssueRepository _materialTransactionRepository;

  GetMaterialIssuesUseCase(this._materialTransactionRepository);

  @override
  Future<DataState<MaterialIssueEntityListWithMeta>> call(
      {MaterialIssueParams? params}) {
    return _materialTransactionRepository.getMaterialIssues(
        params!.filterMaterialIssueInput,
        params.orderBy,
        params.paginationInput,
        params.mine);
  }
}

class MaterialIssueParams {
  FilterMaterialIssueInput? filterMaterialIssueInput;
  OrderByMaterialIssueInput? orderBy;
  PaginationInput? paginationInput;
  bool? mine;

  MaterialIssueParams({
    this.filterMaterialIssueInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
  });
}
