import 'package:cms_mobile/features/material_transactions/domain/usecases/material_return/generate_material_return_pdf.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialReturnGeneratePdfState extends Equatable {
  const MaterialReturnGeneratePdfState();

  @override
  List<Object> get props => [];
}

class MaterialReturnGeneratePdfInitial extends MaterialReturnGeneratePdfState {}

class MaterialReturnGeneratePdfLoading extends MaterialReturnGeneratePdfState {}

class MaterialReturnGeneratePdfSuccess extends MaterialReturnGeneratePdfState {
  final String materialReturn;

  const MaterialReturnGeneratePdfSuccess({required this.materialReturn});

  @override
  List<Object> get props => [materialReturn];
}

class MaterialReturnGeneratePdfFailed extends MaterialReturnGeneratePdfState {
  final String error;

  const MaterialReturnGeneratePdfFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class MaterialReturnGeneratePdfEvent {}

class GetMaterialReturnGeneratePdfEvent extends MaterialReturnGeneratePdfEvent {
  final String materialReturnId;

  GetMaterialReturnGeneratePdfEvent({required this.materialReturnId});
}

class MaterialReturnGeneratePdfCubit
    extends Cubit<MaterialReturnGeneratePdfState> {
  final GenerateMaterialReturnPdfUseCase _generateMaterialReturnPdfUseCase;

  MaterialReturnGeneratePdfCubit(this._generateMaterialReturnPdfUseCase)
      : super(MaterialReturnGeneratePdfInitial());

  Future<void> onGetMaterialReturnGeneratePdf(
      {required String materialReturnId}) async {
    emit(MaterialReturnGeneratePdfLoading());
    final dataState =
        await _generateMaterialReturnPdfUseCase(params: materialReturnId);

    if (dataState is DataSuccess) {
      emit(MaterialReturnGeneratePdfSuccess(materialReturn: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(MaterialReturnGeneratePdfFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get material return pdf'));
    }
  }
}
