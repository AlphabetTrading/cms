import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/domain/entities/dashboard.dart';
import 'package:equatable/equatable.dart';

abstract class DetailedStockStatsState extends Equatable {
  final DetailedStockStatsEntity? detailedStockStats;
  final Failure? error;

  const DetailedStockStatsState({this.detailedStockStats, this.error});

  @override
  List<Object?> get props => [detailedStockStats, error];
}

class DetailedStockStatsInitial extends DetailedStockStatsState {
  const DetailedStockStatsInitial();
}

class DetailedStockStatsLoading extends DetailedStockStatsState {
  const DetailedStockStatsLoading();
}

class DetailedStockStatsSuccess extends DetailedStockStatsState {
  const DetailedStockStatsSuccess(
      {required DetailedStockStatsEntity detailedStockStats})
      : super(detailedStockStats: detailedStockStats);
}

class DetailedStockStatsFailed extends DetailedStockStatsState {
  const DetailedStockStatsFailed({required Failure error})
      : super(error: error);
}

class DetailedStockStatsEmpty extends DetailedStockStatsState {
  const DetailedStockStatsEmpty();
}
