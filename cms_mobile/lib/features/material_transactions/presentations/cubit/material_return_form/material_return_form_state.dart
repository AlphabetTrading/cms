import 'package:cms_mobile/features/material_transactions/presentations/pages/material_return/create_material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_return/create_material_return_form.dart';
import 'package:equatable/equatable.dart';

enum FormStatus { invalid, valid, validating }

class MaterialReturnWarehouseFormState extends Equatable {
  final WarehouseDropdown warehouseDropdown;
  final bool isValid;

  const MaterialReturnWarehouseFormState({
    this.warehouseDropdown = const WarehouseDropdown.pure(),
    this.isValid = false
  });

  MaterialReturnWarehouseFormState copyWith({
    WarehouseDropdown? warehouseDropdown,
    bool? isValid,
  }) {
    return MaterialReturnWarehouseFormState(
      isValid: isValid ?? this.isValid,
      warehouseDropdown: warehouseDropdown ?? this.warehouseDropdown,
    );
  }

  @override
  List<Object?> get props => [
        warehouseDropdown,
      ];
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
  final double inStock;

  MaterialReturnFormState(
      {this.isValid = false,
      this.formStatus = FormStatus.invalid,
      this.quantityField = const QuantityField.pure(),
      this.materialDropdown = const MaterialDropdown.pure(),
      this.materialIssueDropdown = const MaterialIssueDropdown.pure(),
      // this.warehouseDropdown = const WarehouseDropdown.pure(),

      // this.unitDropdown = const UnitDropdown.pure(),
      this.remarkField = const RemarkField.pure(),
      this.inStock = 0.0});

  MaterialReturnFormState copyWith({
    bool? isValid,
    FormStatus? formStatus,
    QuantityField? quantityField,
    MaterialDropdown? materialDropdown,
    MaterialIssueDropdown? materialIssueDropdown,

    // WarehouseDropdown? warehouseDropdown,
    // UnitDropdown? unitDropdown,
    RemarkField? remarkField,
    double? inStock,
  }) {
    return MaterialReturnFormState(
        isValid: isValid ?? this.isValid,
        formStatus: formStatus ?? this.formStatus,
        quantityField: quantityField ?? this.quantityField,
        materialDropdown: materialDropdown ?? this.materialDropdown,
        materialIssueDropdown: materialIssueDropdown ?? this.materialIssueDropdown,

        // warehouseDropdown: warehouseDropdown ?? this.warehouseDropdown,
        // unitDropdown: unitDropdown ?? this.unitDropdown,
        remarkField: remarkField ?? this.remarkField,
        inStock: inStock ?? this.inStock);
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
        inStock
      ];
}
