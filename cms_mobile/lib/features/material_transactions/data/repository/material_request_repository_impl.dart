import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_requests/material_request_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_request_repository.dart';

class MaterialRequestRepositoryImpl extends MaterialRequestRepository {
  final MaterialRequestDataSource dataSource;

  MaterialRequestRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<String>> createMaterialRequest(
      {required CreateMaterialRequestParamsEntity params}) {
    return dataSource.createMaterialRequest(
        createMaterialRequestParamsModel:
            CreateMaterialRequestParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<MaterialRequestModel>> getMaterialRequestDetails(
      {required String params}) {
    return dataSource.getMaterialRequestDetails(params: params);
  }

  @override
  Future<DataState<MaterialRequestEntityListWithMeta>> getMaterialRequests(
      {FilterMaterialRequestInput? filterMaterialRequestInput,
      OrderByMaterialRequestInput? orderBy,
      PaginationInput? paginationInput}) {
    return dataSource.fetchMaterialRequests(
      filterMaterialRequestInput,
      orderBy,
      paginationInput,
    );
  }

  @override
  Future<DataState<String>> deleteMaterialRequest(
      {required String materialRequestId}) {
    return dataSource.deleteMaterialRequest(
        materialRequestId: materialRequestId);
  }

  @override
  Future<DataState<String>> generateMaterialRequestPdf({required String id}) {
    return dataSource.generateMaterialRequestPdf(id: id);
  }
}
