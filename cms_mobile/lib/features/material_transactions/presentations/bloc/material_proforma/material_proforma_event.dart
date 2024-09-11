import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_proformas/material_proforma_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';

abstract class MaterialProformaEvent {
  const MaterialProformaEvent();
}

class GetMaterialProformas extends MaterialProformaEvent {
  final FilterMaterialProformaInput? filterMaterialProformaInput;
  final OrderByMaterialProformaInput? orderBy;
  final PaginationInput? paginationInput;
  final bool? mine;
  const GetMaterialProformas({
    this.filterMaterialProformaInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
  });
}

class GetAllMaterialProformas extends MaterialProformaEvent {
  final String projectId;
  const GetAllMaterialProformas(this.projectId);
}

class GetMaterialProforma extends MaterialProformaEvent {
  final FilterMaterialProformaInput filterMaterialProformaInput;
  final OrderByMaterialProformaInput orderBy;
  final PaginationInput paginationInput;
  const GetMaterialProforma(
    this.filterMaterialProformaInput,
    this.orderBy,
    this.paginationInput,
  );
}

class GetMaterialProformaDetailsEvent extends MaterialProformaEvent {
  final String materialProformaId;
  const GetMaterialProformaDetailsEvent({required this.materialProformaId});
}

class UpdateMaterialProforma extends MaterialProformaEvent {
  final String id;
  const UpdateMaterialProforma(this.id);
}

class DeleteMaterialProforma extends MaterialProformaEvent {
  final String id;
  const DeleteMaterialProforma(this.id);
}

class CreateMaterialProformaEvent extends MaterialProformaEvent {
  final CreateMaterialProformaParamsEntity createMaterialProformaParamsEntity;

  const CreateMaterialProformaEvent(
      {required this.createMaterialProformaParamsEntity});
}

class UpdateMaterialProformaEvent extends MaterialProformaEvent {
  final String id;
  const UpdateMaterialProformaEvent(this.id);
}

class DeleteMaterialProformaEventLocal extends MaterialProformaEvent {
  final String materialProformaId;
  final bool isMine;
  const DeleteMaterialProformaEventLocal({
    required this.materialProformaId,
    required this.isMine,
  });
}
