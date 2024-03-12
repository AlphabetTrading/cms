import 'package:cms_mobile/features/material_requests/domain/entities/material_request.dart';

abstract class MaterialReceivingRepository {
  Future<List<MaterialRequestEntity>> getMaterialRequests();
}
