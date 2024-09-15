import 'package:cms_mobile/features/material_transactions/presentations/pages/daily_site_data/daily_site_data_edit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/daily_site_data/create_daily_site_data_form.dart';
import 'package:equatable/equatable.dart';

enum FormStatus { invalid, valid, validating }

class DailySiteDataWarehouseFormState extends Equatable {
  final WarehouseDropdown warehouseDropdown;
  final bool isValid;

  const DailySiteDataWarehouseFormState(
      {this.warehouseDropdown = const WarehouseDropdown.pure(),
      this.isValid = false});

  DailySiteDataWarehouseFormState copyWith({
    WarehouseDropdown? warehouseDropdown,
    bool? isValid,
  }) {
    return DailySiteDataWarehouseFormState(
      isValid: isValid ?? this.isValid,
      warehouseDropdown: warehouseDropdown ?? this.warehouseDropdown,
    );
  }

  @override
  List<Object?> get props => [
        warehouseDropdown,
      ];
}

class DailySiteDataFormState extends Equatable {
  final bool isValid;
  final FormStatus formStatus;
  final QuantityField quantityField;
  final UnitDropdown unitDropdown;
  final TaskNameField taskNameField;
  final MaterialDropdown materialDropdown;

  const DailySiteDataFormState({
    this.isValid = false,
    this.formStatus = FormStatus.invalid,
    this.quantityField = const QuantityField.pure(),
    this.unitDropdown = const UnitDropdown.pure(),
    this.taskNameField = const TaskNameField.pure(),
    this.materialDropdown = const MaterialDropdown.pure(),
  });

  DailySiteDataFormState copyWith({
    bool? isValid,
    FormStatus? formStatus,
    QuantityField? quantityField,
    UnitDropdown? unitDropdown,
    MaterialDropdown? materialDropdown,
  }) {
    return DailySiteDataFormState(
      isValid: isValid ?? this.isValid,
      formStatus: formStatus ?? this.formStatus,
      quantityField: quantityField ?? this.quantityField,
      unitDropdown: unitDropdown ?? this.unitDropdown,
      materialDropdown: materialDropdown ?? this.materialDropdown,
    );
  }

  @override
  List<Object?> get props => [
        isValid,
        formStatus,
        quantityField,
        unitDropdown,
        materialDropdown,
      ];
}
