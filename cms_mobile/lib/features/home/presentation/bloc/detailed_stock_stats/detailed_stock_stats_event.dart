import 'package:cms_mobile/features/home/data/data_source/dashboard/dashboard_remote_data_source.dart';

abstract class DetailedStockStatsEvent {
  const DetailedStockStatsEvent();
}

class GetDetailedStockStatsEvent extends DetailedStockStatsEvent {
  final FilterStockInput filterStockInput;
  const GetDetailedStockStatsEvent({required this.filterStockInput});
}
