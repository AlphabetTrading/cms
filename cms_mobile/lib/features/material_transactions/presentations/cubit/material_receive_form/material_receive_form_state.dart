import 'package:cms_mobile/features/material_transactions/presentations/pages/material_receive/material_receive_edit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_issue/create_material_issue_form.dart';
import 'package:equatable/equatable.dart';

enum FormStatus { invalid, valid, validating }

class MaterialReceiveWarehouseFormState extends Equatable {
  final WarehouseDropdown warehouseDropdown;
  final bool isValid;

  const MaterialReceiveWarehouseFormState(
      {this.warehouseDropdown = const WarehouseDropdown.pure(),
      this.isValid = false});

  MaterialReceiveWarehouseFormState copyWith({
    WarehouseDropdown? warehouseDropdown,
    bool? isValid,
  }) {
    return MaterialReceiveWarehouseFormState(
      isValid: isValid ?? this.isValid,
      warehouseDropdown: warehouseDropdown ?? this.warehouseDropdown,
    );
  }

  @override
  List<Object?> get props => [
        warehouseDropdown,
      ];
}

class MaterialReceiveFormState extends Equatable {
  final bool isValid;
  final FormStatus formStatus;
  final QuantityField quantityField;
  final MaterialDropdown materialDropdown;
  final MaterialDropdown materialReceiveDropdown;
  // final WarehouseDropdown warehouseDropdown;

  // final UnitDropdown unitDropdown;
  final RemarkField remarkField;
  final double inStock;

  MaterialReceiveFormState(
      {this.isValid = false,
      this.formStatus = FormStatus.invalid,
      this.quantityField = const QuantityField.pure(),
      this.materialDropdown = const MaterialDropdown.pure(),
      this.materialReceiveDropdown = const MaterialDropdown.pure(),
      // this.warehouseDropdown = const WarehouseDropdown.pure(),

      // this.unitDropdown = const UnitDropdown.pure(),
      this.remarkField = const RemarkField.pure(),
      this.inStock = 0.0});

  MaterialReceiveFormState copyWith({
    bool? isValid,
    FormStatus? formStatus,
    QuantityField? quantityField,
    MaterialDropdown? materialDropdown,
    MaterialDropdown? materialReceiveDropdown,

    // WarehouseDropdown? warehouseDropdown,
    // UnitDropdown? unitDropdown,
    RemarkField? remarkField,
    double? inStock,
  }) {
    return MaterialReceiveFormState(
        isValid: isValid ?? this.isValid,
        formStatus: formStatus ?? this.formStatus,
        quantityField: quantityField ?? this.quantityField,
        materialDropdown: materialDropdown ?? this.materialDropdown,
        materialReceiveDropdown:
            materialReceiveDropdown ?? this.materialReceiveDropdown,

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
        materialReceiveDropdown,
        // warehouseDropdown,
        // unitDropdown,
        remarkField,
        inStock
      ];
}
