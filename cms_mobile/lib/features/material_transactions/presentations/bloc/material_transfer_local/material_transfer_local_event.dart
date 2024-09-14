import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';

abstract class MaterialTransferLocalEvent{
  const MaterialTransferLocalEvent();
}

class GetMaterialTransferMaterialsLocal extends MaterialTransferLocalEvent{
  const GetMaterialTransferMaterialsLocal();
}

class DeleteMaterialTransferMaterialLocal extends MaterialTransferLocalEvent{
  final int index;
  const DeleteMaterialTransferMaterialLocal(this.index);
}

class AddMaterialTransferMaterialLocal extends MaterialTransferLocalEvent{
  final MaterialTransferEntity materialTransferMaterial;
  const AddMaterialTransferMaterialLocal(this.materialTransferMaterial);
}

class AddMaterialTransferMaterialsLocal extends MaterialTransferLocalEvent{
  final List<MaterialTransferEntity> materialTransferMaterials;
  const AddMaterialTransferMaterialsLocal(this.materialTransferMaterials);
}

class EditMaterialTransferMaterialLocal extends MaterialTransferLocalEvent{
  final MaterialTransferEntity materialTransferMaterial;
  final int index;
  const EditMaterialTransferMaterialLocal(this.materialTransferMaterial,this.index);
}

class ClearMaterialTransferMaterialsLocal extends MaterialTransferLocalEvent{
  const ClearMaterialTransferMaterialsLocal();
}



