import 'package:cms_mobile/features/materials/domain/entities/material.dart';
import 'package:flutter/material.dart';

class MaterialModel extends MaterialEntity {
  const MaterialModel({
    required String id,
    required String name,
    required double quantity,
  }) : super(
          id: id,
          name: name,
          quantity: quantity,
        );

  @override
  List<Object?> get props {
    return [
      id,
      name,
      quantity,
    ];
  }

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
    };
  }
}
