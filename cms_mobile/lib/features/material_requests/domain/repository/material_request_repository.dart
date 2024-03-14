import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_requests/domain/entities/material_request.dart';

abstract class MaterialReceivingRepository {
  Future<DataState<List<MaterialRequestEntity>>> getMaterialRequests();
}
