import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';

abstract class MaterialReceiveRepository {
  Future<DataState<MaterialReceiveListWithMeta>> getMaterialReceivings(
    FilterMaterialReceiveInput? filterMaterialReceiveInput,
    OrderByMaterialReceiveInput? orderBy,
    PaginationInput? paginationInput,
  );

  Future<DataState<String>> createMaterialReceive(
      {required CreateMaterialReceiveParamsEntity params});

  Future<DataState<MaterialReceiveEntity>> getMaterialReceiveDetails(
      {required String params});

  Future<DataState<String>> editMaterialReceive(
      {required String params});

  Future<DataState<String>> deleteMaterialReceive({required String materialReceiveId});
}
