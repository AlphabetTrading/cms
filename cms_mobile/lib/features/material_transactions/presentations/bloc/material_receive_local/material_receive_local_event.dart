import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';

abstract class MaterialReceiveLocalEvent{
  const MaterialReceiveLocalEvent();
}

class GetMaterialReceiveMaterialsLocal extends MaterialReceiveLocalEvent{
  const GetMaterialReceiveMaterialsLocal();
}

class DeleteMaterialReceiveMaterialLocal extends MaterialReceiveLocalEvent{
  final int index;
  const DeleteMaterialReceiveMaterialLocal(this.index);
}

class AddMaterialReceiveMaterialLocal extends MaterialReceiveLocalEvent{
  final MaterialReceiveMaterialEntity materialReceiveMaterial;
  const AddMaterialReceiveMaterialLocal(this.materialReceiveMaterial);
}

class AddMaterialReceiveMaterialsLocal extends MaterialReceiveLocalEvent{
  final List<MaterialReceiveMaterialEntity> materialReceiveMaterials;
  const AddMaterialReceiveMaterialsLocal(this.materialReceiveMaterials);
}

class EditMaterialReceiveMaterialLocal extends MaterialReceiveLocalEvent{
  final MaterialReceiveMaterialEntity materialReceiveMaterial;
  final int index;
  const EditMaterialReceiveMaterialLocal(this.materialReceiveMaterial,this.index);
}

class ClearMaterialReceiveMaterialsLocal extends MaterialReceiveLocalEvent{
  const ClearMaterialReceiveMaterialsLocal();
}



