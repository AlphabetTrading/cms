import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';

abstract class MaterialReceiveEvent {
  const MaterialReceiveEvent();
}

class GetMaterialReceives extends MaterialReceiveEvent {
  final FilterMaterialReceiveInput? filterMaterialReceiveInput;
  final OrderByMaterialReceiveInput? orderBy;
  final PaginationInput? paginationInput;
  const GetMaterialReceives({
    this.filterMaterialReceiveInput,
    this.orderBy,
    this.paginationInput,
  });
}

class GetMaterialReceive extends MaterialReceiveEvent {
  final FilterMaterialReceiveInput filterMaterialReceiveInput;
  final OrderByMaterialReceiveInput orderBy;
  final PaginationInput paginationInput;
  
  const GetMaterialReceive(
    this.filterMaterialReceiveInput,
    this.orderBy,
    this.paginationInput,
  );
}

class GetMaterialReceiveDetailsEvent extends MaterialReceiveEvent {
  final String materialReceiveId;
  const GetMaterialReceiveDetailsEvent({required this.materialReceiveId});
}

class UpdateMaterialReceive extends MaterialReceiveEvent {
  final String id;
  const UpdateMaterialReceive(this.id);
}

class DeleteMaterialReceive extends MaterialReceiveEvent {
  final String id;
  const DeleteMaterialReceive(this.id);
}

class CreateMaterialReceiveEvent extends MaterialReceiveEvent {
  final CreateMaterialReceiveParamsEntity createMaterialReceiveParamsEntity;

  const CreateMaterialReceiveEvent(
      {required this.createMaterialReceiveParamsEntity});
}

// class UpdateMaterialReceiveEvent extends MaterialReceiveEvent {
//   final String id;
//   const UpdateMaterialReceiveEvent(this.id);
// }

// class DeleteMaterialReceiveEvent extends MaterialReceiveEvent {
//   final String id;
//   const DeleteMaterialReceiveEvent(this.id);
// }

