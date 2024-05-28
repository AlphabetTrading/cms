import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';

abstract class MaterialReturnLocalEvent{
  const MaterialReturnLocalEvent();
}

class GetMaterialReturnMaterialsLocal extends MaterialReturnLocalEvent{
  const GetMaterialReturnMaterialsLocal();
}

class DeleteMaterialReturnMaterialLocal extends MaterialReturnLocalEvent{
  final int index;
  const DeleteMaterialReturnMaterialLocal(this.index);
}

class AddMaterialReturnMaterialLocal extends MaterialReturnLocalEvent{
  final MaterialReturnMaterialEntity materialReturnMaterial;
  const AddMaterialReturnMaterialLocal(this.materialReturnMaterial);
}

class EditMaterialReturnMaterialLocal extends MaterialReturnLocalEvent{
  final MaterialReturnMaterialEntity materialReturnMaterial;
  final int index;
  const EditMaterialReturnMaterialLocal(this.materialReturnMaterial,this.index);
}

class ClearMaterialReturnMaterialsLocal extends MaterialReturnLocalEvent{
  const ClearMaterialReturnMaterialsLocal();
}



