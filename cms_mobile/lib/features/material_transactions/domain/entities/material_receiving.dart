import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart.dart';
import 'package:equatable/equatable.dart';

class MaterialReceivingEntity extends Equatable {
  final String? id;
  final String? serialNumber;
  final DateTime? date;
  final String? projectDetails;
  final String? supplierName;
  final String? invoiceId;
  final String? materialRequestId;
  final MaterialRequestEntity? materialRequest;
  final String? purchaseOrderId;
  final PurchaseOrderEntity? purchaseOrder;
  final List<MaterialReceiveItem>? items;

  const MaterialReceivingEntity({
    this.id,
    this.serialNumber,
    this.date,
    this.projectDetails,
    this.supplierName,
    this.invoiceId,
    this.materialRequestId,
    this.materialRequest,
    this.purchaseOrderId,
    this.purchaseOrder,
    this.items,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}

class MaterialReceiveItem extends Equatable {
  final String? id;
  final int? listNo;
  final String? description;
  final String? unitOfMeasure;
  final double? quantityReceived;
  final double? unitCost;
  final double? totalCost;
  final String? remark;
  final String? materialReceiveVoucherId;
  final MaterialReceivingEntity? materialReceiveVoucher;

  const MaterialReceiveItem({
    this.id,
    this.listNo,
    this.description,
    this.unitOfMeasure,
    this.quantityReceived,
    this.unitCost,
    this.totalCost,
    this.remark,
    this.materialReceiveVoucherId,
    this.materialReceiveVoucher,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}
