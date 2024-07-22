import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_transfer/material_transfer_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_transfer_repository.dart';

class GetMaterialTransfersUseCase
    implements
        UseCase<MaterialTransferEntityListWithMeta, MaterialTransferParams?> {
  final MaterialTransferRepository _materialTransactionRepository;

  GetMaterialTransfersUseCase(this._materialTransactionRepository);

  @override
  Future<DataState<MaterialTransferEntityListWithMeta>> call(
      {MaterialTransferParams? params}) {
    return _materialTransactionRepository.getMaterialTransfers(
      params!.filterMaterialTransferInput,
      params.orderBy,
      params.paginationInput,
      params.mine
    );
  }
}

class MaterialTransferParams {
  FilterMaterialTransferInput? filterMaterialTransferInput;
  OrderByMaterialTransferInput? orderBy;
  PaginationInput? paginationInput;
  bool? mine;

  MaterialTransferParams({
    this.filterMaterialTransferInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
  });
}
