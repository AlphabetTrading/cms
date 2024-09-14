import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/data/data_source/dashboard/dashboard_remote_data_source.dart';
import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';

abstract class DashboardRepository {
  Future<DataState<DashboardEntity>> getDashboardStats();

  Future<DataState<DetailedExpenseStatsEntity>> getDetailedExpenseStats({
    required FilterExpenseInput filterExpenseInput,
  });

  Future<DataState<DetailedStockStatsEntity>> getDetailedStockStats({
    required FilterStockInput filterStockInput,
  });
}
