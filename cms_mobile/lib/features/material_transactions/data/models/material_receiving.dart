import 'package:cms_mobile/core/entities/string_filter.dart';
import 'package:cms_mobile/features/material_transactions/data/models/product_variant.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';
import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:cms_mobile/features/warehouse/data/models/warehouse.dart';

import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:flutter/material.dart';

class MaterialReceiveModel extends MaterialReceiveEntity {
  const MaterialReceiveModel({
    required super.id,
    required super.serialNumber,
    required super.status,
    required super.approvedById,
    UserModel? super.approvedBy,
    required super.projectDetails,
    required super.requisitionNumber,
    List<MaterialReceiveItemModel>? super.items,
    required super.preparedById,
    UserModel? super.preparedBy,
    required super.createdAt,
    required super.updatedAt,
    WarehouseModel? super.warehouse,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory MaterialReceiveModel.fromJson(Map<String, dynamic> json) {
    debugPrint("MaterialReceiveModel.fromJson: $json");

    return MaterialReceiveModel(
        id: json['id'],
        serialNumber: json['serialNumber'],
        projectDetails: json['projectDetails'],
        requisitionNumber: json['requisitionNumber'],
        // items: json['items'].map<ReceiveVoucherMaterialModel>((item) {
        //   return ReceiveVoucherMaterialModel.fromJson(item);
        // }).toList(),
        // items: json['items'] != null
        //     ? json['items']
        //         .map<ReceiveVoucherMaterialModel>(
        //             (item) => ReceiveVoucherMaterialModel.fromJson(item))
        //         .toList()
        //     : <ReceiveVoucherMaterialModel>[], // if items is null, return an empty list
        items: json['items'] != null
            ? json['items']
                .map<MaterialReceiveItemModel>(
                    (item) => MaterialReceiveItemModel.fromJson(item))
                .toList()
            : <MaterialReceiveItemModel>[], // if items is null, return an empty list
        preparedById: json['preparedById'],
        preparedBy: json['preparedBy'] != null
            ? UserModel.fromJson(json['preparedBy'])
            : null,
        approvedById: json['approvedById'],
        approvedBy: json['approvedBy'] != null
            ? UserModel.fromJson(json['approvedBy'])
            : null,
        status: json['status'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        warehouse: json['warehouseStore'] != null
            ? WarehouseModel.fromJson(json['warehouseStore'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serialNumber': serialNumber,
      'status': status,
      'approvedById': approvedById,
      'approvedBy': approvedBy,
      'projectDetails': projectDetails,
      'requisitionNumber': requisitionNumber,
      'items': items,
      'preparedById': preparedById,
      'preparedBy': preparedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class ReceiveVoucherMaterialModel extends ReceiveVoucherMaterialEntity {
  const ReceiveVoucherMaterialModel({
    required super.id,
    required ProductVariantModel? super.productVariant,
    required super.quantity,
    required super.remark,
    required super.totalCost,
    required super.unitCost,
    required super.subStructureDescription,
    required super.superStructureDescription,
    required super.useType,
    required super.materialReceiveVoucherId,
  });

  factory ReceiveVoucherMaterialModel.fromJson(Map<String, dynamic> json) {
    return ReceiveVoucherMaterialModel(
        id: json['id'],
        productVariant: json["productVariant"] != null
            ? ProductVariantModel.fromJson(json['productVariant'])
            : null,
        quantity: (json['quantity'] as num).toDouble(),
        remark: json['remark'],
        totalCost: (json['totalCost'] as num).toDouble(),
        unitCost: (json['unitCost'] as num).toDouble(),
        subStructureDescription: subStructureUseDescriptionFromString(
            json['subStructureDescription']),
        superStructureDescription: superStructureUseDescriptionFromString(
            json['superStructureDescription']),
        useType: useTypeFromString(json['useType']),
        materialReceiveVoucherId: json['materialReceiveVoucherId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productVariant': productVariant,
      'quantity': quantity,
      'remark': remark,
      'totalCost': totalCost,
      'unitCost': unitCost,
      'subStructureDescription': subStructureDescription,
      'superStructureDescription': superStructureDescription,
      'useType': useType,
      'materialReceiveVoucherId': materialReceiveVoucherId
    };
  }
}

class MaterialReceiveListWithMeta extends MaterialReceiveEntityListWithMeta {
  MaterialReceiveListWithMeta({
    required MetaModel super.meta,
    required List<MaterialReceiveModel> super.items,
  });

  factory MaterialReceiveListWithMeta.fromJson(Map<String, dynamic> json) {
    return MaterialReceiveListWithMeta(
      meta: MetaModel.fromJson(json['meta']),
      items: json['items']
          .map<MaterialReceiveModel>(
              (item) => MaterialReceiveModel.fromJson(item))
          .toList(),
    );
  }
}

class MaterialReceiveMaterialModel extends MaterialReceiveMaterialEntity {
  const MaterialReceiveMaterialModel({
    required super.purchaseOrderId,
    // super.material,
    super.transportationCost,
    super.loadingCost,
    super.unloadingCost,
    super.remark,
  });

  Map<String, dynamic> toJson() {
    return {
      'purchaseOrderId': purchaseOrderId,
      // 'material': material,
      'transportationCost': transportationCost,
      'loadingCost': loadingCost,
      'unloadingCost': unloadingCost,
      'remark': remark,
    };
  }

  factory MaterialReceiveMaterialModel.fromJson(Map<String, dynamic> json) {
    debugPrint("MaterialReceiveMaterialModel.fromJson: $json");
// {__typename: MaterialReceiveItem,
//createdAt: 2024-08-14T12:06:35.012Z,
//id: fe5f60c7-38e5-402d-b400-2426a2edf8d8, loadingCost: 800,
//materialReceiveVoucherId: 702581fb-c8b7-408b-994c-3d5c2e96b5b1,
// transportationCost: 1500,
// unloadingCost: 1100,
// updatedAt: 2024-08-14T12:06:35.012Z,
// remark: null,
// receivedQuantity: 2,
// purchaseOrderItemId: 84d47293-e5a0-4372-9028-477e2a99b504,
// purchaseOrderItem: {
//    __typename: PurchaseOrderItem,
//    createdAt: 2024-08-14T12:05:31.315Z,
//    id: 84d47293-e5a0-4372-9028-477e2a99b504,
//    materialRequestItemId: 540a5fa4-db98-4060-8178-988a4de827c7,
//    proformaId: null,
//    purchaseOrderId: c144367d-2eb9-46c4-88b1-2cfbbf20a25e,
//    quantity: 10,
//    remark: null,
//    totalPrice: 150,
//    unitPrice: 15,
// updatedAt: 2024-08-14T12:05:31.315Z}}
    return MaterialReceiveMaterialModel(
        purchaseOrderId: json['purchaseOrderItemId'],
        // material: json['purchaseOrderItem'] != null
        //     ? ReceiveVoucherMaterialModel.fromJson(json['purchaseOrderItem'])
        //     : null,
        transportationCost: json['transportationCost'],
        loadingCost: json['loadingCost'],
        unloadingCost: json['unloadingCost'],
        remark: json['remark']);
  }
}

class MaterialReceiveItemModel extends MaterialReceiveItemEntity {
  const MaterialReceiveItemModel({
    required super.id,
    required super.materialReceiveVoucherId,
    required super.purchaseOrderItemId,
    required super.loadingCost,
    required super.transportationCost,
    required super.unloadingCost,
    required super.remark,
    required super.receivedQuantity,
    super.purchaseOrderItem,
  });

  factory MaterialReceiveItemModel.fromJson(Map<String, dynamic> json) {
    debugPrint("MaterialReceiveItemModel.fromJson: $json");

    return MaterialReceiveItemModel(
      id: json['id'],
      materialReceiveVoucherId: json['materialReceiveVoucherId'],
      purchaseOrderItemId: json['purchaseOrderItemId'],
      loadingCost: json['loadingCost'],
      transportationCost: json['transportationCost'],
      unloadingCost: json['unloadingCost'],
      remark: json['remark'] ?? '',
      receivedQuantity: json['receivedQuantity'],
      purchaseOrderItem: json['purchaseOrderItem'] != null
          ? PurchaseOrderItemModel.fromJson(json['purchaseOrderItem'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'materialReceiveVoucherId': materialReceiveVoucherId,
      'purchaseOrderItemId': purchaseOrderItemId,
      'loadingCost': loadingCost,
      'transportationCost': transportationCost,
      'unloadingCost': unloadingCost,
      'remark': remark,
      'receivedQuantity': receivedQuantity,
      'purchaseOrderItem': purchaseOrderItem,
    };
  }
}

class CreateMaterialReceiveParamsModel
    extends CreateMaterialReceiveParamsEntity<MaterialReceiveMaterialModel> {
  const CreateMaterialReceiveParamsModel({
    required super.projectId,
    required super.materialReceiveMaterials,
    required super.returnedById,
    required super.receivingStoreId,
  });

  Map<String, dynamic> toJson() {
    return {
      "projectId": projectId,
      "materialReceiveMaterials": materialReceiveMaterials,
      "returnedById": returnedById,
      "receivingStoreId": receivingStoreId,
    };
  }

  @override
  List<Object?> get props => [projectId, materialReceiveMaterials];

  factory CreateMaterialReceiveParamsModel.fromEntity(
      CreateMaterialReceiveParamsEntity entity) {
    return CreateMaterialReceiveParamsModel(
        projectId: entity.projectId,
        returnedById: entity.returnedById,
        receivingStoreId: entity.receivingStoreId,
        materialReceiveMaterials: entity.materialReceiveMaterials
            .map((e) => MaterialReceiveMaterialModel(
                purchaseOrderId: e.purchaseOrderId,
                // material: e.material as ReceiveVoucherMaterialModel,
                transportationCost: e.transportationCost,
                loadingCost: e.loadingCost,
                unloadingCost: e.unloadingCost,
                remark: e.remark))
            .toList());
  }
}

class FilterMaterialReceiveInput {
  final StringFilter? createdAt;
  final StringFilter? approvedBy;
  final StringFilter? preparedBy;
  final StringFilter? serialNumber;
  final List<String>? status;
  final String? projectId;

  FilterMaterialReceiveInput({
    this.createdAt,
    this.approvedBy,
    this.preparedBy,
    this.serialNumber,
    this.status,
    this.projectId,
  });

  Map<String, dynamic> toJson() {
    // include the property if it is only not null
    return {
      if (approvedBy != null)
        'approvedBy': {
          'fullName': approvedBy!.toJson(),
        },
      if (preparedBy != null)
        'preparedBy': {
          'fullName': preparedBy!.toJson(),
        },
      if (serialNumber != null) 'serialNumber': serialNumber!.toJson(),
      if (status != null) 'status': status,
      if (projectId != null) 'projectId': projectId,
    };
  }
}

class OrderByMaterialReceiveInput {
  final String? createdAt;

  OrderByMaterialReceiveInput({required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      if (createdAt != null) "createdAt": createdAt,
    };
  }
}

enum MaterialReceiveStatus { completed, pending, declined }

MaterialReceiveStatus toMaterialReceiveStatus(String value) {
  switch (value) {
    case 'COMPLETED':
      return MaterialReceiveStatus.completed;
    case 'PENDING':
      return MaterialReceiveStatus.pending;
    case 'DECLINED':
      return MaterialReceiveStatus.declined;
    default:
      throw Exception('Invalid MaterialReceiveStatus');
  }
}

String fromMaterialReceiveStatus(MaterialReceiveStatus? value) {
  if (value == null) {
    return '';
  }
  switch (value) {
    case MaterialReceiveStatus.completed:
      return 'COMPLETED';
    case MaterialReceiveStatus.pending:
      return 'PENDING';
    case MaterialReceiveStatus.declined:
      return 'DECLINED';
  }
}
