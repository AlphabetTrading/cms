import 'package:cms_mobile/features/material_transactions/presentations/widgets/daily_site_data/add_material_form.dart';
import 'package:equatable/equatable.dart';

enum FormStatus { invalid, valid, validating }

class DailySiteDataAddMaterialFormState extends Equatable {
  final bool isValid;
  final FormStatus formStatus;
  final QuantityUsedField quantityUsedField;
  final QuantityWastedField quantityWastedField;
  final UnitDropdown unitDropdown;
  final MaterialDropdown materialDropdown;

  const DailySiteDataAddMaterialFormState({
    this.isValid = false,
    this.formStatus = FormStatus.invalid,
    this.quantityUsedField = const QuantityUsedField.pure(),
    this.quantityWastedField = const QuantityWastedField.pure(),
    this.materialDropdown = const MaterialDropdown.pure(),
    this.unitDropdown = const UnitDropdown.pure(),
  });

  DailySiteDataAddMaterialFormState copyWith({
    bool? isValid,
    FormStatus? formStatus,
    QuantityUsedField? quantityUsedField,
    QuantityWastedField? quantityWastedField,
    MaterialDropdown? materialDropdown,
    UnitDropdown? unitDropdown,
  }) {
    return DailySiteDataAddMaterialFormState(
      isValid: isValid ?? this.isValid,
      formStatus: formStatus ?? this.formStatus,
      quantityUsedField: quantityUsedField ?? this.quantityUsedField,
      quantityWastedField: quantityWastedField ?? this.quantityWastedField,
      materialDropdown: materialDropdown ?? this.materialDropdown,
      unitDropdown: unitDropdown ?? this.unitDropdown,
    );
  }

  @override
  List<Object?> get props => [
        isValid,
        formStatus,
        quantityUsedField,
        quantityWastedField,
        materialDropdown,
        unitDropdown,
      ];
}
