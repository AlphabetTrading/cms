import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_transfer.dart';
import 'package:equatable/equatable.dart';

abstract class MaterialTransferState extends Equatable {
  final MaterialTransferEntityListWithMeta? materialTransfers;
  final MaterialTransferEntity? materialTransfer;

  final Failure? error;

  const MaterialTransferState(
      {this.materialTransfers, this.error, this.materialTransfer});

  @override
  List<Object?> get props => [materialTransfers, error];
}

class MaterialTransferInitial extends MaterialTransferState {
  const MaterialTransferInitial();
}

class MaterialTransfersLoading extends MaterialTransferState {
  const MaterialTransfersLoading();
}

class MaterialTransfersSuccess extends MaterialTransferState {
  const MaterialTransfersSuccess(
      {required MaterialTransferEntityListWithMeta materialTransfers})
      : super(materialTransfers: materialTransfers);
}

class MaterialTransfersFailed extends MaterialTransferState {
  const MaterialTransfersFailed({required Failure error}) : super(error: error);
}

class MaterialTransfersEmpty extends MaterialTransferState {
  const MaterialTransfersEmpty();
}

// Get Material Issue Details
// class MaterialTransferDetailsLoading extends MaterialTransferState {
//   const MaterialTransferDetailsLoading();
// }

// class MaterialTransferDetailsSuccess extends MaterialTransferState {
//   const MaterialTransferDetailsSuccess(
//       {required MaterialTransferEntity materialTransfer})
//       : super(materialTransfer: materialTransfer);
// }

// class MaterialTransferDetailsFailed extends MaterialTransferState {
//   const MaterialTransferDetailsFailed({required Failure error})
//       : super(error: error);
// }

// Create Material Issue
class CreateMaterialTransferLoading extends MaterialTransferState {
  const CreateMaterialTransferLoading();
}

class CreateMaterialTransferSuccess extends MaterialTransferState {
  const CreateMaterialTransferSuccess();
}

class CreateMaterialTransferFailed extends MaterialTransferState {
  const CreateMaterialTransferFailed({required Failure error})
      : super(error: error);
}

