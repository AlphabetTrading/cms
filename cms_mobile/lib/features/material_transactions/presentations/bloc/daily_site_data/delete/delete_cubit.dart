import 'package:cms_mobile/features/material_transactions/domain/usecases/daily_site_data/delete_daily_site_data.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class DeleteDailySiteDataState extends Equatable {
  const DeleteDailySiteDataState();

  @override
  List<Object> get props => [];
}

class DeleteDailySiteDataInitial extends DeleteDailySiteDataState {}

class DeleteDailySiteDataLoading extends DeleteDailySiteDataState {}

class DeleteDailySiteDataSuccess extends DeleteDailySiteDataState {
  final String dailySiteDataId;
  const DeleteDailySiteDataSuccess({required this.dailySiteDataId});
}

class DeleteDailySiteDataFailed extends DeleteDailySiteDataState {
  final String error;

  const DeleteDailySiteDataFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
class DeleteDailySiteDataEvent {
  final String dailySiteDataId;

  DeleteDailySiteDataEvent({required this.dailySiteDataId});
}

//cubit
class DeleteDailySiteDataCubit extends Cubit<DeleteDailySiteDataState> {
  final DeleteDailySiteDataUseCase _dailySiteDataDeleteUseCase;

  DeleteDailySiteDataCubit(this._dailySiteDataDeleteUseCase)
      : super(DeleteDailySiteDataInitial());

  void onDailySiteDataDelete({required String dailySiteDataId}) async {
    emit(DeleteDailySiteDataLoading());
    final dataState =
        await _dailySiteDataDeleteUseCase(params: dailySiteDataId);
    if (dataState is DataSuccess) {
      emit(DeleteDailySiteDataSuccess(dailySiteDataId: dailySiteDataId));
    } else if (dataState is DataFailed) {
      emit(DeleteDailySiteDataFailed(
          error: dataState.error?.errorMessage ??
              'Failed to delete material return '));
    }
  }
}
