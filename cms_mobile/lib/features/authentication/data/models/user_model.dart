import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.phoneNumber,
    required super.fullName,
    required super.role,
    required super.createdAt,
    required super.updatedAt,
    super.purchaseOrders,
    super.purchaseOrdersApproved,
    super.materialIssueVouchers,
    super.materialIssueVouchersApproved,
    super.materialReceiveVouchers,
    super.materialReceiveVouchersApproved,
    super.materialRequestVouchers,
    super.materialRequestVouchersApproved,
    super.materialReturnVouchers,
    super.materialReturnVouchersReceived,
    super.materialReturnVouchersApproved,
    super.materialReturnVouchersReturned,
    super.projects,
    super.tasks,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: getRole(json['role']),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
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
    //   }
    //   catch(e){
    //     print('********** Error in UserModel.fromJson: $e');
    //   }
    //  return UserModel(
    //     id: json['id'],
    //     fullName: json['fullName'],
    //     email: json['email'],
    //     phoneNumber: json['phoneNumber'],
    //     role: getRole(json['role']),
    //     createdAt: DateTime.parse(json['createdAt']),
    //     updatedAt: DateTime.parse(json['updatedAt']),
    //     purchaseOrders: json['purchaseOrders'],
    //     purchaseOrdersApproved: json['purchaseOrdersApproved'],
    //     materialIssueVouchers: json['materialIssueVouchers'],
    //     materialIssueVouchersApproved: json['materialIssueVouchersApproved'],
    //     materialReceiveVouchers: json['materialReceiveVouchers'],
    //     materialReceiveVouchersApproved: json['materialReceiveVouchersApproved'],
    //     materialRequestVouchers: json['materialRequestVouchers'],
    //     materialRequestVouchersApproved: json['materialRequestVouchersApproved'],
    //     materialReturnVouchers: json['materialReturnVouchers'],
    //     materialReturnVouchersReceived: json['materialReturnVouchersReceived'],
    //     materialReturnVouchersApproved: json['materialReturnVouchersApproved'],
    //     materialReturnVouchersReturned: json['materialReturnVouchersReturned'],
    //     projects: json['projects'],
    //     tasks: json['tasks'],
    //   );;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, email: $email, phoneNumber: $phoneNumber)';
  }

  // match user role to enum, get function that take a string and return a UserRole
  static UserRole getRole(String role) {
    switch (role) {
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
}


/***
 * 
 * import 'package:cms_mobile/features/home/domain/entities/projects.dart';
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

 */