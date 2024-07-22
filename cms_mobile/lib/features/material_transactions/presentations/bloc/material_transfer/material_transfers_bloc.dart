import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_transfer/create_material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_transfer/get_material_transfer_details.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_transfer/get_material_transfers.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/material_transfers_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_transfer/material_transfers_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialTransferBloc
    extends Bloc<MaterialTransferEvent, MaterialTransferState> {
  final GetMaterialTransfersUseCase _materialTransferUseCase;
  final CreateMaterialTransferUseCase _createMaterialTransferUseCase;
  final GetMaterialTransferDetailsUseCase _getMaterialTransferDetailsUseCase;

  MaterialTransferBloc(
      this._materialTransferUseCase,
      this._createMaterialTransferUseCase,
      this._getMaterialTransferDetailsUseCase)
      : super(const MaterialTransferInitial()) {
    on<GetMaterialTransfers>(onGetMaterialTransfers);
    on<CreateMaterialTransferEvent>(onCreateMaterialTransfer);
    // on<GetMaterialTransferDetailsEvent>(onGetMaterialTransferDetails);
  }

  void onGetMaterialTransfers(
      GetMaterialTransfers event, Emitter<MaterialTransferState> emit) async {
    emit(const MaterialTransfersLoading());

    final dataState = await _materialTransferUseCase(
        params: MaterialTransferParams(
      filterMaterialTransferInput: event.filterMaterialTransferInput,
      orderBy: event.orderBy,
      paginationInput: event.paginationInput,
      mine: event.mine,
    ));
    if (dataState is DataSuccess) {
      debugPrint('DataState is success, data: ${dataState.data!.meta.count}');

      emit(MaterialTransfersSuccess(materialTransfers: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(MaterialTransfersFailed(error: dataState.error!));
    }
  }

  void onCreateMaterialTransfer(CreateMaterialTransferEvent event,
      Emitter<MaterialTransferState> emit) async {
    emit(const CreateMaterialTransferLoading());

    final dataState = await _createMaterialTransferUseCase(
        params: event.createMaterialTransferParamsEntity);

    if (dataState is DataSuccess) {
      emit(const CreateMaterialTransferSuccess());
    }

    if (dataState is DataFailed) {
      emit(CreateMaterialTransferFailed(error: dataState.error!));
    }
  }
}
