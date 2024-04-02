import 'package:cms_mobile/features/authentication/data/models/user_model.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart.dart';

class PurchaseOrderModel extends PurchaseOrderEntity {
  const PurchaseOrderModel({
    required String id,
    required String serialNumber,
    required DateTime date,
    required String? projectDetails,
    required String supplierName,
    required String materialRequestId,
    required MaterialRequestModel? materialRequest,
    required List<PurchaseOrderItemModel>? items,
    required double subTotal,
    required double vat,
    required double grandTotal,
    required String preparedById,
    required UserModel preparedBy,
    required String approvedById,
    required UserModel approvedBy,
    required PurchaseOrderStatus status,
    required DateTime dateOfReceiving,
    required DateTime dateOfApproval,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          serialNumber: serialNumber,
          date: date,
          projectDetails: projectDetails,
          supplierName: supplierName,
          materialRequestId: materialRequestId,
          materialRequest: materialRequest,
          items: items,
          subTotal: subTotal,
          vat: vat,
          grandTotal: grandTotal,
          preparedById: preparedById,
          preparedBy: preparedBy,
          approvedById: approvedById,
          approvedBy: approvedBy,
          status: status,
          dateOfReceiving: dateOfReceiving,
          dateOfApproval: dateOfApproval,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderModel(
      id: json['id'],
      serialNumber: json['serialNumber'],
      date: DateTime.parse(json['date']),
      projectDetails: json['projectDetails'],
      supplierName: json['supplierName'],
      materialRequestId: json['materialRequestId'],
      materialRequest: MaterialRequestModel.fromJson(json['materialRequest']),
      items: json['items']
          .map<PurchaseOrderItem>(
              (item) => PurchaseOrderItemModel.fromJson(item))
          .toList(),
      subTotal: json['subTotal'],
      vat: json['vat'],
      grandTotal: json['grandTotal'],
      preparedById: json['preparedById'],
      preparedBy: UserModel.fromJson(json['preparedBy']),
      approvedById: json['approvedById'],
      approvedBy: UserModel.fromJson(json['approvedBy']),
      status: json['status'],
      dateOfReceiving: DateTime.parse(json['dateOfReceiving']),
      dateOfApproval: DateTime.parse(json['dateOfApproval']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class PurchaseOrderItemModel extends PurchaseOrderItem {
  const PurchaseOrderItemModel(
      {required String id,
      required int listNo,
      required String description,
      required String unitOfMeasure,
      required double quantityRequested,
      required double unitCost,
      required String remark,
      required String materialDescription,
      required String purchaseOrderId,
      required double totalCost})
      : super(
          id: id,
          listNo: listNo,
          description: description,
          unitOfMeasure: unitOfMeasure,
          remark: remark,
          materialDescription: materialDescription,
          purchaseOrderId: purchaseOrderId,
          quantityRequested: quantityRequested,
          unitPrice: unitCost,
          totalPrice: totalCost,
        );

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }

  factory PurchaseOrderItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderItemModel(
        id: json['id'],
        listNo: json['listNo'],
        description: json['description'],
        unitOfMeasure: json['unitOfMeasure'],
        quantityRequested: json['quantityRequested'],
        unitCost: json['unitCost'],
        remark: json['remark'],
        materialDescription: json['materialDescription'],
        purchaseOrderId: json['purchaseOrderId'],
        totalCost: json['totalCost']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listNo': listNo,
      'description': description,
      'unitOfMeasure': unitOfMeasure,
      'quantityRequested': quantityRequested,
      'unitCost': unitPrice,
      'remark': remark,
      'materialDescription': materialDescription,
      'purchaseOrderId': purchaseOrderId,
      'totalCost': totalPrice
    };
  }
}


/**
 * 
 * 
 final String? id;
  final String? serialNumber;
  final DateTime? date;
  final String? purchaseNumber;
  final String? projectDetails;
  final String? supplierName;
  final String? materialRequestId;
  final MaterialRequestEntity? materialRequest;
  final List<PurchaseOrderItem>? items;
  final double? subTotal;
  final double? vat;
  final double? grandTotal;
  final String? preparedById;
  final UserEntity? preparedBy;
  final String? approvedById;
  final UserEntity? approvedBy;
  final PurchaseOrderStatus? status;
  final DateTime? dateOfReceiving;
  final DateTime? dateOfApproval;
  final DateTime? createdAt;
  final DateTime? updatedAt;
 */