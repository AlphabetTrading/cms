import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_request/get_material_request_details.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialRequestDetailsState extends Equatable {
  const MaterialRequestDetailsState();

  @override
  List<Object> get props => [];
}

class MaterialRequestDetailsInitial extends MaterialRequestDetailsState {}

class MaterialRequestDetailsLoading extends MaterialRequestDetailsState {}

class MaterialRequestDetailsSuccess extends MaterialRequestDetailsState {
  final MaterialRequestEntity? materialRequest;

  const MaterialRequestDetailsSuccess({this.materialRequest});

  @override
  List<Object> get props => [materialRequest!];
}

class MaterialRequestDetailsFailed extends MaterialRequestDetailsState {
  final String error;

  const MaterialRequestDetailsFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class MaterialRequestDetailsEvent {}

class GetMaterialRequestDetailsEvent extends MaterialRequestDetailsEvent {
  final String materialRequestId;

  GetMaterialRequestDetailsEvent({required this.materialRequestId});
}

class MaterialRequestDetailsCubit extends Cubit<MaterialRequestDetailsState> {
  final GetMaterialRequestDetailsUseCase _getMaterialRequestDetailsUseCase;

  MaterialRequestDetailsCubit(this._getMaterialRequestDetailsUseCase)
      : super(MaterialRequestDetailsInitial());

  void onGetMaterialRequestDetails({required String materialRequestId}) async {
    emit(MaterialRequestDetailsLoading());
    final dataState =
        await _getMaterialRequestDetailsUseCase(params: materialRequestId);
    if (dataState is DataSuccess) {
      emit(MaterialRequestDetailsSuccess(
          materialRequest: dataState.data as MaterialRequestEntity));
    } else if (dataState is DataFailed) {
      emit(MaterialRequestDetailsFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get material request details'));
    }
  }
}
