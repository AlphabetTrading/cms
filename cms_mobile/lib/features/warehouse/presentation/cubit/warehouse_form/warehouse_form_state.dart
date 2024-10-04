import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/warehouse/presentation/widgets/create_warehouse_form.dart';
import 'package:equatable/equatable.dart';

enum FormStatus { invalid, valid, validating }

class WarehouseFormState extends Equatable {
  final bool isValid;
  final FormStatus formStatus;
  final NameField nameField;
  final LocationField locationField;
  final ManagerDropdown managerDropdown;
  final UserEntity? selectedManager;

  const WarehouseFormState(
      {this.isValid = false,
      this.formStatus = FormStatus.invalid,
      this.nameField = const NameField.pure(),
      this.locationField = const LocationField.pure(),
      this.managerDropdown = const ManagerDropdown.pure(),
      this.selectedManager});

  WarehouseFormState copyWith({
    bool? isValid,
    FormStatus? formStatus,
    NameField? nameField,
    LocationField? locationField,
    UserEntity? selectedManager,
    ManagerDropdown? managerDropdown,
  }) {
    return WarehouseFormState(
      isValid: isValid ?? this.isValid,
      formStatus: formStatus ?? this.formStatus,
      nameField: nameField ?? this.nameField,
      locationField: locationField ?? this.locationField,
      managerDropdown: managerDropdown ?? this.managerDropdown,
      selectedManager: selectedManager ?? this.selectedManager,
    );
  }

  @override
  List<Object?> get props =>
      [nameField, locationField, managerDropdown, selectedManager];
}
