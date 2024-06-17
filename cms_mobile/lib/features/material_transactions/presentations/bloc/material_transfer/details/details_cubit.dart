import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_transfer/get_material_transfer_details.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialTransferDetailsState extends Equatable {
  const MaterialTransferDetailsState();

  @override
  List<Object> get props => [];
}

class MaterialTransferDetailsInitial extends MaterialTransferDetailsState {}

class MaterialTransferDetailsLoading extends MaterialTransferDetailsState {}

class MaterialTransferDetailsSuccess extends MaterialTransferDetailsState {
  final MaterialTransferEntity? materialTransfer;

  const MaterialTransferDetailsSuccess({this.materialTransfer});

  @override
  List<Object> get props => [materialTransfer!];
}

class MaterialTransferDetailsFailed extends MaterialTransferDetailsState {
  final String error;

  const MaterialTransferDetailsFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class MaterialTransferDetailsEvent {}

class GetMaterialTransferDetailsEvent extends MaterialTransferDetailsEvent {
  final String materialTransferId;

  GetMaterialTransferDetailsEvent({required this.materialTransferId});
}

class MaterialTransferDetailsCubit extends Cubit<MaterialTransferDetailsState> {
  final GetMaterialTransferDetailsUseCase _getMaterialTransferDetailsUseCase;

  MaterialTransferDetailsCubit(this._getMaterialTransferDetailsUseCase)
      : super(MaterialTransferDetailsInitial());

  void onGetMaterialTransferDetails({required String materialTransferId}) async {
    emit(MaterialTransferDetailsLoading());
    final dataState =
        await _getMaterialTransferDetailsUseCase(params: materialTransferId);
    if (dataState is DataSuccess) {
      emit(MaterialTransferDetailsSuccess(
          materialTransfer: dataState.data as MaterialTransferEntity));
    } else if (dataState is DataFailed) {
      emit(MaterialTransferDetailsFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get material issue details'));
    }
  }
}
