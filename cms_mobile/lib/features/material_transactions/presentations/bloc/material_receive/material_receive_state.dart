import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';
import 'package:equatable/equatable.dart';

abstract class MaterialReceiveState extends Equatable {
  final MaterialReceiveEntityListWithMeta? materialReceives;
  final MaterialReceiveEntity? materialReceive;

  final Failure? error;

  const MaterialReceiveState(
      {this.materialReceives, this.error, this.materialReceive});

  @override
  List<Object?> get props => [materialReceives, error];
}

class MaterialReceiveInitial extends MaterialReceiveState {
  const MaterialReceiveInitial();
}

class MaterialReceivesLoading extends MaterialReceiveState {
  const MaterialReceivesLoading();
}

class MaterialReceivesSuccess extends MaterialReceiveState {
  const MaterialReceivesSuccess(
      {required MaterialReceiveEntityListWithMeta materialReceives})
      : super(materialReceives: materialReceives);
}

class MaterialReceivesFailed extends MaterialReceiveState {
  const MaterialReceivesFailed({required Failure error}) : super(error: error);
}

class MaterialReceivesEmpty extends MaterialReceiveState {
  const MaterialReceivesEmpty();
}

