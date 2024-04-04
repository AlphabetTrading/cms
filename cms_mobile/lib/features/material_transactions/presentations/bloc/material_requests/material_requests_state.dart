
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class MaterialRequestState extends Equatable{
  final List<MaterialRequestEntity> ? materialRequests;
  final Failure ? error;

  const MaterialRequestState({this.materialRequests, this.error});

  @override
  List<Object?> get props => [materialRequests, error];
}

class MaterialRequestInitial extends MaterialRequestState {
  const MaterialRequestInitial();
}

class MaterialRequestLoading extends MaterialRequestState {
  const MaterialRequestLoading();
}

class MaterialRequestSuccess extends MaterialRequestState {
  const MaterialRequestSuccess({required List<MaterialRequestEntity> materialRequests}) : super(materialRequests: materialRequests);
}

class MaterialRequestFailed extends MaterialRequestState {
  const MaterialRequestFailed({required Failure error}) : super(error: error);
}

class MaterialRequestEmpty extends MaterialRequestState {
  const MaterialRequestEmpty();
}

class CreateMaterialRequest extends MaterialRequestState {
  const CreateMaterialRequest();
}
class CreateMaterialRequestLoading extends MaterialRequestState {
  const CreateMaterialRequestLoading();
}     

class CreateMaterialRequestSuccess extends MaterialRequestState {
  const CreateMaterialRequestSuccess();
}
class CreateMaterialRequestFailed extends MaterialRequestState {
  const CreateMaterialRequestFailed({required Failure error}) : super(error: error);
}