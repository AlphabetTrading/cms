import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/material_transactions/data/models/product_variant.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:cms_mobile/features/warehouse/data/models/warehouse.dart';

// ignore: must_be_immutable
class MaterialTransferItemModel extends MaterialTransferItemEntity {
  MaterialTransferItemModel(
      {String? id,
      String? materialTransferVoucherId,
      ProductVariantModel? productVariant,
      String? productVariantId,
      int? quantityRequested,
      int? quantityTransferred,
      String? remark,
      int? totalCost,
      int? unitCost,
      required DateTime createdAt,
      required DateTime updatedAt})
      : super(
            id: id,
            materialTransferVoucherId: materialTransferVoucherId,
            productVariant: productVariant,
            productVariantId: productVariantId,
            quantityRequested: quantityRequested,
            quantityTransferred: quantityTransferred,
            remark: remark,
            totalCost: totalCost,
            unitCost: unitCost,
            createdAt: createdAt,
            updatedAt: updatedAt);

  factory MaterialTransferItemModel.fromJson(Map<String, dynamic> json) {
    return MaterialTransferItemModel(
      id: json['id'],
      materialTransferVoucherId: json['materialTransferVoucherId'],
      productVariantId: json['productVariantId'],
      productVariant: json['productVariant'] != null
          ? ProductVariantModel.fromJson(json['productVariant'])
          : null,
      quantityRequested: json['quantityRequested'],
      quantityTransferred: json['quantityTransferred'],
      remark: json['remark'],
      totalCost: json['totalCost'],
      unitCost: json['unitCost'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'materialTransferVoucherId': materialTransferVoucherId,
      'productVariant': productVariant!.toJson(),
      'productVariantId': productVariantId,
      'quantityRequested': quantityRequested,
      'quantityTransferred': quantityTransferred,
      'remark': remark,
      'totalCost': totalCost,
      'unitCost': unitCost,
      'updatedAt': updatedAt
    };
  }
}

// ignore: must_be_immutable
class MaterialTransferModel extends MaterialTransferEntity {
  MaterialTransferModel({
    String? id,
    UserModel? approvedBy,
    String? approvedById,
    List<MaterialTransferItemModel>? items,
    String? materialGroup,
    String? materialReceiveId,
    UserModel? preparedBy,
    String? preparedById,
    String? projectId,
    WarehouseModel? sendingWarehouseStore,
    String? sendingWarehouseStoreId,
    WarehouseModel? receivingWarehouseStore,
    String? receivingWarehouseStoreId,
    String? requisitionNumber,
    String? sendingStore,
    String? sentThroughName,
    String? serialNumber,
    String? status,
    String? vehiclePlateNo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
            id: id,
            approvedBy: approvedBy,
            approvedById: approvedById,
            createdAt: createdAt,
            items: items,
            materialGroup: materialGroup,
            materialReceiveId: materialReceiveId,
            preparedBy: preparedBy,
            preparedById: preparedById,
            projectId: projectId,
            receivingWarehouseStore: receivingWarehouseStore,
            receivingWarehouseStoreId: receivingWarehouseStoreId,
            sendingWarehouseStore: sendingWarehouseStore,
            sendingWarehouseStoreId: sendingWarehouseStoreId,
            requisitionNumber: requisitionNumber,
            sendingStore: sendingStore,
            sentThroughName: sentThroughName,
            serialNumber: serialNumber,
            status: status,
            updatedAt: updatedAt,
            vehiclePlateNo: vehiclePlateNo);

  factory MaterialTransferModel.fromJson(Map<String, dynamic> json) {
    return MaterialTransferModel(
      approvedBy: json['approvedBy'] != null
          ? UserModel.fromJson(json['approvedBy'])
          : null,
      approvedById: json['approvedById'],
      id: json['id'],
      items: json['items']
          ?.map<MaterialTransferItemModel>(
              (item) => MaterialTransferItemModel.fromJson(item))
          .toList(),
      materialGroup: json['materialGroup'],
      materialReceiveId: json['materialReceiveId'],
      preparedBy: json['preparedBy'] != null
          ? UserModel.fromJson(json['preparedBy'])
          : null,
      preparedById: json['preparedById'],
      projectId: json['projectId'],
      sendingWarehouseStoreId: json['sendingWarehouseStoreId'],
      sendingWarehouseStore: json['sendingWarehouseStore'] != null
          ? WarehouseModel.fromJson(json['sendingWarehouseStore'])
          : null,
      receivingWarehouseStoreId: json['receivingWarehouseStoreId'],
      receivingWarehouseStore: json['receivingWarehouseStore'] != null
          ? WarehouseModel.fromJson(json['receivingStore'])
          : null,
      requisitionNumber: json['requisitionNumber'],
      sendingStore: json['sendingStore'],
      sentThroughName: json['sentThroughName'],
      serialNumber: json['serialNumber'],
      status: json['status'],
      vehiclePlateNo: json['vehiclePlateNo'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'approvedBy': approvedBy!.toJson(),
      'approvedById': approvedById,
      'createdAt': createdAt,
      'items': items!.map((v) => v.toJson()).toList(),
      'materialGroup': materialGroup,
      'materialReceiveId': materialReceiveId,
      'preparedBy': preparedBy!.toJson(),
      'preparedById': preparedById,
      'projectId': projectId,
      'sendingWarehouseStore': sendingWarehouseStore!.toJson(),
      'sendingWarehouseStoreId': sendingWarehouseStoreId,
      'receivingWarehouseStore': receivingWarehouseStore!.toJson(),
      'receivingWarehouseStoreId': receivingWarehouseStoreId,
      'requisitionNumber': requisitionNumber,
      'sendingStore': sendingStore,
      'sentThroughName': sentThroughName,
      'serialNumber': serialNumber,
      'status': status,
      'updatedAt': updatedAt,
      'vehiclePlateNo': vehiclePlateNo
    };
    return data;
  }
}

enum MaterialTransferStatus { completed, pending, declined }

MaterialTransferStatus toMaterialTransferStatus(String value) {
  switch (value) {
    case 'COMPLETED':
      return MaterialTransferStatus.completed;
    case 'PENDING':
      return MaterialTransferStatus.pending;
    case 'DECLINED':
      return MaterialTransferStatus.declined;
    default:
      throw Exception('Invalid MaterialTransferStatus');
  }
}

String fromMaterialTransferStatus(MaterialTransferStatus? value) {
  if (value == null) {
    return '';
  }
  switch (value) {
    case MaterialTransferStatus.completed:
      return 'COMPLETED';
    case MaterialTransferStatus.pending:
      return 'PENDING';
    case MaterialTransferStatus.declined:
      return 'DECLINED';
  }
}
