import 'package:cms_mobile/features/material_requests/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/material_requests/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_requests/domain/repository/material_request_repository.dart';

class MaterialReceivingRepositoryImpl extends MaterialReceivingRepository {
  final MaterialReceivingDataSource dataSource;

  MaterialReceivingRepositoryImpl({required this.dataSource});

  @override
  Future<List<MaterialRequestEntity>> getMaterialRequests() {
    return dataSource.fetchMaterialRequests();
  }
}
