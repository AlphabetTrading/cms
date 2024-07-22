import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_return/material_return_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';

abstract class MaterialReturnEvent {
  const MaterialReturnEvent();
}

class GetMaterialReturns extends MaterialReturnEvent {
  final FilterMaterialReturnInput? filterMaterialReturnInput;
  final OrderByMaterialReturnInput? orderBy;
  final PaginationInput? paginationInput;
  final bool? mine;

  const GetMaterialReturns({
    this.filterMaterialReturnInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
  });
}

class GetMaterialReturn extends MaterialReturnEvent {
  final String id;
  const GetMaterialReturn(this.id);
}

class CreateMaterialReturn extends MaterialReturnEvent {
  final String id;
  const CreateMaterialReturn(this.id);
}

class UpdateMaterialReturn extends MaterialReturnEvent {
  final String id;
  const UpdateMaterialReturn(this.id);
}

class DeleteMaterialReturn extends MaterialReturnEvent {
  final String id;
  const DeleteMaterialReturn(this.id);
}

class CreateMaterialReturnEvent extends MaterialReturnEvent {
  final CreateMaterialReturnParamsEntity createMaterialReturnParamsEntity;

  const CreateMaterialReturnEvent(
      {required this.createMaterialReturnParamsEntity});
}

class UpdateMaterialReturnEvent extends MaterialReturnEvent {
  final String id;
  const UpdateMaterialReturnEvent(this.id);
}

class DeleteMaterialReturnEvent extends MaterialReturnEvent {
  final String id;
  const DeleteMaterialReturnEvent(this.id);
}
