import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_transfer/material_transfer_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';

abstract class MaterialTransferRepository {
  Future<DataState<MaterialTransferEntityListWithMeta>> getMaterialTransfers(
    FilterMaterialTransferInput? filterMaterialTransferInput,
    OrderByMaterialTransferInput? orderBy,
    PaginationInput? paginationInput,
  );

  Future<DataState<String>> createMaterialTransfer(
      {required CreateMaterialTransferParamsEntity params});

  Future<DataState<MaterialTransferEntity>> getMaterialTransferDetails(
      {required String params});

  Future<DataState<String>> editMaterialTransfer(
      {required EditMaterialTransferParamsEntity params});

  Future<DataState<String>> deleteMaterialTransfer(
      {required String materialId});
}
