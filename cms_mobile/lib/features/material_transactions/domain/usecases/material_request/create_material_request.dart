import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_request_repository.dart';

class CreateMaterialRequestUseCase implements UseCase<String, CreateMaterialRequestParamsEntity> {
  final MaterialRequestRepository repository;

  CreateMaterialRequestUseCase(this.repository);

  @override
  Future<DataState<String>> call({CreateMaterialRequestParamsEntity? params}) async {
    return await repository.createMaterialRequest(
      params: params!,
    );
  }
}

