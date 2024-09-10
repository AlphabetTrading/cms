import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_proformas/material_proforma_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_proforma_repository.dart';

class GetAllMaterialProformasUseCase
    implements
        UseCase<List<MaterialProformaEntity>, AllMaterialProformaParams?> {
  final MaterialProformaRepository _materialTransactionRepository;

  GetAllMaterialProformasUseCase(this._materialTransactionRepository);

  @override
  Future<DataState<List<MaterialProformaEntity>>> call(
      {AllMaterialProformaParams? params}) {
    return _materialTransactionRepository
        .getAllMaterialProformas(params?.filterMaterialProformaInput);
  }
}

class AllMaterialProformaParams {
  FilterMaterialProformaInput? filterMaterialProformaInput;

  AllMaterialProformaParams({
    this.filterMaterialProformaInput,
  });
}
