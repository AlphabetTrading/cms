import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:equatable/equatable.dart';

class WarehouseLocalState extends Equatable {
  final List<WarehouseEntity>? warehouses;

  const WarehouseLocalState({this.warehouses});

  @override
  List<Object?> get props => [warehouses];
}
