import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';
import 'package:cms_mobile/features/home/domain/repository/dashboard_repository.dart';

class GetDashboardUseCase
    implements UseCase<DashboardEntity, void> {
      
  final DashboardRepository _dashboardRepository;

  GetDashboardUseCase(this._dashboardRepository);

  @override
  Future<DataState<DashboardEntity>> call({void params}) {
    return _dashboardRepository.getDashboardStats();
  }
}
