// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:cms_mobile/features/material_transactions/data/models/product_variant.dart';
// import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
// import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
// import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';
// import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
// import 'package:cms_mobile/features/warehouse/data/models/warehouse.dart';

// import 'package:cms_mobile/core/models/meta.dart';
// import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
// import 'package:cms_mobile/features/products/data/models/product.dart';
// import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';

// class DailySiteDataModel extends DailySiteDataEntity {
//   const DailySiteDataModel({
//     required String super.id,
//     super.approvedById,
//     UserModel? super.approvedBy,
//     super.serialNumber,
//     super.status,
//     super.requisitionNumber,
//     List<IssueVoucherMaterialModel>? super.items,
//     super.preparedById,
//     UserModel? super.preparedBy,
//     super.warehouseStoreId,
//     WarehouseModel? super.warehouseStore,
//     required super.createdAt,
//     required super.updatedAt,
//   });

//   @override
//   List<Object?> get props {
//     return [
//       id,
//     ];
//   }

//   factory DailySiteDataModel.fromJson(Map<String, dynamic> json) {
//     return DailySiteDataModel(
//       id: json['id'],
//       serialNumber: json['serialNumber'],
//       requisitionNumber: json['requisitionNumber'] ?? '',
//       items: json['items'].map<IssueVoucherMaterialModel>((item) {
//         return IssueVoucherMaterialModel.fromJson(item);
//       }).toList(),
//       preparedById: json['preparedById'],
//       preparedBy: json['preparedBy'] != null
//           ? UserModel.fromJson(json['preparedBy'])
//           : null,
//       approvedById: json['approvedById'],
//       approvedBy: json['approvedBy'] != null
//           ? UserModel.fromJson(json['approvedBy'])
//           : null,
//       status: json['status'],
//       warehouseStoreId: json['warehouseStoreId'],
//       warehouseStore: json['warehouseStore'] != null
//           ? WarehouseModel.fromJson(json['warehouseStore'])
//           : null,
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'serialNumber': serialNumber,
//       'status': status,
//       'approvedById': approvedById,
//       'approvedBy': approvedBy,
//       'requisitionNumber': requisitionNumber,
//       'items': items,
//       'preparedById': preparedById,
//       'preparedBy': preparedBy,
//       'warehouseStoreId': warehouseStoreId,
//       'warehouseStore': warehouseStore,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//     };
//   }
// }

// class IssueVoucherMaterialModel extends IssueVoucherMaterialEntity {
//   const IssueVoucherMaterialModel({
//     required String? id,
//     required ProductVariantModel? productVariant,
//     required double? quantity,
//     required String? remark,
//     required double? totalCost,
//     required double? unitCost,
//     required SubStructureUseDescription? subStructureDescription,
//     required SuperStructureUseDescription? superStructureDescription,
//     required UseType? useType,
//     required String? dailySiteDataVoucherId,
//     required DateTime createdAt,
//     required DateTime updatedAt,
//   }) : super(
//           id: id,
//           productVariant: productVariant as ProductVariantEntity,
//           quantity: quantity,
//           remark: remark,
//           totalCost: totalCost,
//           unitCost: unitCost,
//           subStructureDescription: subStructureDescription,
//           superStructureDescription: superStructureDescription,
//           useType: useType,
//           dailySiteDataVoucherId: dailySiteDataVoucherId,
//           createdAt: createdAt,
//           updatedAt: updatedAt,
//         );

//   factory IssueVoucherMaterialModel.fromJson(Map<String, dynamic> json) {
//     return IssueVoucherMaterialModel(
//       id: json['id'],
//       productVariant: ProductVariantModel.fromJson(json['productVariant']),
//       quantity: json['quantity'],
//       remark: json['remark'],
//       totalCost: json['totalCost'],
//       unitCost: json['unitCost'],
//       subStructureDescription:
//           subStructureUseDescriptionFromString(json['subStructureDescription']),
//       superStructureDescription: superStructureUseDescriptionFromString(
//           json['superStructureDescription']),
//       useType: useTypeFromString(json['useType']),
//       dailySiteDataVoucherId: json['dailySiteDataVoucherId'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'productVariant': productVariant,
//       'quantity': quantity,
//       'remark': remark,
//       'totalCost': totalCost,
//       'unitCost': unitCost,
//       'subStructureDescription': subStructureDescription,
//       'superStructureDescription': superStructureDescription,
//       'useType': useType,
//       'dailySiteDataVoucherId': dailySiteDataVoucherId
//     };
//   }
// }

