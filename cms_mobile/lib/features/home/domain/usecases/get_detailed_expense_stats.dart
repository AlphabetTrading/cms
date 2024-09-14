import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/home/data/data_source/dashboard/dashboard_remote_data_source.dart';
import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';
import 'package:cms_mobile/features/home/domain/repository/dashboard_repository.dart';

class GetDetailedExpenseStatsUseCase
    implements UseCase<DetailedExpenseStatsEntity, DetailedExpenseStatsParams> {
  final DashboardRepository _dashboardRepository;

  GetDetailedExpenseStatsUseCase(this._dashboardRepository);

  @override
  Future<DataState<DetailedExpenseStatsEntity>> call(
      {DetailedExpenseStatsParams? params}) {
    return _dashboardRepository.getDetailedExpenseStats(
        filterExpenseInput: params!.filterExpenseInput!);
  }
}

class DetailedExpenseStatsParams {
  FilterExpenseInput? filterExpenseInput;

  DetailedExpenseStatsParams({required this.filterExpenseInput});
}
