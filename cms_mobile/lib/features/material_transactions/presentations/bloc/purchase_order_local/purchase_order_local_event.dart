import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';

abstract class PurchaseOrderLocalEvent {
  const PurchaseOrderLocalEvent();
}

class GetPurchaseOrderMaterialsLocal extends PurchaseOrderLocalEvent {
  const GetPurchaseOrderMaterialsLocal();
}

class DeletePurchaseOrderMaterialLocal extends PurchaseOrderLocalEvent {
  final int index;
  const DeletePurchaseOrderMaterialLocal(this.index);
}

class AddPurchaseOrderMaterialLocal extends PurchaseOrderLocalEvent {
  final PurchaseOrderMaterialEntity purchaseOrderMaterial;
  const AddPurchaseOrderMaterialLocal(this.purchaseOrderMaterial);
}

class EditPurchaseOrderMaterialLocal extends PurchaseOrderLocalEvent {
  final PurchaseOrderMaterialEntity purchaseOrderMaterial;
  final int index;
  const EditPurchaseOrderMaterialLocal(this.purchaseOrderMaterial, this.index);
}

class ClearPurchaseOrderMaterialsLocal extends PurchaseOrderLocalEvent {
  const ClearPurchaseOrderMaterialsLocal();
}
