import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_proforma_repository.dart';

class ApproveMaterialProformaUseCase
    implements UseCase<String, ApproveMaterialProformaParamsEntity> {
  final MaterialProformaRepository repository;

  ApproveMaterialProformaUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {ApproveMaterialProformaParamsEntity? params}) async {
    return await repository.approveMaterialProforma(
     params: params!
    );
  }
}