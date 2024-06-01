import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';

abstract class MaterialIssueLocalEvent{
  const MaterialIssueLocalEvent();
}

class GetMaterialIssueMaterialsLocal extends MaterialIssueLocalEvent{
  const GetMaterialIssueMaterialsLocal();
}

class DeleteMaterialIssueMaterialLocal extends MaterialIssueLocalEvent{
  final int index;
  const DeleteMaterialIssueMaterialLocal(this.index);
}

class AddMaterialIssueMaterialLocal extends MaterialIssueLocalEvent{
  final MaterialIssueMaterialEntity materialIssueMaterial;
  const AddMaterialIssueMaterialLocal(this.materialIssueMaterial);
}

class AddMaterialIssueMaterialsLocal extends MaterialIssueLocalEvent{
  final List<MaterialIssueMaterialEntity> materialIssueMaterials;
  const AddMaterialIssueMaterialsLocal(this.materialIssueMaterials);
}

class EditMaterialIssueMaterialLocal extends MaterialIssueLocalEvent{
  final MaterialIssueMaterialEntity materialIssueMaterial;
  final int index;
  const EditMaterialIssueMaterialLocal(this.materialIssueMaterial,this.index);
}

class ClearMaterialIssueMaterialsLocal extends MaterialIssueLocalEvent{
  const ClearMaterialIssueMaterialsLocal();
}



