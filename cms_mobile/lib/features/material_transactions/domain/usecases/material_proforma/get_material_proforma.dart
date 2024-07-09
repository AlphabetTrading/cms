import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_proformas/material_proforma_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_proforma_repository.dart';

class GetMaterialProformasUseCase
    implements UseCase<MaterialProformaEntityListWithMeta, MaterialProformaParams?> {
  final MaterialProformaRepository _materialTransactionRepository;

  GetMaterialProformasUseCase(this._materialTransactionRepository);

  @override
  Future<DataState<MaterialProformaEntityListWithMeta>> call(
      {MaterialProformaParams? params}) {
    return _materialTransactionRepository.getMaterialProformas(
        params!.filterMaterialProformaInput,
        params.orderBy,
        params.paginationInput,
        params.mine);
  }
}

class MaterialProformaParams {
  FilterMaterialProformaInput? filterMaterialProformaInput;
  OrderByMaterialProformaInput? orderBy;
  PaginationInput? paginationInput;
  bool? mine;

  MaterialProformaParams({
    this.filterMaterialProformaInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
  });
}
