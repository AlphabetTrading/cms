import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:equatable/equatable.dart';

enum PurchaseOrderStatus { pending, approved, declined }

class PurchaseOrderEntity extends Equatable {
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

  const PurchaseOrderEntity({
    this.id,
    this.serialNumber,
    this.date,
    this.purchaseNumber,
    this.projectDetails,
    this.supplierName,
    this.materialRequestId,
    this.materialRequest,
    this.items,
    this.subTotal,
    this.vat,
    this.grandTotal,
    this.preparedById,
    this.preparedBy,
    this.approvedById,
    this.approvedBy,
    this.status,
    this.dateOfReceiving,
    this.dateOfApproval,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}

class PurchaseOrderItem extends Equatable {
  final String? id;
  final int? listNo;
  final String? description;
  final String? unitOfMeasure;
  final String? materialDescription;
  final double? quantityRequested;
  final double? unitPrice;
  final double? totalPrice;
  final String? remark;
  final String? purchaseOrderId;
  // final PurchaseOrder purchaseOrder;

  const PurchaseOrderItem({
    this.id,
    this.purchaseOrderId,
    this.listNo,
    this.description,
    this.unitOfMeasure,
    this.materialDescription,
    this.quantityRequested,
    this.unitPrice,
    this.totalPrice,
    this.remark,
    // this.purchaseOrder,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}
