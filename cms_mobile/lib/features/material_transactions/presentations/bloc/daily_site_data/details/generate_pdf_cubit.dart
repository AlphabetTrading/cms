import 'package:cms_mobile/features/material_transactions/domain/usecases/daily_site_data/generate_daily_site_data_pdf.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DailySiteDataGeneratePdfState extends Equatable {
  const DailySiteDataGeneratePdfState();

  @override
  List<Object> get props => [];
}

class DailySiteDataGeneratePdfInitial extends DailySiteDataGeneratePdfState {}

class DailySiteDataGeneratePdfLoading extends DailySiteDataGeneratePdfState {}

class DailySiteDataGeneratePdfSuccess extends DailySiteDataGeneratePdfState {
  final String dailySiteData;

  const DailySiteDataGeneratePdfSuccess({required this.dailySiteData});

  @override
  List<Object> get props => [dailySiteData];
}

class DailySiteDataGeneratePdfFailed extends DailySiteDataGeneratePdfState {
  final String error;

  const DailySiteDataGeneratePdfFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class DailySiteDataGeneratePdfEvent {}

class GetDailySiteDataGeneratePdfEvent extends DailySiteDataGeneratePdfEvent {
  final String dailySiteDataId;

  GetDailySiteDataGeneratePdfEvent({required this.dailySiteDataId});
}

class DailySiteDataGeneratePdfCubit extends Cubit<DailySiteDataGeneratePdfState> {
  final GenerateDailySiteDataPdfUseCase _generateDailySiteDataPdfUseCase;

  DailySiteDataGeneratePdfCubit(this._generateDailySiteDataPdfUseCase)
      : super(DailySiteDataGeneratePdfInitial());

  Future<void> onGetDailySiteDataGeneratePdf({required String dailySiteDataId}) async {
    emit(DailySiteDataGeneratePdfLoading());
    final dataState =
        await _generateDailySiteDataPdfUseCase(params: dailySiteDataId);

    if (dataState is DataSuccess) {
      emit(DailySiteDataGeneratePdfSuccess(
          dailySiteData: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(DailySiteDataGeneratePdfFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get daily site data pdf'));
    }
  }
}
