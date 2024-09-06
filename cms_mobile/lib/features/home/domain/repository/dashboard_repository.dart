import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';

abstract class DashboardRepository {
  Future<DataState<DashboardEntity>> getDashboardStats();
}
