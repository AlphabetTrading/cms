import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/data/data_source/dashboard/dashboard_remote_data_source.dart';
import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';
import 'package:cms_mobile/features/home/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardDataSource dataSource;

  DashboardRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<DashboardEntity>> getDashboardStats() {
    return dataSource.getDashboardStats();
  }
}
