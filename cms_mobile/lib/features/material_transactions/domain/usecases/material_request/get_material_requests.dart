import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_requests/material_request_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_request_repository.dart';
import 'package:flutter/material.dart';

class GetMaterialRequestsUseCase
    implements
        UseCase<MaterialRequestEntityListWithMeta, MaterialRequestParams?> {
  final MaterialRequestRepository _materialRequestRepository;

  GetMaterialRequestsUseCase(this._materialRequestRepository);

  @override
  Future<DataState<MaterialRequestEntityListWithMeta>> call(
      {MaterialRequestParams? params}) {
    debugPrint('GetMaterialRequestsUseCase called');
    final result = _materialRequestRepository.getMaterialRequests(
      filterMaterialRequestInput: params?.filterMaterialRequestInput,
      orderBy: params?.orderBy,
      paginationInput: params?.paginationInput,
    );

    debugPrint('GetMaterialRequestsUseCase result: $result');

    return result;
  }
}

class MaterialRequestParams {
  FilterMaterialRequestInput? filterMaterialRequestInput;
  OrderByMaterialRequestInput? orderBy;
  PaginationInput? paginationInput;

  MaterialRequestParams({
    this.filterMaterialRequestInput,
    this.orderBy,
    this.paginationInput,
  });
}
