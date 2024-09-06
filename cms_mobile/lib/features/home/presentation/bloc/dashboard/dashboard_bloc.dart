import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/data/models/dashboard.dart';
import 'package:cms_mobile/features/home/domain/usecases/get_dashboard_stats.dart';
import 'package:cms_mobile/features/home/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:cms_mobile/features/home/presentation/bloc/dashboard/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase _dashboardUseCase;

  DashboardBloc(this._dashboardUseCase) : super(const DashboardInitial()) {
    on<GetDashboardStats>(onGetDashboardStats);
  }

  void onGetDashboardStats(
    GetDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    final dataState = await _dashboardUseCase();

    if (dataState is DataSuccess) {
      emit(DashboardSuccess(dashboard: dataState.data! as DashboardModel));
    }

    if (dataState is DataFailed) {
      emit(DashboardFailed(error: dataState.error!));
    }
  }
}
