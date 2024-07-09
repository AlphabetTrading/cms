import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';

abstract class MaterialReceiveEvent {
  const MaterialReceiveEvent();
}

class GetMaterialReceives extends MaterialReceiveEvent {
  final FilterMaterialReceiveInput? filterMaterialReceiveInput;
  final OrderByMaterialReceiveInput? orderBy;
  final PaginationInput? paginationInput;
  final bool? mine;
  const GetMaterialReceives({
    this.filterMaterialReceiveInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
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


// class UpdateMaterialReceiveEvent extends MaterialReceiveEvent {
//   final String id;
//   const UpdateMaterialReceiveEvent(this.id);
// }

// class DeleteMaterialReceiveEvent extends MaterialReceiveEvent {
//   final String id;
//   const DeleteMaterialReceiveEvent(this.id);
// }

