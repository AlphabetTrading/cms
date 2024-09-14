import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';
import 'package:equatable/equatable.dart';

abstract class DetailedExpenseStatsState extends Equatable {
  final DetailedExpenseStatsEntity? detailedExpenseStats;
  final Failure? error;

  const DetailedExpenseStatsState({this.detailedExpenseStats, this.error});

  @override
  List<Object?> get props => [detailedExpenseStats, error];
}

class DetailedExpenseStatsInitial extends DetailedExpenseStatsState {
  const DetailedExpenseStatsInitial();
}

class DetailedExpenseStatsLoading extends DetailedExpenseStatsState {
  const DetailedExpenseStatsLoading();
}

class DetailedExpenseStatsSuccess extends DetailedExpenseStatsState {
  const DetailedExpenseStatsSuccess(
      {required DetailedExpenseStatsEntity detailedExpenseStats})
      : super(detailedExpenseStats: detailedExpenseStats);
}

class DetailedExpenseStatsFailed extends DetailedExpenseStatsState {
  const DetailedExpenseStatsFailed({required Failure error})
      : super(error: error);
}

class DetailedExpenseStatsEmpty extends DetailedExpenseStatsState {
  const DetailedExpenseStatsEmpty();
}
