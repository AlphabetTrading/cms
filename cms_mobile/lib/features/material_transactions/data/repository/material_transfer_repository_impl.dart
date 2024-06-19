import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_transfer/material_transfer_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_transfer_repository.dart';

class MaterialTransferRepositoryImpl extends MaterialTransferRepository {
  final MaterialTransferDataSource dataSource;

  MaterialTransferRepositoryImpl({required this.dataSource});

  // @override
  // Future<DataState<MaterialTransferEntityListWithMeta>> getMaterialTransfers(
  //     FilterMaterialTransferInput? filterMaterialTransferInput,
  //     OrderByMaterialTransferInput? orderBy,
  //     PaginationInput? paginationInput) {
  //   debugPrint(
  //       'getMaterialTransfers, filterMaterialTransferInput: $filterMaterialTransferInput, orderBy: $orderBy, paginationInput: $paginationInput');

  //   // return dataSource.fetchMaterialTransfers(
  //   //   filterMaterialTransferInput: filterMaterialTransferInput,
  //   //   orderBy: orderBy,
  //   //   paginationInput: paginationInput,
  //   // );
  // }

  // @override
  // Future<DataState<String>> createMaterialTransfer(
  //     {required CreateMaterialTransferParamsEntity params}) {
  //   return dataSource.createMaterialTransfer(
  //       createMaterialTransferParamsModel:
  //           CreateMaterialTransferParamsEntity(params));
  // }

  @override
  Future<DataState<MaterialTransferModel>> getMaterialTransferDetails(
      {required String params}) {
    return dataSource.getMaterialTransferDetails(params: params);
  }

  // @override
  // Future<DataState<String>> editMaterialTransfer(
  //     {required EditMaterialTransferParamsEntity params}) {
  //   return dataSource.editMaterialTransfer(
  //       editMaterialTransferParamsModel:
  //           EditMaterialTransferParamsModel.fromEntity(params));
  // }

  @override
  Future<DataState<String>> deleteMaterialTransfer(
      {required String materialId}) {
    return dataSource.deleteMaterialTransfer(materialId: materialId);
  }

  @override
  Future<DataState<String>> createMaterialTransfer(
      {required CreateMaterialTransferParamsEntity<MaterialTransferEntity>
          params}) {
    // TODO: implement createMaterialTransfer
    throw UnimplementedError();
  }

  @override
  Future<DataState<String>> editMaterialTransfer(
      {required EditMaterialTransferParamsEntity<MaterialTransferEntity>
          params}) {
    // TODO: implement editMaterialTransfer
    throw UnimplementedError();
  }

  @override
  Future<DataState<MaterialTransferEntityListWithMeta>> getMaterialTransfers(
      FilterMaterialTransferInput? filterMaterialTransferInput,
      OrderByMaterialTransferInput? orderBy,
      PaginationInput? paginationInput) {
    return dataSource.fetchMaterialTransfers(
      filterMaterialTransferInput: filterMaterialTransferInput,
      orderBy: orderBy,
      paginationInput: paginationInput,
    );
  }
}
