import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_return_repository.dart';

class GenerateMaterialReturnPdfUseCase implements UseCase<String, String> {
  final MaterialReturnRepository repository;

  GenerateMaterialReturnPdfUseCase(this.repository);

  @override
  Future<DataState<String>> call({String? params}) async {
    return await repository.generateMaterialReturnPdf(
      id: params!,
    );
  }
}
