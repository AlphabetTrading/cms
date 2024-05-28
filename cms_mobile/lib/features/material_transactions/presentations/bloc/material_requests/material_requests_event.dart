import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';

abstract class MaterialRequestEvent {
  const MaterialRequestEvent();
}

class GetMaterialRequestsEvent extends MaterialRequestEvent {
  const GetMaterialRequestsEvent();
}

class GetMaterialRequestEvent extends MaterialRequestEvent {
  const GetMaterialRequestEvent();
}

class CreateMaterialRequestEvent extends MaterialRequestEvent {
  final CreateMaterialRequestParamsEntity createMaterialRequestParamsEntity;

  const CreateMaterialRequestEvent(
      {required this.createMaterialRequestParamsEntity});
}

class UpdateMaterialRequestEvent extends MaterialRequestEvent {
  final String id;
  const UpdateMaterialRequestEvent(this.id);
}

class DeleteMaterialRequestEvent extends MaterialRequestEvent {
  final String id;
  const DeleteMaterialRequestEvent(this.id);
}
