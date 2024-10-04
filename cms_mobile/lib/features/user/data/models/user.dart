import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.phoneNumber,
    required super.email,
    required super.role,
    super.company,
    required super.createdAt,
    required super.updatedAt,
  });

  @override
  List<Object?> get props {
    return [id];
  }

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    return UserModel(
      id: json?['id'],
      fullName: json?['fullName'],
      email: json?['email'],
      phoneNumber: json?['phoneNumber'],
      role: json?['role'],
      company: json?['company'],
      createdAt: json?['createdAt'] != null
          ? DateTime.parse(json?['createdAt'])
          : null,
      updatedAt: json?['updatedAt'] != null
          ? DateTime.parse(json?['updatedAt'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'company': company,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class CompanyModel extends CompanyEntity {
  const CompanyModel({
    required super.id,
    super.name,
    super.address,
    super.contactInfo,
    required super.createdAt,
    required super.updatedAt,
    super.ownerId,
    super.owner,
    super.employees,
    super.projects,
    super.warehouseStores,
  });

  @override
  List<Object?> get props {
    return [id];
  }

  factory CompanyModel.fromJson(Map<String, dynamic>? json) {
    return CompanyModel(
      id: json?['id'],
      name: json?['name'],
      address: json?['address'],
      contactInfo: json?['contactInfo'],
      ownerId: json?['ownerId'],
      owner: json?['owner'],
      employees: json?['employees'],
      projects: json?['projects'],
      warehouseStores: json?['warehouseStores'],
      createdAt: json?['createdAt'],
      updatedAt: json?['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'contactInfo': contactInfo,
      'ownerId': ownerId,
      'owner': owner,
      'employees': employees,
      'projects': projects,
      'warehouseStores': warehouseStores,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}