import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/projects/domain/entities/project.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:equatable/equatable.dart';

enum UserRole {
  ADMIN,
  CLIENT,
  PROJECT_MANAGER,
  CONSULTANT,
  SITE_MANAGER,
  PURCHASE,
  STORE_MANAGER,
  OWNER
}

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final UserRole role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CompanyEntity? company;
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
    this.company,
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
  List<Object?> get props => [
        id,
        email,
        phoneNumber,
        fullName,
        role,
        company,
        createdAt,
        updatedAt,
        purchaseOrders,
        purchaseOrdersApproved,
        materialIssueVouchers,
        materialIssueVouchersApproved,
        materialReceiveVouchers,
        materialReceiveVouchersApproved,
        materialRequestVouchers,
        materialRequestVouchersApproved,
        materialReturnVouchers,
        materialReturnVouchersReceived,
        materialReturnVouchersApproved,
        materialReturnVouchersReturned,
        projects,
        tasks,
      ];

  @override
  bool get stringify => true;

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    print("UserEntity.fromJson ${json}");

    return UserEntity(
      id: json['id'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      fullName: json['fullName'],
      role: userRoleFromJson(json['role']),
      company: json['company'],
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
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'company': company,
      'role': userRoleToJson(role),
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

class CompanyEntity extends Equatable {
  final String? id;
  final String? name;
  final String? address;
  final String? contactInfo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? ownerId;
  final UserEntity? owner;
  final List<UserEntity>? employees;
  final List<ProjectEntity>? projects;
  final List<WarehouseEntity>? warehouseStores;

  const CompanyEntity({
    required this.id,
    this.name,
    this.address,
    this.contactInfo,
    this.ownerId,
    this.owner,
    this.employees,
    this.projects,
    this.warehouseStores,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
      address,
      contactInfo,
      ownerId,
      owner,
      employees,
      projects,
      warehouseStores,
      createdAt,
      updatedAt,
    ];
  }
}

UserRole userRoleFromJson(String role) {
  switch (role) {
    case 'ADMIN':
      return UserRole.ADMIN;
    case 'OWNER':
      return UserRole.OWNER;
    case 'CLIENT':
      return UserRole.CLIENT;
    case 'PROJECT_MANAGER':
      return UserRole.PROJECT_MANAGER;
    case 'CONSULTANT':
      return UserRole.CONSULTANT;
    case 'SITE_MANAGER':
      return UserRole.SITE_MANAGER;
    case 'PURCHASE':
      return UserRole.PURCHASE;
    case 'STORE_MANAGER':
      return UserRole.STORE_MANAGER;
    default:
      return UserRole.CLIENT;
  }
}

String userRoleToJson(UserRole role) {
  switch (role) {
    case UserRole.ADMIN:
      return 'ADMIN';
    case UserRole.OWNER:
      return 'OWNER';
    case UserRole.CLIENT:
      return 'CLIENT';
    case UserRole.PROJECT_MANAGER:
      return 'PROJECT_MANAGER';
    case UserRole.CONSULTANT:
      return 'CONSULTANT';
    case UserRole.SITE_MANAGER:
      return 'SITE_MANAGER';
    case UserRole.PURCHASE:
      return 'PURCHASE';
    case UserRole.STORE_MANAGER:
      return 'STORE_MANAGER';
    default:
      return 'CLIENT';
  }
}
