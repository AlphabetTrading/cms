import 'package:cms_mobile/features/material_transactions/presentations/pages/material_return/create_material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_return/create_material_return_form.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

enum FormStatus { invalid, valid, validating }

class MaterialReturnWarehouseFormState extends Equatable {
  final FormStatus formStatus;
  final WarehouseDropdown warehouseDropdown;
  final bool isValid;

  const MaterialReturnWarehouseFormState(
      {this.warehouseDropdown = const WarehouseDropdown.pure(),
      this.formStatus = FormStatus.invalid,
      this.isValid = false});

  MaterialReturnWarehouseFormState copyWith({
    bool? isValid,
    FormStatus? formStatus,
    WarehouseDropdown? warehouseDropdown,
  }) {
    return MaterialReturnWarehouseFormState(
      isValid: isValid ?? this.isValid,
      formStatus: formStatus ?? this.formStatus,
      warehouseDropdown: warehouseDropdown ?? this.warehouseDropdown,
    );
  }

  @override
  String toString() {
    return 'MaterialReturnWarehouseFormState(warehouseDropdown: $warehouseDropdown, isValid: $isValid, formStatus: $formStatus)';
  }

  @override
  List<Object?> get props => [warehouseDropdown, isValid, formStatus];
}

class MaterialReturnFormState extends Equatable {
  final bool isValid;
  final FormStatus formStatus;
  final QuantityField quantityField;
  final MaterialDropdown materialDropdown;
  final MaterialIssueDropdown materialIssueDropdown;
  // final WarehouseDropdown warehouseDropdown;

  // final UnitDropdown unitDropdown;
  final RemarkField remarkField;
  final double issuedQuantity;

  MaterialReturnFormState(
      {this.isValid = false,
      this.formStatus = FormStatus.invalid,
      this.quantityField = const QuantityField.pure(),
      this.materialDropdown = const MaterialDropdown.pure(),
      this.materialIssueDropdown = const MaterialIssueDropdown.pure(),
      // this.warehouseDropdown = const WarehouseDropdown.pure(),

      // this.unitDropdown = const UnitDropdown.pure(),
      this.remarkField = const RemarkField.pure(),
      this.issuedQuantity = 0.0});

  MaterialReturnFormState copyWith({
    bool? isValid,
    FormStatus? formStatus,
    QuantityField? quantityField,
    MaterialDropdown? materialDropdown,
    MaterialIssueDropdown? materialIssueDropdown,

    // WarehouseDropdown? warehouseDropdown,
    // UnitDropdown? unitDropdown,
    RemarkField? remarkField,
    double? issuedQuantity,
  }) {
    return MaterialReturnFormState(
        isValid: isValid ?? this.isValid,
        formStatus: formStatus ?? this.formStatus,
        quantityField: quantityField ?? this.quantityField,
        materialDropdown: materialDropdown ?? this.materialDropdown,
        materialIssueDropdown:
            materialIssueDropdown ?? this.materialIssueDropdown,

        // warehouseDropdown: warehouseDropdown ?? this.warehouseDropdown,
        // unitDropdown: unitDropdown ?? this.unitDropdown,
        remarkField: remarkField ?? this.remarkField,
        issuedQuantity: issuedQuantity ?? this.issuedQuantity);
  }

  @override
  String toString() {
    return 'MaterialReturnFormState(isValid: $isValid, formStatus: $formStatus, quantityField: $quantityField, materialDropdown: $materialDropdown, materialIssueDropdown: $materialIssueDropdown, remarkField: $remarkField, issuedQuantity: $issuedQuantity)';
  }

  @override
  List<Object?> get props => [
        isValid,
        formStatus,
        quantityField,
        materialDropdown,
        materialIssueDropdown,
        // warehouseDropdown,
        // unitDropdown,
        remarkField,
        issuedQuantity
      ];
}
