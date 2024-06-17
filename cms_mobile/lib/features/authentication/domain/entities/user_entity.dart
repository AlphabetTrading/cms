import 'package:cms_mobile/features/home/domain/entities/project.dart';
import 'package:cms_mobile/features/home/domain/entities/task.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
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
  final List<MaterialReceiveEntity>? materialReceiveVouchers;
  final List<MaterialReceiveEntity>? materialReceiveVouchersApproved;

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

  // fromJSON, and toJSON methods

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      fullName: json['fullName'],
      role: json['role'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      purchaseOrders: json['purchaseOrders'],
      purchaseOrdersApproved: json['purchaseOrdersApproved'],
      materialIssueVouchers: json['materialIssueVouchers'],
      materialIssueVouchersApproved: json['materialIssueVouchersApproved'],
      materialReceiveVouchers: json['materialReceiveVouchers'],
      materialReceiveVouchersApproved: json['materialReceiveVouchersApproved'],
      materialRequestVouchers: json['materialRequestVouchers'],
      materialRequestVouchersApproved: json['materialRequestVouchersApproved'],
      materialReturnVouchers: json['materialReturnVouchers'],
      materialReturnVouchersReceived: json['materialReturnVouchersReceived'],
      materialReturnVouchersApproved: json['materialReturnVouchersApproved'],
      materialReturnVouchersReturned: json['materialReturnVouchersReturned'],
      projects: json['projects'],
      tasks: json['tasks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'purchaseOrders': purchaseOrders,
      'purchaseOrdersApproved': purchaseOrdersApproved,
      'materialIssueVouchers': materialIssueVouchers,
      'materialIssueVouchersApproved': materialIssueVouchersApproved,
      'materialReceiveVouchers': materialReceiveVouchers,
      'materialReceiveVouchersApproved': materialReceiveVouchersApproved,
      'materialRequestVouchers': materialRequestVouchers,
      'materialRequestVouchersApproved': materialRequestVouchersApproved,
      'materialReturnVouchers': materialReturnVouchers,
      'materialReturnVouchersReceived': materialReturnVouchersReceived,
      'materialReturnVouchersApproved': materialReturnVouchersApproved,
      'materialReturnVouchersReturned': materialReturnVouchersReturned,
      'projects': projects,
      'tasks': tasks,
    };
  }
}
