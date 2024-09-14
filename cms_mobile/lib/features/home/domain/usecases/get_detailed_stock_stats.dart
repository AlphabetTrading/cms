import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/home/data/data_source/dashboard/dashboard_remote_data_source.dart';
import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';
import 'package:cms_mobile/features/home/domain/repository/dashboard_repository.dart';

class GetDetailedStockStatsUseCase
    implements UseCase<DetailedStockStatsEntity, DetailedStockStatsParams> {
  final DashboardRepository _dashboardRepository;

  GetDetailedStockStatsUseCase(this._dashboardRepository);

  @override
  Future<DataState<DetailedStockStatsEntity>> call(
      {DetailedStockStatsParams? params}) {
    return _dashboardRepository.getDetailedStockStats(
        filterStockInput: params!.filterStockInput);
  }
}

class DetailedStockStatsParams {
  FilterStockInput filterStockInput;

  DetailedStockStatsParams({required this.filterStockInput});
}
