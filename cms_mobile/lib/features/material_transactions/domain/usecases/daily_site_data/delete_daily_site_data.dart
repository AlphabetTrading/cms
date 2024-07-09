import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/daily_site_data_repository.dart';

class DeleteDailySiteDataUseCase implements UseCase<String, String> {
  final DailySiteDataRepository repository;

  DeleteDailySiteDataUseCase(this.repository);

  @override
  Future<DataState<String>> call({String? params}) async {
    return await repository.deleteDailySiteData(
      dailySiteDataId: params!,
    );
  }
}

