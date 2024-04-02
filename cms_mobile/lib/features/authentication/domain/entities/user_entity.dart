import 'package:cms_mobile/features/home/domain/entities/project.dart';
import 'package:cms_mobile/features/home/domain/entities/task.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart.dart';
import 'package:equatable/equatable.dart';

enum UserRole {
  CLIENT,
  PROJECT_MANAGER,
  CONSULTANT,
  SITE_MANAGER,
  PURCHASE,
  STORE_MANAGER,
}

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final UserRole role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PurchaseOrderEntity>? purchaseOrders;
  final List<PurchaseOrderEntity>? purchaseOrdersApproved;
  final List<MaterialIssueEntity>? materialIssueVouchers;
  final List<MaterialIssueEntity>? materialIssueVouchersApproved;
  final List<MaterialReceivingEntity>? materialReceiveVouchers;
  final List<MaterialReceivingEntity>? materialReceiveVouchersApproved;

  final List<MaterialRequestEntity>? materialRequestVouchers;
  final List<MaterialRequestEntity>? materialRequestVouchersApproved;

  final List<MaterialReturnEntity>? materialReturnVouchers;
  final List<MaterialReturnEntity>? materialReturnVouchersReceived;

  final List<MaterialReturnEntity>? materialReturnVouchersApproved;
  final List<MaterialReturnEntity>? materialReturnVouchersReturned;

  final List<ProjectEntity>? projects;
  final List<TaskEntity>? tasks;

  const UserEntity({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.role,
    this.createdAt,
    this.updatedAt,
    this.purchaseOrders,
    this.purchaseOrdersApproved,
    this.materialIssueVouchers,
    this.materialIssueVouchersApproved,
    this.materialReceiveVouchers,
    this.materialReceiveVouchersApproved,
    this.materialRequestVouchers,
    this.materialRequestVouchersApproved,
    this.materialReturnVouchers,
    this.materialReturnVouchersReceived,
    this.materialReturnVouchersApproved,
    this.materialReturnVouchersReturned,
    this.projects,
    this.tasks,
  });

  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool get stringify => true;
}
