
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_request_repository.dart';

class GetMaterialRequestDetailsUseCase implements UseCase<MaterialRequestEntity, String> {
  final MaterialRequestRepository repository;

  GetMaterialRequestDetailsUseCase(this.repository);

  @override
  Future<DataState<MaterialRequestEntity>> call({String? params}) async {
    return await repository.getMaterialRequestDetails(
      params: params!,
    );
  }
}

