import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_issue_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_request_repository.dart';

class ApproveMaterialRequestUseCase
    implements UseCase<String, ApproveMaterialRequestParamsModel> {
  final MaterialRequestRepository repository;

  ApproveMaterialRequestUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {ApproveMaterialRequestParamsModel? params}) async {
    return await repository.approveMaterialRequest(
      decision: params!.decision,
      materialRequestId: params.materialRequestId,
    );
  }
}
