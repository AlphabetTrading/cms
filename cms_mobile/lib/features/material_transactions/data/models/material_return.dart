
import 'package:cms_mobile/features/items/data/models/item.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';

class MaterialReturnMaterialModel extends MaterialReturnMaterialEntity {
  const MaterialReturnMaterialModel({
    required double quantity,
    String? remark,
    required WarehouseItemModel material,
    required String issueVoucherId,
    required double unitCost,
  }) : super(
            quantity: quantity,
            remark: remark,
            material: material,
            issueVoucherId: issueVoucherId,
            unitCost: unitCost
            // unit: unit
            );

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'remark': remark,
    };
  }

  @override
  List<Object?> get props =>
      [remark, quantity, material, issueVoucherId, unitCost];
}

class CreateMaterialReturnParamsModel
    extends CreateMaterialReturnParamsEntity<MaterialReturnMaterialModel> {
  const CreateMaterialReturnParamsModel(
      {required String projectId,
      required List<MaterialReturnMaterialModel> materialReturnMaterials,
      required String returnedById,
      required String receivingStoreId})
      : super(
            returnedById: returnedById,
            projectId: projectId,
            materialReturnMaterials: materialReturnMaterials,
            receivingStoreId: receivingStoreId);

  @override
  List<Object?> get props =>
      [projectId, returnedById, materialReturnMaterials, receivingStoreId];

  factory CreateMaterialReturnParamsModel.fromEntity(
      CreateMaterialReturnParamsEntity entity) {
    return CreateMaterialReturnParamsModel(
        projectId: entity.projectId,
        returnedById: entity.returnedById,
        receivingStoreId: entity.receivingStoreId,
        materialReturnMaterials: entity.materialReturnMaterials
            .map((e) => MaterialReturnMaterialModel(
                quantity: e.quantity,
                remark: e.remark,
                issueVoucherId: e.issueVoucherId,
                material: e.material as WarehouseItemModel,
                unitCost: e.unitCost))
            .toList());
  }
}