// class DailySiteDataListWithMeta extends DailySiteDataEntityListWithMeta {
//   const DailySiteDataListWithMeta({
//     required Meta meta,
//     required List<DailySiteDataModel> items,
//   }) : super(meta: meta, items: items);

//   factory DailySiteDataListWithMeta.fromJson(Map<String, dynamic> json) {
//     return DailySiteDataListWithMeta(
//       meta: Meta.fromJson(json['meta']),
//       items: json['items']
//           .map<DailySiteDataModel>((item) => DailySiteDataModel.fromJson(item))
//           .toList(),
//     );
//   }
// }

// class DailySiteDataMaterialModel extends DailySiteDataMaterialEntity {
//   const DailySiteDataMaterialModel(
//       {required double quantity,
//       String? remark,
//       WarehouseProductModel? material,
//       required UseType useType,
//       SubStructureUseDescription? subStructureDescription,
//       SuperStructureUseDescription? superStructureDescription})
//       : super(
//             quantity: quantity,
//             material: material,
//             remark: remark,
//             useType: useType,
//             subStructureDescription: subStructureDescription,
//             superStructureDescription: superStructureDescription
//             // unit: unit
//             );

//   Map<String, dynamic> toJson() {
//     return {
//       'quantity': quantity,
//       'remark': remark,
//       "productVariantId": material!.productVariant.id,
//       "useType": useType.name,
//       "unitCost": material!.currentPrice,
//       "totalCost": material!.currentPrice * quantity,
//       "subStructureDescription":
//           subStructureDescription != SubStructureUseDescription.DEFAULT_VALUE
//               ? subStructureDescription!.name
//               : null,
//       "superStructureDescription": superStructureDescription !=
//               SuperStructureUseDescription.DEFAULT_VALUE
//           ? superStructureDescription!.name
//           : null,
//     };
//   }

//   @override
//   List<Object?> get props => [
//         remark,
//         quantity,
//         material,
//         useType,
//         subStructureDescription,
//         superStructureDescription
//       ];
// }

// class CreateDailySiteDataParamsModel
//     extends CreateDailySiteDataParamsEntity<DailySiteDataMaterialModel> {
//   const CreateDailySiteDataParamsModel({
//     required String projectId,
//     required List<DailySiteDataMaterialModel> dailySiteDataMaterials,
//     required String preparedById,
//     required String warehouseStoreId,
//   }) : super(
//             warehouseStoreId: warehouseStoreId,
//             preparedById: preparedById,
//             projectId: projectId,
//             dailySiteDataMaterials: dailySiteDataMaterials);

//   Map<String, dynamic> toJson() {
//     return {
//       "preparedById": preparedById,
//       "projectId": projectId,
//       "warehouseStoreId": warehouseStoreId,
//       "items": dailySiteDataMaterials.map((e) => e.toJson()).toList()
//     };
//   }

//   @override
//   List<Object?> get props => [projectId, preparedById, dailySiteDataMaterials];

//   factory CreateDailySiteDataParamsModel.fromEntity(
//       CreateDailySiteDataParamsEntity entity) {
//     return CreateDailySiteDataParamsModel(
//         projectId: entity.projectId,
//         preparedById: entity.preparedById,
//         warehouseStoreId: entity.warehouseStoreId,
//         dailySiteDataMaterials: entity.dailySiteDataMaterials
//             .map((e) => DailySiteDataMaterialModel(
//                 quantity: e.quantity,
//                 material: e.material as WarehouseProductModel,
//                 remark: e.remark,
//                 useType: e.useType,
//                 subStructureDescription: e.subStructureDescription,
//                 superStructureDescription: e.superStructureDescription))
//             .toList());
//   }
// }

