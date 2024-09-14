import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_request_repository.dart';

class DeleteMaterialRequestUseCase implements UseCase<String, String> {
  final MaterialRequestRepository repository;

  DeleteMaterialRequestUseCase(this.repository);

  @override
  Future<DataState<String>> call({String? params}) async {
    return await repository.deleteMaterialRequest(
      materialRequestId: params!,
    );
  }
}

