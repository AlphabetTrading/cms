import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/daily_site_data_repository.dart';

class GetDailySiteDataDetailsUseCase
    implements UseCase<DailySiteDataEntity, String> {
  final DailySiteDataRepository repository;

  GetDailySiteDataDetailsUseCase(this.repository);

  @override
  Future<DataState<DailySiteDataEntity>> call({String? params}) async {
    return await repository.getDailySiteDataDetails(
      params: params!,
    );
  }
}
