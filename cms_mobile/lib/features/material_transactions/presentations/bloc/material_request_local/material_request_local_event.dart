import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';

abstract class MaterialRequestLocalEvent{
  const MaterialRequestLocalEvent();
}

class GetMaterialRequestMaterialsLocal extends MaterialRequestLocalEvent{
  const GetMaterialRequestMaterialsLocal();
}

class DeleteMaterialRequestMaterialLocal extends MaterialRequestLocalEvent{
  final int index;
  const DeleteMaterialRequestMaterialLocal(this.index);
}

class AddMaterialRequestMaterialLocal extends MaterialRequestLocalEvent{
  final MaterialRequestMaterialEntity materialRequestMaterial;
  const AddMaterialRequestMaterialLocal(this.materialRequestMaterial);
}

class EditMaterialRequestMaterialLocal extends MaterialRequestLocalEvent{
  final MaterialRequestMaterialEntity materialRequestMaterial;
  final int index;
  const EditMaterialRequestMaterialLocal(this.materialRequestMaterial,this.index);
}



