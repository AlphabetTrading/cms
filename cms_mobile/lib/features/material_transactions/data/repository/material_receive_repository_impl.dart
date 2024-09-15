import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_receive/material_receive_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_receive_repository.dart';

class MaterialReceiveRepositoryImpl extends MaterialReceiveRepository {
  final MaterialReceiveDataSource dataSource;

  MaterialReceiveRepositoryImpl({required this.dataSource});

  @override
  @override
  Future<DataState<String>> createMaterialReceive(
      {required CreateMaterialReceiveParamsEntity params}) {
    return dataSource.createMaterialReceive(
        createMaterialReceiveParamsModel:
            CreateMaterialReceiveParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<String>> deleteMaterialReceive(
      {required String materialReceiveId}) {
    return dataSource.deleteMaterialReceive(
        materialReceiveId: materialReceiveId);
  }

  @override
  Future<DataState<MaterialReceiveModel>> getMaterialReceiveDetails(
      {required String params}) {
    return dataSource.getMaterialReceiveDetails(params: params);
  }

  @override
  Future<DataState<MaterialReceiveListWithMeta>> getMaterialReceivings(
      FilterMaterialReceiveInput? filterMaterialReceiveInput,
      OrderByMaterialReceiveInput? orderBy,
      PaginationInput? paginationInput) {
    return dataSource.fetchMaterialReceivings(
      filterMaterialReceiveInput: filterMaterialReceiveInput,
      orderBy: orderBy,
      paginationInput: paginationInput,
    );
  }

  @override
  Future<DataState<String>> editMaterialReceive({required String params}) {
    // TODO: implement editMaterialReceive
    throw UnimplementedError();
  }

  @override
  Future<DataState<String>> generateMaterialReceivePdf({required String id}) {
    return dataSource.generateMaterialReceivePdf(id: id);
  }
}
