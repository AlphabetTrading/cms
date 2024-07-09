import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_proforma_repository.dart';

class CreateMaterialProformaUseCase
    implements UseCase<String, CreateMaterialProformaParamsEntity> {
  final MaterialProformaRepository repository;

  CreateMaterialProformaUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {CreateMaterialProformaParamsEntity? params}) async {
    return await repository.createMaterialProforma(
      params: params!,
    );
  }
}
