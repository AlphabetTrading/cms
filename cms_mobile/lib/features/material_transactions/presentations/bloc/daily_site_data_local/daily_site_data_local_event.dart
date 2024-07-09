
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';

abstract class DailySiteDataLocalEvent {
  const DailySiteDataLocalEvent();
}

class GetDailySiteDataMaterialsLocal extends DailySiteDataLocalEvent {
  const GetDailySiteDataMaterialsLocal();
}

class DeleteDailySiteDataMaterialLocal extends DailySiteDataLocalEvent {
  final int index;
  const DeleteDailySiteDataMaterialLocal(this.index);
}

class AddDailySiteDataMaterialLocal extends DailySiteDataLocalEvent {
  final DailySiteDataEnitity dailySiteDataMaterial;
  const AddDailySiteDataMaterialLocal(this.dailySiteDataMaterial);
}

class AddDailySiteDataMaterialsLocal extends DailySiteDataLocalEvent {
  final List<DailySiteDataEnitity> dailySiteDataMaterials;
  const AddDailySiteDataMaterialsLocal(this.dailySiteDataMaterials);
}

class EditDailySiteDataMaterialLocal extends DailySiteDataLocalEvent {
  final DailySiteDataEnitity dailySiteDataMaterial;
  final int index;
  const EditDailySiteDataMaterialLocal(this.dailySiteDataMaterial, this.index);
}

class ClearDailySiteDataMaterialsLocal extends DailySiteDataLocalEvent {
  const ClearDailySiteDataMaterialsLocal();
}
