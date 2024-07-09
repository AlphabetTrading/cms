import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_proforma_repository.dart';

class GetMaterialProformaDetailsUseCase implements UseCase<MaterialProformaEntity, String> {
  final MaterialProformaRepository repository;

  GetMaterialProformaDetailsUseCase(this.repository);

  @override
  Future<DataState<MaterialProformaEntity>> call({String? params}) async {
    return await repository.getMaterialProformaDetails(
      params: params!,
    );
  }
}

