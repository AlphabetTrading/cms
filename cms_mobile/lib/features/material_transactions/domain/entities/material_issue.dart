import 'package:cms_mobile/core/models/meta.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

class MaterialIssueEntity extends Equatable {
  final String? id;
  final String? serialNumber;
  final String? status;
  final String? approvedById;
  final UserEntity? approvedBy;
  final String? projectDetails;
  final String? requisitionNumber;
  final List<IssueVoucherItem>? items;
  final String? preparedById;
  final UserEntity? preparedBy;
  final String? receivedById;
  final UserEntity? receivedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MaterialIssueEntity({
    this.id,
    this.serialNumber,
    this.projectDetails,
    this.requisitionNumber,
    this.items,
    this.preparedById,
    this.preparedBy,
    this.approvedById,
    this.approvedBy,
    this.status,
    this.receivedBy,
    this.receivedById,
    this.updatedAt,
    this.createdAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}

class IssueVoucherItem extends Equatable {
  final String? id;
  final int? listNo;
  final String? description;
  final String? unitOfMeasure;
  final double? quantity;
  final double? unitCost;
  final double? totalCost;
  final String? remark;
  final String? materialIssueVoucherId;
  final MaterialIssueEntity? materialIssueVoucher;

  const IssueVoucherItem({
    this.id,
    this.listNo,
    this.description,
    this.unitOfMeasure,
    this.quantity,
    this.unitCost,
    this.totalCost,
    this.remark,
    this.materialIssueVoucherId,
    this.materialIssueVoucher,
  });

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}

class MaterialIssueEntityListWithMeta {
  final List<MaterialIssueEntity> items;
  final Meta meta;

  MaterialIssueEntityListWithMeta({
    required this.meta,
    required this.items,
  });
}
