import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/daily_site_data_repository.dart';

class CreateDailySiteDataUseCase
    implements UseCase<String, CreateDailySiteDataParamsEntity> {
  final DailySiteDataRepository repository;

  CreateDailySiteDataUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {CreateDailySiteDataParamsEntity? params}) async {
    return await repository.createDailySiteData(
      params: params!,
    );
  }
}
