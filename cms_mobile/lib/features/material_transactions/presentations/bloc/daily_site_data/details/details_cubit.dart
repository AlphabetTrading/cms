import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/daily_site_data/get_daily_site_data_details.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DailySiteDataDetailsState extends Equatable {
  const DailySiteDataDetailsState();

  @override
  List<Object> get props => [];
}

class DailySiteDataDetailsInitial extends DailySiteDataDetailsState {}

class DailySiteDataDetailsLoading extends DailySiteDataDetailsState {}

class DailySiteDataDetailsSuccess extends DailySiteDataDetailsState {
  final DailySiteDataEntity? dailySiteData;

  const DailySiteDataDetailsSuccess({this.dailySiteData});

  @override
  List<Object> get props => [dailySiteData!];
}

class DailySiteDataDetailsFailed extends DailySiteDataDetailsState {
  final String error;

  const DailySiteDataDetailsFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class DailySiteDataDetailsEvent {}

class GetDailySiteDataDetailsEvent extends DailySiteDataDetailsEvent {
  final String dailySiteDataId;

  GetDailySiteDataDetailsEvent({required this.dailySiteDataId});
}

class DailySiteDataDetailsCubit extends Cubit<DailySiteDataDetailsState> {
  final GetDailySiteDataDetailsUseCase _getDailySiteDataDetailsUseCase;

  DailySiteDataDetailsCubit(this._getDailySiteDataDetailsUseCase)
      : super(DailySiteDataDetailsInitial());

  void onGetDailySiteDataDetails({required String dailySiteDataId}) async {
    emit(DailySiteDataDetailsLoading());
    final dataState =
        await _getDailySiteDataDetailsUseCase(params: dailySiteDataId);
    if (dataState is DataSuccess) {
      emit(DailySiteDataDetailsSuccess(
          dailySiteData: dataState.data as DailySiteDataEntity));
    } else if (dataState is DataFailed) {
      emit(DailySiteDataDetailsFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get material issue details'));
    }
  }
}
