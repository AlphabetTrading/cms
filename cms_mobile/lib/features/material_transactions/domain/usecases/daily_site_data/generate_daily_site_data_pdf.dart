import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/daily_site_data_repository.dart';

class GenerateDailySiteDataPdfUseCase implements UseCase<String, String> {
  final DailySiteDataRepository repository;

  GenerateDailySiteDataPdfUseCase(this.repository);

  @override
  Future<DataState<String>> call({String? params}) async {
    return await repository.generateDailySiteDataPdf(
      id: params!,
    );
  }
}
