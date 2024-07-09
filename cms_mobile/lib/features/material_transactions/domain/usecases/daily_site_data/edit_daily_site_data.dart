import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/daily_site_data_repository.dart';

class EditDailySiteDataUseCase
    implements UseCase<String, EditDailySiteDataParamsEntity> {
  final DailySiteDataRepository repository;

  EditDailySiteDataUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {EditDailySiteDataParamsEntity? params}) async {
    return await repository.editDailySiteData(
      params: params!,
    );
  }
}
