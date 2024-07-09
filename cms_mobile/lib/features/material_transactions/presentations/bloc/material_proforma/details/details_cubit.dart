import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/usecases/material_proforma/get_material_proforma_details.dart';
import 'package:equatable/equatable.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MaterialProformaDetailsState extends Equatable {
  const MaterialProformaDetailsState();

  @override
  List<Object> get props => [];
}

class MaterialProformaDetailsInitial extends MaterialProformaDetailsState {}

class MaterialProformaDetailsLoading extends MaterialProformaDetailsState {}

class MaterialProformaDetailsSuccess extends MaterialProformaDetailsState {
  final MaterialProformaEntity? materialProforma;

  const MaterialProformaDetailsSuccess({this.materialProforma});

  @override
  List<Object> get props => [materialProforma!];
}

class MaterialProformaDetailsFailed extends MaterialProformaDetailsState {
  final String error;

  const MaterialProformaDetailsFailed({required this.error});

  @override
  List<Object> get props => [error];
}

abstract class MaterialProformaDetailsEvent {}

class GetMaterialProformaDetailsEvent extends MaterialProformaDetailsEvent {
  final String materialProformaId;

  GetMaterialProformaDetailsEvent({required this.materialProformaId});
}

class MaterialProformaDetailsCubit extends Cubit<MaterialProformaDetailsState> {
  final GetMaterialProformaDetailsUseCase _getMaterialProformaDetailsUseCase;

  MaterialProformaDetailsCubit(this._getMaterialProformaDetailsUseCase)
      : super(MaterialProformaDetailsInitial());

  void onGetMaterialProformaDetails(
      {required String materialProformaId}) async {
    emit(MaterialProformaDetailsLoading());
    final dataState =
        await _getMaterialProformaDetailsUseCase(params: materialProformaId);
    if (dataState is DataSuccess) {
      emit(MaterialProformaDetailsSuccess(
          materialProforma: dataState.data as MaterialProformaEntity));
    } else if (dataState is DataFailed) {
      emit(MaterialProformaDetailsFailed(
          error: dataState.error?.errorMessage ??
              'Failed to get material issue details'));
    }
  }
}
