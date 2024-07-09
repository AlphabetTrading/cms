import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:equatable/equatable.dart';

class DailySiteDataLocalState extends Equatable {
  final List<DailySiteDataEnitity>? dailySiteDataMaterials;

  const DailySiteDataLocalState({this.dailySiteDataMaterials});

  @override
  List<Object?> get props => [dailySiteDataMaterials];
}
