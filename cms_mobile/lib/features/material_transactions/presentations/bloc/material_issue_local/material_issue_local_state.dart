

import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:equatable/equatable.dart';

class MaterialIssueLocalState extends Equatable{
  final List<MaterialIssueMaterialEntity> ? materialIssueMaterials;


  const MaterialIssueLocalState({this.materialIssueMaterials});

  @override
  List<Object?> get props => [materialIssueMaterials];
}

