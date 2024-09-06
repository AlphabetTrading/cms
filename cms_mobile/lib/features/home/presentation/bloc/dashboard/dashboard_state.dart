import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  final DashboardEntity? dashboard;
  final Failure? error;

  const DashboardState({this.dashboard, this.error});

  @override
  List<Object?> get props => [dashboard, error];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardSuccess extends DashboardState {
  const DashboardSuccess({required DashboardEntity dashboard})
      : super(dashboard: dashboard);
}

class DashboardFailed extends DashboardState {
  const DashboardFailed({required Failure error}) : super(error: error);
}

class DashboardEmpty extends DashboardState {
  const DashboardEmpty();
}
