import 'package:cms_mobile/features/material_transactions/domain/usecases/material_request/generate_material_request_pdf.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialRequestGeneratePdfState extends Equatable {
  const MaterialRequestGeneratePdfState();

  @override
  List<Object> get props => [];
}

class MaterialRequestGeneratePdfInitial extends MaterialRequestGeneratePdfState {}

class MaterialRequestGeneratePdfLoading extends MaterialRequestGeneratePdfState {}

class MaterialRequestGeneratePdfSuccess extends MaterialRequestGeneratePdfState {
  final String materialRequest;

  const MaterialRequestGeneratePdfSuccess({required this.materialRequest});

  @override
  List<Object> get props => [materialRequest];
}

class MaterialRequestGeneratePdfFailed extends MaterialRequestGeneratePdfState {
  final String error;

  const MaterialRequestGeneratePdfFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class MaterialRequestGeneratePdfEvent {}

class GetMaterialRequestGeneratePdfEvent extends MaterialRequestGeneratePdfEvent {
  final String materialRequestId;

  GetMaterialRequestGeneratePdfEvent({required this.materialRequestId});
}

class MaterialRequestGeneratePdfCubit extends Cubit<MaterialRequestGeneratePdfState> {
  final GenerateMaterialRequestPdfUseCase _generateMaterialRequestPdfUseCase;

  MaterialRequestGeneratePdfCubit(this._generateMaterialRequestPdfUseCase)
      : super(MaterialRequestGeneratePdfInitial());

  Future<void> onGetMaterialRequestGeneratePdf({required String materialRequestId}) async {
    emit(MaterialRequestGeneratePdfLoading());
    final dataState =
        await _generateMaterialRequestPdfUseCase(params: materialRequestId);

    if (dataState is DataSuccess) {
      emit(MaterialRequestGeneratePdfSuccess(
          materialRequest: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(MaterialRequestGeneratePdfFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get material request pdf'));
    }
  }
}
