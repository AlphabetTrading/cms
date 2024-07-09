import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_proforma_repository.dart';

class EditMaterialProformaUseCase
    implements UseCase<String, EditMaterialProformaParamsEntity> {
  final MaterialProformaRepository repository;

  EditMaterialProformaUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {EditMaterialProformaParamsEntity? params}) async {
    return await repository.editMaterialProforma(
      params: params!,
    );
  }
}
