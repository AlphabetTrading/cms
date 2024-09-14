import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/data/models/dashboard.dart';
import 'package:cms_mobile/features/home/domain/usecases/get_detailed_stock_stats.dart';
import 'package:cms_mobile/features/home/presentation/bloc/detailed_stock_stats/detailed_stock_stats_event.dart';
import 'package:cms_mobile/features/home/presentation/bloc/detailed_stock_stats/detailed_stock_stats_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailedStockStatsBloc
    extends Bloc<DetailedStockStatsEvent, DetailedStockStatsState> {
  final GetDetailedStockStatsUseCase _detailedStockStatsUseCase;

  DetailedStockStatsBloc(this._detailedStockStatsUseCase)
      : super(const DetailedStockStatsInitial()) {
    on<GetDetailedStockStatsEvent>(onGetDetailedStockStats);
  }
  void onGetDetailedStockStats(
    GetDetailedStockStatsEvent event,
    Emitter<DetailedStockStatsState> emit,
  ) async {
    emit(const DetailedStockStatsLoading());
    final dataState = await _detailedStockStatsUseCase(
        params:
            DetailedStockStatsParams(filterStockInput: event.filterStockInput));

    if (dataState is DataSuccess) {
      emit(DetailedStockStatsSuccess(
          detailedStockStats: dataState.data! as DetailedStockStatsModel));
    }

    if (dataState is DataFailed) {
      emit(DetailedStockStatsFailed(error: dataState.error!));
    }
  }
}
