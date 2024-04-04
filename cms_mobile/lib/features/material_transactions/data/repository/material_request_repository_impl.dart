import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_request_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_request_repository.dart';

class MaterialRequestRepositoryImpl extends MaterialRequestRepository {
  final MaterialRequestDataSource dataSource;

  MaterialRequestRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<MaterialRequestModel>> createMaterialRequest(
      {required CreateMaterialRequestParamsEntity params}) {

    return dataSource.createMaterialRequest(
      createMaterialRequestParamsModel:CreateMaterialRequestParamsModel.fromEntity(params)
    );
  }
}
