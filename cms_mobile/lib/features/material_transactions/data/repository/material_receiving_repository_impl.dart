import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_request_repository.dart';

class MaterialReceivingRepositoryImpl extends MaterialReceivingRepository {
  final MaterialReceivingDataSource dataSource;

  MaterialReceivingRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<List<MaterialRequestEntity>>> getMaterialRequests() {
    return dataSource.fetchMaterialRequests();
  }
}
