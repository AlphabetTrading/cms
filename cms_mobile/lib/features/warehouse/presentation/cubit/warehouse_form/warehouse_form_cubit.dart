import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/warehouse/presentation/cubit/warehouse_form/warehouse_form_state.dart';
import 'package:cms_mobile/features/warehouse/presentation/widgets/create_warehouse_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class WarehouseFormCubit extends Cubit<WarehouseFormState> {
  WarehouseFormCubit({
    String? name,
    String? location,
    String? managerId,
  }) : super(WarehouseFormState(
          nameField: NameField.pure(name ?? ""),
          locationField: LocationField.pure(location ?? ""),
          managerDropdown: ManagerDropdown.pure(managerId ?? ""),
        ));

  void nameChanged(String value) {
    final NameField nameField =
        NameField.dirty(value, name: state.nameField.name);

    emit(
      state.copyWith(
        nameField: nameField,
        isValid: Formz.validate([state.nameField]),
      ),
    );
  }

  void locationChanged(String value) {
    final LocationField locationField =
        LocationField.dirty(value, location: state.locationField.location);

    emit(
      state.copyWith(
        locationField: locationField,
        isValid: Formz.validate([state.locationField]),
      ),
    );
  }

  void managerChanged(UserEntity manager) {
    emit(
      state.copyWith(
        managerDropdown: ManagerDropdown.dirty(manager.id),
        selectedManager: manager,
        isValid: Formz.validate(
          [state.managerDropdown],
        ),
      ),
    );
  }

  void onSubmit() {
    debugPrint('Name: ${state.nameField.value}');
    debugPrint('Location: ${state.locationField.value}');
    debugPrint('Selected Manager: ${state.selectedManager?.id}');
    emit(
      state.copyWith(
        formStatus: FormStatus.validating,
        nameField:
            NameField.dirty(state.nameField.value, name: state.nameField.name),
        locationField: LocationField.dirty(state.locationField.value,
            location: state.locationField.location),
        managerDropdown: ManagerDropdown.dirty(state.managerDropdown.value),
        isValid: Formz.validate([
          state.nameField,
          state.locationField,
          state.managerDropdown,
        ]),
      ),
    );
  }
}