// class EditDailySiteDataParamsModel
//     extends EditDailySiteDataParamsEntity<DailySiteDataMaterialModel> {
//   const EditDailySiteDataParamsModel(
//       {required String approved,
//       required List<DailySiteDataMaterialModel> DailySiteDataMaterials,
//       required String approvedById,
//       required String warehouseStoreId,
//       required String updateDailySiteDataId})
//       : super(
//             approved: approved,
//             warehouseStoreId: warehouseStoreId,
//             approvedById: approvedById,
//             dailySiteDataMaterials:dailySiteDataMaterials,
//             updateDailySiteDataId: updateDailySiteDataId);

//   Map<String, dynamic> toJson() {
//     return {
//       "warehouseStoreId": warehouseStoreId,
//       "approved": approved,
//       "approvedById": approvedById,
//       "items": DailySiteDataMaterials.map((e) => e.toJson()).toList(),
//     };
//   }

//   @override
//   List<Object?> get props => [
//         updateDailySiteDataId,
//         warehouseStoreId,
//         approved,
//         approvedById,
//         dailySiteDataMaterials
//       ];

//   factory EditDailySiteDataParamsModel.fromEntity(
//       EditDailySiteDataParamsEntity entity) {
//     return EditDailySiteDataParamsModel(
//         updateDailySiteDataId: entity.updateDailySiteDataId,
//         approved: entity.approved,
//         warehouseStoreId: entity.warehouseStoreId,
//         approvedById: entity.approvedById,
//         DailySiteDataMaterials: entity.dailySiteDataMaterials
//             .map((e) => DailySiteDataMaterialModel(
//                 quantity: e.quantity,
//                 material: e.material as WarehouseProductModel,
//                 remark: e.remark,
//                 useType: e.useType,
//                 subStructureDescription: e.subStructureDescription,
//                 superStructureDescription: e.superStructureDescription))
//             .toList());
//   }
// }

import 'package:cms_mobile/core/entities/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/data/models/product_variant.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/product_variant.dart';

class DailySiteDataModel extends DailySiteDataEntity {
  const DailySiteDataModel(
      {required super.id,
      super.contractor,
      super.projectId,
      super.status,
      super.date,
      super.tasks,
      super.createdAt,
      super.updatedAt,
      super.approvedBy,
      super.approvedById,
      super.checkedBy,
      super.checkedById,
      super.preparedBy,
      super.preparedById});

  factory DailySiteDataModel.fromJson(Map<String, dynamic> json) {
    return DailySiteDataModel(
      id: json['id'],
      contractor: json['contractor'],
      projectId: json['projectId'],
      status: json['status'],
      date: DateTime.parse(json['date']),
      tasks: json['tasks'] != null
          ? json['tasks']
              .map<SiteTaskEntity>((task) => SiteTaskModel.fromJson(task))
              .toList()
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      approvedBy: json['approvedBy'] != null
          ? UserEntity.fromJson(json['approvedBy'])
          : null,
      approvedById: json['approvedById'],
      checkedBy: json['checkedBy'] != null
          ? UserEntity.fromJson(json['checkedBy'])
          : null,
      checkedById: json['checkedById'],
      preparedBy: json['preparedBy'] != null
          ? UserEntity.fromJson(json['preparedBy'])
          : null,
      preparedById: json['preparedById'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contractor': contractor,
      'projectId': projectId,
      'status': status,
      'date': date,
      'tasks': tasks?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'approvedBy': approvedBy,
      'approvedById': approvedById,
      'checkedBy': checkedBy,
      'checkedById': checkedById,
      'preparedBy': preparedBy,
      'preparedById': preparedById,
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      contractor,
      projectId,
      status,
      date,
      tasks,
      createdAt,
      updatedAt,
      approvedBy,
      approvedById,
      checkedBy,
      checkedById,
      preparedBy,
      preparedById,
    ];
  }
}

class SiteTaskModel extends SiteTaskEntity {
  const SiteTaskModel({
    required super.id,
    super.dailySiteDataId,
    super.description,
    super.executedQuantity,
    super.unit,
    super.laborDetails,
    super.materialDetails,
  });

