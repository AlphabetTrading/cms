import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/generate_material_receive_pdf.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/get_material_receive_details.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_Receive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialReceiveGeneratePdfState extends Equatable {
  const MaterialReceiveGeneratePdfState();

  @override
  List<Object> get props => [];
}

class MaterialReceiveGeneratePdfInitial extends MaterialReceiveGeneratePdfState {}

class MaterialReceiveGeneratePdfLoading extends MaterialReceiveGeneratePdfState {}

class MaterialReceiveGeneratePdfSuccess extends MaterialReceiveGeneratePdfState {
  final String materialReceive;

  const MaterialReceiveGeneratePdfSuccess({required this.materialReceive});

  @override
  List<Object> get props => [materialReceive];
}

class MaterialReceiveGeneratePdfFailed extends MaterialReceiveGeneratePdfState {
  final String error;

  const MaterialReceiveGeneratePdfFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class MaterialReceiveGeneratePdfEvent {}

class GetMaterialReceiveGeneratePdfEvent extends MaterialReceiveGeneratePdfEvent {
  final String materialReceiveId;

  GetMaterialReceiveGeneratePdfEvent({required this.materialReceiveId});
}

class MaterialReceiveGeneratePdfCubit extends Cubit<MaterialReceiveGeneratePdfState> {
  final GenerateMaterialReceivePdfUseCase _generateMaterialReceivePdfUseCase;

  MaterialReceiveGeneratePdfCubit(this._generateMaterialReceivePdfUseCase)
      : super(MaterialReceiveGeneratePdfInitial());

  Future<void> onGetMaterialReceiveGeneratePdf({required String materialReceiveId}) async {
    emit(MaterialReceiveGeneratePdfLoading());
    final dataState =
        await _generateMaterialReceivePdfUseCase(params: materialReceiveId);

    if (dataState is DataSuccess) {
      emit(MaterialReceiveGeneratePdfSuccess(
          materialReceive: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(MaterialReceiveGeneratePdfFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get material receive pdf'));
    }
  }
}
