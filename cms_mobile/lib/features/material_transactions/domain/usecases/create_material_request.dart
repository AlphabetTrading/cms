import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_request_repository.dart';

class CreateMaterialRequest implements UseCase<MaterialRequestEntity, CreateMaterialRequestParamsEntity> {
  final MaterialRequestRepository repository;

  CreateMaterialRequest(this.repository);

  @override
  Future<DataState<MaterialRequestEntity>> call({CreateMaterialRequestParamsEntity? params}) async {
    return await repository.createMaterialRequest(
      params: params!,
    );
  }
}

