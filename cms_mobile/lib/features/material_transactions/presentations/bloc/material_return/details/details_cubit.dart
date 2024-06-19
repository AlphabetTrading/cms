import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_return/get_material_return_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialReturnDetailsState extends Equatable {
  const MaterialReturnDetailsState();

  @override
  List<Object> get props => [];
}

class MaterialReturnDetailsInitial extends MaterialReturnDetailsState {}

class MaterialReturnDetailsLoading extends MaterialReturnDetailsState {}

class MaterialReturnDetailsSuccess extends MaterialReturnDetailsState {
  final MaterialReturnEntity? materialReturn;

  const MaterialReturnDetailsSuccess({this.materialReturn});

  @override
  List<Object> get props => [materialReturn!];
}

class MaterialReturnDetailsFailed extends MaterialReturnDetailsState {
  final String error;

  const MaterialReturnDetailsFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class MaterialReturnDetailsEvent {}

class GetMaterialReturnDetailsEvent extends MaterialReturnDetailsEvent {
  final String materialReturnId;

  GetMaterialReturnDetailsEvent({required this.materialReturnId});
}

class MaterialReturnDetailsCubit extends Cubit<MaterialReturnDetailsState> {
  final GetMaterialReturnDetailsUseCase _getMaterialReturnDetailsUseCase;

  MaterialReturnDetailsCubit(this._getMaterialReturnDetailsUseCase)
      : super(MaterialReturnDetailsInitial());

  void onGetMaterialReturnDetails({required String materialReturnId}) async {
    emit(MaterialReturnDetailsLoading());
    final dataState =
        await _getMaterialReturnDetailsUseCase(params: materialReturnId);
    if (dataState is DataSuccess) {
      emit(MaterialReturnDetailsSuccess(
          materialReturn: dataState.data as MaterialReturnEntity));
    } else if (dataState is DataFailed) {
      emit(MaterialReturnDetailsFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get material return details'));
    }
  }
}
