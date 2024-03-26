import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/materials/domain/entities/material.dart';
import 'package:equatable/equatable.dart';

abstract class MaterialState extends Equatable {
  final List<MaterialEntity>? materials;
  final Failure? error;
  const MaterialState({this.materials, this.error});

  @override
  List<Object?> get props => [materials, error];
}

class MaterialInitial extends MaterialState {
  const MaterialInitial();
}

class MaterialLoading extends MaterialState {
  const MaterialLoading();
}

class MaterialSuccess extends MaterialState {
  const MaterialSuccess({required List<MaterialEntity> materials})
      : super(materials: materials);
}

class MaterialFailed extends MaterialState {
  const MaterialFailed({required Failure error})
      : super(error: error);
}
class MaterialEmpty extends MaterialState {
  const MaterialEmpty();
}
