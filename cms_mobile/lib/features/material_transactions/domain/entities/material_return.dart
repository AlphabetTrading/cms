import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:equatable/equatable.dart';

enum MaterialReturnStatus { pending, approved, declined }

class MaterialReturnEntity extends Equatable {
  final String? id;
  final String? serialNumber;
  final DateTime? date;
  final String? from;
  final String? receivingStore;
  final MaterialReturnItem? items;
  final String? returnedById;
  final UserEntity? returnedBy;
  final String? receivedById;
  final UserEntity? receivedBy;
  final MaterialReturnStatus? status;

  const MaterialReturnEntity({
    this.id,
    this.serialNumber,
    this.date,
    this.from,
    this.receivingStore,
    this.items,
    this.returnedById,
    this.returnedBy,
    this.receivedById,
    this.receivedBy,
    this.status,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}

class MaterialReturnItem extends Equatable {
  final String? id;
  final int? listNo;
  final String? description;
  final String? issueVoucherId;
  final MaterialIssueEntity? issueVoucher;
  final double? unitOfMeasure;
  final double? quantityReturned;
  final double? unitCose;
  final double? totalCost;
  final String? remark;
  final String? materialReturnVoucherId;
  final MaterialReturnEntity? materialReturnVoucher;

  const MaterialReturnItem({
    this.id,
    this.listNo,
    this.description,
    this.issueVoucherId,
    this.issueVoucher,
    this.unitOfMeasure,
    this.quantityReturned,
    this.unitCose,
    this.totalCost,
    this.remark,
    this.materialReturnVoucherId,
    this.materialReturnVoucher,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}