  factory SiteTaskModel.fromJson(Map<String, dynamic> json) {
    return SiteTaskModel(
      id: json['id'],
      dailySiteDataId: json['dailySiteDataId'],
      description: json['description'],
      executedQuantity: json['executedQuantity'] != null
          ? (json['executedQuantity'] as num).toDouble()
          : 0,
      unit: json['unit'],
      laborDetails: json['laborDetails']
          .map<LaborDetailModel>((labor) => LaborDetailModel.fromJson(labor))
          .toList(),
      materialDetails: json['materialDetails']
          .map<MaterialDetailModel>(
              (material) => MaterialDetailModel.fromJson(material))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dailySiteDataId': dailySiteDataId,
      'description': description,
      'executedQuantity': executedQuantity,
      'unit': unit,
      'laborDetails': laborDetails?.map((e) => e.toJson()).toList(),
      'materialDetails': materialDetails?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      dailySiteDataId,
      description,
      executedQuantity,
      unit,
      laborDetails,
      materialDetails
    ];
  }
}

class LaborDetailModel extends LaborDetailEntity {
  const LaborDetailModel({
    required super.id,
    super.afternoon,
    super.quantity,
    super.morning,
    super.overtime,
    super.trade,
    super.dailySiteDataTaskId,
    super.createdAt,
    super.updatedAt,
  });

  factory LaborDetailModel.fromJson(Map<String, dynamic> json) {
    print("LaborDetailModel.fromJson: $json");
    return LaborDetailModel(
      id: json['id'],
      quantity:
          json['quantity'] != null ? (json['quantity'] as num).toDouble() : 0,
      trade: json['trade'],
      morning:
          json['morning'] != null ? (json['morning'] as num).toDouble() : 0,
      afternoon:
          json['afternoon'] != null ? (json['afternoon'] as num).toDouble() : 0,
      overtime:
          json['overtime'] != null ? (json['overtime'] as num).toDouble() : 0,
      dailySiteDataTaskId: json['dailySiteDataTaskId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'trade': trade,
      'morning': morning,
      'afternoon': afternoon,
      'overtime': overtime,
      'dailySiteDataTaskId': dailySiteDataTaskId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      quantity,
      trade,
      morning,
      afternoon,
      overtime,
      dailySiteDataTaskId,
      createdAt,
      updatedAt,
    ];
  }
}

class MaterialDetailModel extends MaterialDetailEntity {
  const MaterialDetailModel({
    required super.id,
    super.dailySiteDataTaskId,
    super.productVariantId,
    super.productVariant,
    super.quantityUsed,
    super.quantityWasted,
    super.createdAt,
    super.updatedAt,
  });

