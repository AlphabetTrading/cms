import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_proforma_repository.dart';

class DeleteMaterialProformaUseCase implements UseCase<String, String> {
  final MaterialProformaRepository repository;

  DeleteMaterialProformaUseCase(this.repository);

  @override
  Future<DataState<String>> call({String? params}) async {
    return await repository.deleteMaterialProforma(
      materialProformaId: params!,
    );
  }
}
