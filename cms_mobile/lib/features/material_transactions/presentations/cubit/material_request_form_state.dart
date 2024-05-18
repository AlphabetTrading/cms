import 'package:cms_mobile/features/material_transactions/presentations/widgets/create_material_request_form.dart';
import 'package:equatable/equatable.dart';

enum FormStatus { invalid, valid, validating }

class MaterialRequestFormState extends Equatable {
  final bool isValid;
  final FormStatus formStatus;
  final QuantityField quantityField;
  final MaterialDropdown materialDropdown;
  final UnitDropdown unitDropdown;
  final RemarkField remarkField;
  final double inStock;

  MaterialRequestFormState(
      {this.isValid = false,
      this.formStatus = FormStatus.invalid,
      this.quantityField = const QuantityField.pure(),
      this.materialDropdown = const MaterialDropdown.pure(),
      this.unitDropdown = const UnitDropdown.pure(),
      this.remarkField = const RemarkField.pure(),
      this.inStock = 0.0});

  MaterialRequestFormState copyWith({
    bool? isValid,
    FormStatus? formStatus,
    QuantityField? quantityField,
    MaterialDropdown? materialDropdown,
    UnitDropdown? unitDropdown,
    RemarkField? remarkField,
    double? inStock,
  }) {
    return MaterialRequestFormState(
        isValid: isValid ?? this.isValid,
        formStatus: formStatus ?? this.formStatus,
        quantityField: quantityField ?? this.quantityField,
        materialDropdown: materialDropdown ?? this.materialDropdown,
        unitDropdown: unitDropdown ?? this.unitDropdown,
        remarkField: remarkField ?? this.remarkField,
        inStock: inStock ?? this.inStock);
  }

  @override
  String toString() {
    return 'MaterialRequestFormState{isValid: $isValid, formStatus: $formStatus, quantityField: $quantityField, materialDropdown: $materialDropdown}';
  }

  @override
  List<Object?> get props => [
        isValid,
        formStatus,
        quantityField,
        materialDropdown,
        unitDropdown,
        remarkField,
        inStock
      ];
}
