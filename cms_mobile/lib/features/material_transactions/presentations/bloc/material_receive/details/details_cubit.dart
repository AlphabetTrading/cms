import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_receiving/get_material_receive_details.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialReceiveDetailsState extends Equatable {
  const MaterialReceiveDetailsState();

  @override
  List<Object> get props => [];
}



class MaterialReceiveDetailsInitial extends MaterialReceiveDetailsState {}

class MaterialReceiveDetailsLoading extends MaterialReceiveDetailsState {}

class MaterialReceiveDetailsSuccess extends MaterialReceiveDetailsState {
  final MaterialReceiveEntity? materialReceive;

  const MaterialReceiveDetailsSuccess({this.materialReceive});

  @override
  List<Object> get props => [materialReceive!];
}

class MaterialReceiveDetailsFailed extends MaterialReceiveDetailsState {
  final String error;

  const MaterialReceiveDetailsFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class MaterialReceiveDetailsEvent {}

class GetMaterialReceiveDetailsEvent extends MaterialReceiveDetailsEvent {
  final String materialReceiveId;

  GetMaterialReceiveDetailsEvent({required this.materialReceiveId});
}

class MaterialReceiveDetailsCubit extends Cubit<MaterialReceiveDetailsState> {
  final GetMaterialReceiveDetailsUseCase _getMaterialReceiveDetailsUseCase;

  MaterialReceiveDetailsCubit(this._getMaterialReceiveDetailsUseCase)
      : super(MaterialReceiveDetailsInitial());

  void onGetMaterialReceiveDetails({required String materialReceiveId}) async {
    emit(MaterialReceiveDetailsLoading());
    final dataState =
        await _getMaterialReceiveDetailsUseCase(params: materialReceiveId);
    if (dataState is DataSuccess) {
      emit(MaterialReceiveDetailsSuccess(
          materialReceive: dataState.data as MaterialReceiveEntity));
    } else if (dataState is DataFailed) {
      emit(MaterialReceiveDetailsFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get material issue details'));
    }
  }
}
