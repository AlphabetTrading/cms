import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/data/models/dashboard.dart';
import 'package:cms_mobile/features/home/domain/usecases/get_detailed_expense_stats.dart';
import 'package:cms_mobile/features/home/presentation/bloc/detailed_expense_stats/detailed_expense_stats_event.dart';
import 'package:cms_mobile/features/home/presentation/bloc/detailed_expense_stats/detailed_expense_stats_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailedExpenseStatsBloc
    extends Bloc<DetailedExpenseStatsEvent, DetailedExpenseStatsState> {
  final GetDetailedExpenseStatsUseCase _detailedExpenseStatsUseCase;

  DetailedExpenseStatsBloc(this._detailedExpenseStatsUseCase)
      : super(const DetailedExpenseStatsInitial()) {
    on<GetDetailedExpenseStatsEvent>(onGetDetailedExpenseStats);
  }
  void onGetDetailedExpenseStats(
    GetDetailedExpenseStatsEvent event,
    Emitter<DetailedExpenseStatsState> emit,
  ) async {
    emit(const DetailedExpenseStatsLoading());
    final dataState = await _detailedExpenseStatsUseCase(
        params: DetailedExpenseStatsParams(
            filterExpenseInput: event.filterExpenseInput));

    debugPrint(dataState.toString());
    if (dataState is DataSuccess) {
      emit(DetailedExpenseStatsSuccess(
          detailedExpenseStats: dataState.data! as DetailedExpenseStatsModel));
    }

    if (dataState is DataFailed) {
      emit(DetailedExpenseStatsFailed(error: dataState.error!));
    }
  }
}
