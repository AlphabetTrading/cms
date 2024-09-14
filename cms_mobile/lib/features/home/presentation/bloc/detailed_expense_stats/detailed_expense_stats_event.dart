import 'package:cms_mobile/features/home/data/data_source/dashboard/dashboard_remote_data_source.dart';

abstract class DetailedExpenseStatsEvent {
  const DetailedExpenseStatsEvent();
}

class GetDetailedExpenseStatsEvent extends DetailedExpenseStatsEvent {
  final FilterExpenseInput filterExpenseInput;
  const GetDetailedExpenseStatsEvent({required this.filterExpenseInput});
}
