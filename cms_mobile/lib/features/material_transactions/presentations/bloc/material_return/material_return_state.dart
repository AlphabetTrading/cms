
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_Return.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialReturnState extends Equatable{
  final List<MaterialReturnEntity> ? materialReturns;
  final Failure ? error;

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
  const MaterialReturnSuccess({required List<MaterialReturnEntity> materialReturns}) : super(materialReturns: materialReturns);
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
  const CreateMaterialReturnFailed({required Failure error}) : super(error: error);
}