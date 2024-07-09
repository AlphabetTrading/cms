
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';

abstract class MaterialProformaLocalEvent{
  const MaterialProformaLocalEvent();
}

class GetMaterialProformaMaterialsLocal extends MaterialProformaLocalEvent{
  const GetMaterialProformaMaterialsLocal();
}

class DeleteMaterialProformaMaterialLocal extends MaterialProformaLocalEvent{
  final int index;
  const DeleteMaterialProformaMaterialLocal(this.index);
}

class AddMaterialProformaMaterialLocal extends MaterialProformaLocalEvent{
  final MaterialProformaMaterialEntity materialProformaMaterial;
  const AddMaterialProformaMaterialLocal(this.materialProformaMaterial);
}

class AddMaterialProformaMaterialsLocal extends MaterialProformaLocalEvent{
  final List<MaterialProformaMaterialEntity> materialProformaMaterials;
  const AddMaterialProformaMaterialsLocal(this.materialProformaMaterials);
}

class EditMaterialProformaMaterialLocal extends MaterialProformaLocalEvent{
  final MaterialProformaMaterialEntity materialProformaMaterial;
  final int index;
  const EditMaterialProformaMaterialLocal(this.materialProformaMaterial,this.index);
}

class ClearMaterialProformaMaterialsLocal extends MaterialProformaLocalEvent{
  const ClearMaterialProformaMaterialsLocal();
}



