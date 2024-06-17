import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_return.dart';
import 'package:equatable/equatable.dart';

abstract class MaterialReturnState extends Equatable {
  final MaterialReturnListWithMeta? materialReturns;
  final Failure? error;

  const MaterialReturnState({this.materialReturns, this.error});

  @override
  List<Object?> get props => [materialReturns, error];
}

class MaterialReturnInitial extends MaterialReturnState {
  const MaterialReturnInitial();
}

class MaterialReturnLoading extends MaterialReturnState {
  const MaterialReturnLoading();
}

class MaterialReturnSuccess extends MaterialReturnState {
  const MaterialReturnSuccess(
      {required MaterialReturnListWithMeta materialReturns})
      : super(materialReturns: materialReturns);
}

class MaterialReturnFailed extends MaterialReturnState {
  const MaterialReturnFailed({required Failure error}) : super(error: error);
}

class MaterialReturnEmpty extends MaterialReturnState {
  const MaterialReturnEmpty();
}

class CreateMaterialReturnLoading extends MaterialReturnState {
  const CreateMaterialReturnLoading();
}

class CreateMaterialReturnSuccess extends MaterialReturnState {
  const CreateMaterialReturnSuccess();
}

class CreateMaterialReturnFailed extends MaterialReturnState {
  const CreateMaterialReturnFailed({required Failure error})
      : super(error: error);
}
