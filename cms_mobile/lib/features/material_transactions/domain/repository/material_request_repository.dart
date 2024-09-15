import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_requests/material_request_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';

abstract class MaterialRequestRepository {
  Future<DataState<MaterialRequestEntityListWithMeta>> getMaterialRequests({
    FilterMaterialRequestInput? filterMaterialRequestInput,
    OrderByMaterialRequestInput? orderBy,
    PaginationInput? paginationInput,
  });

  Future<DataState<String>> createMaterialRequest(
      {required CreateMaterialRequestParamsEntity params});

  Future<DataState<MaterialRequestEntity>> getMaterialRequestDetails(
      {required String params});
  Future<DataState<String>> deleteMaterialRequest(
      {required String materialRequestId});

  Future<DataState<String>> generateMaterialRequestPdf({required String id});
  Future<DataState<String>> approveMaterialRequest(
      {required ApproveMaterialRequestStatus decision,
      required String materialRequestId});
}
