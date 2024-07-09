import 'package:cms_mobile/features/material_transactions/presentations/pages/material_issue/create_material_issue.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_issue/create_material_issue_form.dart';
import 'package:equatable/equatable.dart';

enum FormStatus { invalid, valid, validating }

class MaterialProformaWarehouseFormState extends Equatable {
  final WarehouseDropdown warehouseDropdown;
  final bool isValid;

  const MaterialProformaWarehouseFormState({
    this.warehouseDropdown = const WarehouseDropdown.pure(),
    this.isValid = false
  });

  MaterialProformaWarehouseFormState copyWith({
    WarehouseDropdown? warehouseDropdown,
    bool? isValid,
  }) {
    return MaterialProformaWarehouseFormState(
      isValid: isValid ?? this.isValid,
      warehouseDropdown: warehouseDropdown ?? this.warehouseDropdown,
    );
  }

  @override
  List<Object?> get props => [
        warehouseDropdown,
      ];
}

class MaterialProformaFormState extends Equatable {
  final bool isValid;
  final FormStatus formStatus;
  final QuantityField quantityField;
  final MaterialDropdown materialDropdown;
  // final WarehouseDropdown warehouseDropdown;
  final UseTypeDropdown useTypeDropdown;
  final SubStructureUseDropdown subStructureUseDropdown;
  final SuperStructureUseDropdown superStructureUseDropdown;

  // final UnitDropdown unitDropdown;
  final RemarkField remarkField;
  final double inStock;

  MaterialProformaFormState(
      {this.isValid = false,
      this.formStatus = FormStatus.invalid,
      this.quantityField = const QuantityField.pure(),
      this.materialDropdown = const MaterialDropdown.pure(),
      // this.warehouseDropdown = const WarehouseDropdown.pure(),
      this.useTypeDropdown = const UseTypeDropdown.pure(),
      this.subStructureUseDropdown = const SubStructureUseDropdown.pure(),
      this.superStructureUseDropdown = const SuperStructureUseDropdown.pure(),

      // this.unitDropdown = const UnitDropdown.pure(),
      this.remarkField = const RemarkField.pure(),
      this.inStock = 0.0});

  MaterialProformaFormState copyWith({
    bool? isValid,
    FormStatus? formStatus,
    QuantityField? quantityField,
    MaterialDropdown? materialDropdown,
    // WarehouseDropdown? warehouseDropdown,
    UseTypeDropdown? useTypeDropdown,
    SubStructureUseDropdown? subStructureUseDropdown,
    SuperStructureUseDropdown? superStructureUseDropdown,
    // UnitDropdown? unitDropdown,
    RemarkField? remarkField,
    double? inStock,
  }) {
    return MaterialProformaFormState(
        isValid: isValid ?? this.isValid,
        formStatus: formStatus ?? this.formStatus,
        quantityField: quantityField ?? this.quantityField,
        materialDropdown: materialDropdown ?? this.materialDropdown,
        // warehouseDropdown: warehouseDropdown ?? this.warehouseDropdown,
        useTypeDropdown: useTypeDropdown ?? this.useTypeDropdown,
        subStructureUseDropdown:
            subStructureUseDropdown ?? this.subStructureUseDropdown,
        superStructureUseDropdown:
            superStructureUseDropdown ?? this.superStructureUseDropdown,
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
        // warehouseDropdown,
        useTypeDropdown,
        subStructureUseDropdown,
        superStructureUseDropdown,
        // unitDropdown,
        remarkField,
        inStock
      ];
}