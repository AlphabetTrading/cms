import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/daily_site_data/edit_daily_site_data.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//state
abstract class EditDailySiteDataState extends Equatable {
  const EditDailySiteDataState();

  @override
  List<Object> get props => [];
}

class EditDailySiteDataInitial extends EditDailySiteDataState {}

class EditDailySiteDataLoading extends EditDailySiteDataState {}

class EditDailySiteDataSuccess extends EditDailySiteDataState {}

class EditDailySiteDataFailed extends EditDailySiteDataState {
  final String error;

  const EditDailySiteDataFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//event
// abstract class EditDailySiteDataEvent {}

class EditDailySiteDataEvent {
  final EditDailySiteDataParamsEntity editDailySiteDataParamsEntity;

  EditDailySiteDataEvent({required this.editDailySiteDataParamsEntity});
}

//cubit
class EditDailySiteDataCubit extends Cubit<EditDailySiteDataState> {
  final EditDailySiteDataUseCase _editDailySiteDataUseCase;

  EditDailySiteDataCubit(this._editDailySiteDataUseCase)
      : super(EditDailySiteDataInitial());

  void onEditDailySiteData(
      {required EditDailySiteDataParamsEntity
          editDailySiteDataParamsEntity}) async {
    emit(EditDailySiteDataLoading());
    final dataState =
        await _editDailySiteDataUseCase(params: editDailySiteDataParamsEntity);
    if (dataState is DataSuccess) {
      emit(EditDailySiteDataSuccess());
    } else if (dataState is DataFailed) {
      emit(EditDailySiteDataFailed(
          error: dataState.error?.errorMessage ??
              'Failed to edit material issue '));
    }
  }
}
