import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_transfer/material_transfer_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';

abstract class MaterialTransferEvent {
  const MaterialTransferEvent();
}

class GetMaterialTransfers extends MaterialTransferEvent {
  final FilterMaterialTransferInput? filterMaterialTransferInput;
  final OrderByMaterialTransferInput? orderBy;
  final PaginationInput? paginationInput;
  final bool? mine;
  const GetMaterialTransfers({
    this.filterMaterialTransferInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
  });
}

class GetMaterialTransfer extends MaterialTransferEvent {
  final FilterMaterialTransferInput filterMaterialTransferInput;
  final OrderByMaterialTransferInput orderBy;
  final PaginationInput paginationInput;
  final bool? mine;
  const GetMaterialTransfer(
    this.filterMaterialTransferInput,
    this.orderBy,
    this.paginationInput,
    this.mine,

  );
}

class GetMaterialTransferDetailsEvent extends MaterialTransferEvent {
  final String materialTransferId;
  const GetMaterialTransferDetailsEvent({required this.materialTransferId});
}

class UpdateMaterialTransfer extends MaterialTransferEvent {
  final String id;
  const UpdateMaterialTransfer(this.id);
}

class DeleteMaterialTransfer extends MaterialTransferEvent {
  final String id;
  const DeleteMaterialTransfer(this.id);
}

class CreateMaterialTransferEvent extends MaterialTransferEvent {
  final CreateMaterialTransferParamsEntity createMaterialTransferParamsEntity;

  const CreateMaterialTransferEvent(
      {required this.createMaterialTransferParamsEntity});
}

// class UpdateMaterialTransferEvent extends MaterialTransferEvent {
//   final String id;
//   const UpdateMaterialTransferEvent(this.id);
// }

// class DeleteMaterialTransferEvent extends MaterialTransferEvent {
//   final String id;
//   const DeleteMaterialTransferEvent(this.id);
// }


// load more event
class LoadMoreMaterialTransfers extends MaterialTransferEvent {
  final FilterMaterialTransferInput? filterMaterialTransferInput;
  final OrderByMaterialTransferInput? orderBy;
  final PaginationInput? paginationInput;
  final bool? mine;
  const LoadMoreMaterialTransfers({
    this.filterMaterialTransferInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
  });
}