  factory MaterialDetailModel.fromJson(Map<String, dynamic> json) {
    return MaterialDetailModel(
      id: json['id'],
      dailySiteDataTaskId: json['dailySiteDataTaskId'],
      productVariantId: json['productVariantId'],
      productVariant: json['productVariant'] != null
          ? ProductVariantModel.fromJson(json['productVariant'])
          : null,
      quantityUsed: json['quantityUsed'] != null
          ? (json['quantityUsed'] as num).toDouble()
          : 0,
      quantityWasted: json['quantityWasted'] != null
          ? (json['quantityWasted'] as num).toDouble()
          : 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dailySiteDataTaskId': dailySiteDataTaskId,
      'productVariantId': productVariantId,
      'productVariant': productVariant,
      'quantityUsed': quantityUsed,
      'quantityWasted': quantityWasted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      dailySiteDataTaskId,
      productVariantId,
      productVariant,
      quantityUsed,
      quantityWasted,
      createdAt,
      updatedAt,
    ];
  }
}

enum DailySiteDataStatus { completed, pending, declined }

DailySiteDataStatus toDailySiteDataStatus(String value) {
  switch (value) {
    case 'COMPLETED':
      return DailySiteDataStatus.completed;
    case 'PENDING':
      return DailySiteDataStatus.pending;
    case 'DECLINED':
      return DailySiteDataStatus.declined;
    default:
      throw Exception('Invalid DailySiteDataStatus');
  }
}

String fromDailySiteDataStatus(DailySiteDataStatus? value) {
  if (value == null) {
    return '';
  }
  switch (value) {
    case DailySiteDataStatus.completed:
      return 'COMPLETED';
    case DailySiteDataStatus.pending:
      return 'PENDING';
    case DailySiteDataStatus.declined:
      return 'DECLINED';
  }
}

class CreateDailySiteDataParamsModel extends CreateDailySiteDataParamsEntity {
  const CreateDailySiteDataParamsModel({
    required super.projectId,
    required super.tasks,
    required super.preparedById,
  });

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'preparedById': preparedById,
      'tasks': tasks.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props {
    return [projectId, preparedById, tasks];
  }

  factory CreateDailySiteDataParamsModel.fromEntity(
      CreateDailySiteDataParamsEntity entity) {
    return CreateDailySiteDataParamsModel(
      projectId: entity.projectId,
      preparedById: entity.preparedById,
      tasks: entity.tasks
          .map((e) => SiteTaskModel(
                id: e.id,
                dailySiteDataId: e.dailySiteDataId,
                description: e.description,
                executedQuantity: e.executedQuantity,
                unit: e.unit,
                laborDetails: e.laborDetails
                    ?.map((e) => LaborDetailModel(
                          id: e.id,
                          quantity: e.quantity,
                          trade: e.trade,
                          morning: e.morning,
                          afternoon: e.afternoon,
                          overtime: e.overtime,
                          dailySiteDataTaskId: e.dailySiteDataTaskId,
                          createdAt: e.createdAt,
                          updatedAt: e.updatedAt,
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
}

class EditDailySiteDataParamsModel extends EditDailySiteDataParamsEntity {
  const EditDailySiteDataParamsModel({
    required super.approved,
    required super.tasks,
    required super.approvedById,
    required super.updateDailySiteDataId,
  });

  Map<String, dynamic> toJson() {
    return {
      'approved': approved,
      'approvedById': approvedById,
      'tasks': tasks.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props {
    return [approved, approvedById, tasks];
  }

  factory EditDailySiteDataParamsModel.fromEntity(
      EditDailySiteDataParamsEntity entity) {
    return EditDailySiteDataParamsModel(
      approved: entity.approved,
      approvedById: entity.approvedById,
      tasks: entity.tasks
          .map((e) => SiteTaskModel(
                id: e.id,
                dailySiteDataId: e.dailySiteDataId,
                description: e.description,
                executedQuantity: e.executedQuantity,
                unit: e.unit,
                laborDetails: e.laborDetails
                    ?.map((e) => LaborDetailModel(
                          id: e.id,
                          quantity: e.quantity,
                          trade: e.trade,
                          morning: e.morning,
                          afternoon: e.afternoon,
                          overtime: e.overtime,
                          dailySiteDataTaskId: e.dailySiteDataTaskId,
                          createdAt: e.createdAt,
                          updatedAt: e.updatedAt,
                        ))
                    .toList(),
              ))
          .toList(),
      updateDailySiteDataId: entity.updateDailySiteDataId,
    );
  }
}

class DailySiteDataListWithMeta extends DailySiteDataEntityListWithMeta {
  const DailySiteDataListWithMeta({
    required super.meta,
    required super.items,
  }) : super();

  factory DailySiteDataListWithMeta.fromJson(Map<String, dynamic> json) {
    return DailySiteDataListWithMeta(
      meta: MetaEntity.fromJson(json['meta']),
      items: json['items']
          .map<DailySiteDataModel>((item) => DailySiteDataModel.fromJson(item))
          .toList(),
    );
  }
}
