import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:equatable/equatable.dart';

class MaterialProformaState extends Equatable {
  final MaterialProformaEntityListWithMeta? materialProformas;
  final MaterialProformaEntityListWithMeta? myMaterialProformas;
  final MaterialProformaEntity? materialProforma;
  final bool hasReachedMax;

  final Failure? error;

  const MaterialProformaState({
    this.materialProformas,
    this.myMaterialProformas,
    this.error,
    this.materialProforma,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [
        materialProformas,
        myMaterialProformas,
        error,
        materialProforma,
        hasReachedMax,
      ];

  @override
  String toString() {
    return 'MaterialProformaState { materialProformas: $materialProformas, myMaterialProformas: $myMaterialProformas, error: $error, materialProforma: $materialProforma, hasReachedMax: $hasReachedMax }';
  }

  MaterialProformaState copyWith({
    MaterialProformaEntityListWithMeta? materialProformas,
    MaterialProformaEntityListWithMeta? myMaterialProformas,
    MaterialProformaEntity? materialProforma,
    bool? hasReachedMax,
    Failure? error,
  }) {
    return MaterialProformaState(
      materialProformas: materialProformas ?? this.materialProformas,
      myMaterialProformas: myMaterialProformas ?? this.myMaterialProformas,
      materialProforma: materialProforma ?? this.materialProforma,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error ?? this.error,
    );
  }
}

class MaterialProformaInitial extends MaterialProformaState {
  const MaterialProformaInitial();
}

class MaterialProformasLoading extends MaterialProformaState {
  const MaterialProformasLoading();
}

class MaterialProformasSuccess extends MaterialProformaState {
  const MaterialProformasSuccess(
      {required MaterialProformaEntityListWithMeta materialProformas,
      required MaterialProformaEntityListWithMeta myMaterialProformas})
      : super(
            materialProformas: materialProformas,
            myMaterialProformas: myMaterialProformas);

  // MaterialProformasSuccess copyWith({
  //   MaterialProformaEntityListWithMeta? materialProformas,
  //   MaterialProformaEntityListWithMeta? myMaterialProformas,
  //   bool? hasReachedMax,
  // }) {
  //   return MaterialProformasSuccess(
  //     materialProformas: materialProformas ?? this.materialProformas!,
  //     myMaterialProformas: myMaterialProformas ?? this.myMaterialProformas!,
  //   );
  // }

  MaterialProformaState copyWith({
    MaterialProformaEntityListWithMeta? materialProformas,
    MaterialProformaEntityListWithMeta? myMaterialProformas,
    MaterialProformaEntity? materialProforma,
    bool? hasReachedMax,
    Failure? error,
  }) {
    return MaterialProformasSuccess(
      materialProformas: materialProformas ?? this.materialProformas!,
      myMaterialProformas: myMaterialProformas ?? this.myMaterialProformas!,
    );
  }
}

class MaterialProformasFailed extends MaterialProformaState {
  const MaterialProformasFailed({required Failure error}) : super(error: error);
}

class MaterialProformasEmpty extends MaterialProformaState {
  const MaterialProformasEmpty();
}

// Get Material Issue Details
// class MaterialProformaDetailsLoading extends MaterialProformaState {
//   const MaterialProformaDetailsLoading();
// }

// class MaterialProformaDetailsSuccess extends MaterialProformaState {
//   const MaterialProformaDetailsSuccess(
//       {required MaterialProformaEntity materialProforma})
//       : super(materialProforma: materialProforma);
// }

// class MaterialProformaDetailsFailed extends MaterialProformaState {
//   const MaterialProformaDetailsFailed({required Failure error})
//       : super(error: error);
// }

// Create Material Issue
class CreateMaterialProformaLoading extends MaterialProformaState {
  const CreateMaterialProformaLoading();
}

class CreateMaterialProformaSuccess extends MaterialProformaState {
  const CreateMaterialProformaSuccess();
}

class CreateMaterialProformaFailed extends MaterialProformaState {
  const CreateMaterialProformaFailed({required Failure error})
      : super(error: error);
}
