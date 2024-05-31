import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:equatable/equatable.dart';


abstract class MaterialRequestState extends Equatable {
  final MaterialRequestEntityListWithMeta? materialRequests;
  final MaterialRequestEntity? materialRequest;

  final Failure? error;

  const MaterialRequestState(
      {this.materialRequests, this.error, this.materialRequest});

  @override
  List<Object?> get props => [materialRequests, error];
}

// abstract class MaterialRequestState extends Equatable {
//   final List<MaterialRequestEntity>? materialRequests;
//   final Failure? error;

//   const MaterialRequestState({this.materialRequests, this.error});

//   @override
//   List<Object?> get props => [materialRequests, error];
// }

class MaterialRequestInitial extends MaterialRequestState {
  const MaterialRequestInitial();
}

class MaterialRequestLoading extends MaterialRequestState {
  const MaterialRequestLoading();
}

class MaterialRequestSuccess extends MaterialRequestState {
  const MaterialRequestSuccess(
       {required MaterialRequestEntityListWithMeta materialRequests})
      : super(materialRequests: materialRequests);
}

class MaterialRequestFailed extends MaterialRequestState {
  const MaterialRequestFailed({required Failure error}) : super(error: error);
}

class MaterialRequestEmpty extends MaterialRequestState {
  const MaterialRequestEmpty();
}

class CreateMaterialRequestLoading extends MaterialRequestState {
  const CreateMaterialRequestLoading();
}

class CreateMaterialRequestSuccess extends MaterialRequestState {
  const CreateMaterialRequestSuccess();
}

class CreateMaterialRequestFailed extends MaterialRequestState {
  const CreateMaterialRequestFailed({required Failure error})
      : super(error: error);
}
