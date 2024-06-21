import 'package:cms_mobile/features/material_transactions/presentations/pages/material_receive/create_material_receive.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_receive/create_material_receive_form.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

enum FormStatus { invalid, valid, validating }

class MaterialReceiveWarehouseFormState extends Equatable {
  final FormStatus formStatus;
  final WarehouseDropdown warehouseDropdown;
  final bool isValid;

  const MaterialReceiveWarehouseFormState(
      {this.warehouseDropdown = const WarehouseDropdown.pure(),
      this.formStatus = FormStatus.invalid,
      this.isValid = false});

  MaterialReceiveWarehouseFormState copyWith({
    bool? isValid,
    FormStatus? formStatus,
    WarehouseDropdown? warehouseDropdown,
  }) {
    return MaterialReceiveWarehouseFormState(
      isValid: isValid ?? this.isValid,
      formStatus: formStatus ?? this.formStatus,
      warehouseDropdown: warehouseDropdown ?? this.warehouseDropdown,
    );
  }

  @override
  String toString() {
    return 'MaterialReceiveWarehouseFormState(warehouseDropdown: $warehouseDropdown, isValid: $isValid, formStatus: $formStatus)';
  }

  @override
  List<Object?> get props => [warehouseDropdown, isValid, formStatus];
}

class MaterialReceiveFormState extends Equatable {
  final bool isValid;
  final FormStatus formStatus;
  final NumberField transportationField;
  final NumberField loadingField;
  final NumberField unloadingField;
  final MaterialDropdown materialDropdown;
  final PurchaseOrderDropdown purchaseOrderDropdown;
  // final WarehouseDropdown warehouseDropdown;

  // final UnitDropdown unitDropdown;
  final RemarkField remarkField;
  // final double issuedQuantity;

  MaterialReceiveFormState(
      {this.isValid = false,
      this.formStatus = FormStatus.invalid,
      this.transportationField = const NumberField.pure(),
      this.loadingField = const NumberField.pure(),
      this.unloadingField = const NumberField.pure(),
      this.materialDropdown = const MaterialDropdown.pure(),
      this.purchaseOrderDropdown = const PurchaseOrderDropdown.pure(),
      // this.warehouseDropdown = const WarehouseDropdown.pure(),

      // this.unitDropdown = const UnitDropdown.pure(),
      this.remarkField = const RemarkField.pure(),
     });

  MaterialReceiveFormState copyWith({
    bool? isValid,
    FormStatus? formStatus,
    NumberField? transportationField,
    NumberField? loadingField,
    NumberField? unloadingField,
    PurchaseOrderDropdown? purchaseOrderDropdown,
    MaterialDropdown? materialDropdown,

    // WarehouseDropdown? warehouseDropdown,
    // UnitDropdown? unitDropdown,
    RemarkField? remarkField,
    // double? issuedQuantity,
  }) {
    return MaterialReceiveFormState(
        isValid: isValid ?? this.isValid,
        formStatus: formStatus ?? this.formStatus,
        transportationField: transportationField ?? this.transportationField,
        loadingField: loadingField ?? this.loadingField,
        unloadingField: unloadingField ?? this.unloadingField,
        materialDropdown: materialDropdown ?? this.materialDropdown,
        purchaseOrderDropdown:
            purchaseOrderDropdown ?? this.purchaseOrderDropdown,

        // warehouseDropdown: warehouseDropdown ?? this.warehouseDropdown,
        // unitDropdown: unitDropdown ?? this.unitDropdown,
        remarkField: remarkField ?? this.remarkField,
    );
  }

  @override
  String toString() {
   return 'MaterialReceiveFormState(isValid: $isValid, formStatus: $formStatus, transportationField: $transportationField, loadingField: $loadingField, unloadingField: $unloadingField, materialDropdown: $materialDropdown, purchaseOrderDropdown: $purchaseOrderDropdown, remarkField: $remarkField)';
  }

  @override
  List<Object?> get props => [
        isValid,
        formStatus,
        transportationField,
        loadingField,
        unloadingField,
        purchaseOrderDropdown,
        materialDropdown,
        // warehouseDropdown,
        // unitDropdown,
        remarkField,
      ];
}
