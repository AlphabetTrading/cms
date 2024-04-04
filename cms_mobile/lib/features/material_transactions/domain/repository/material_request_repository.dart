import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';

abstract class MaterialRequestRepository{
  Future<DataState<MaterialRequestEntity>> createMaterialRequest({
    required CreateMaterialRequestParamsEntity params
  });

}