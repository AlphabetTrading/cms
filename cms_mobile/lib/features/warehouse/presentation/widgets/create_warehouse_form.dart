import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/user/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/user/presentation/bloc/user_bloc.dart';
import 'package:cms_mobile/features/user/presentation/bloc/user_event.dart';
import 'package:cms_mobile/features/user/presentation/bloc/user_state.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse/warehouse_bloc.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_local/warehouse_local_bloc.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_local/warehouse_local_event.dart';
import 'package:cms_mobile/features/warehouse/presentation/cubit/warehouse_form/warehouse_form_cubit.dart';
import 'package:cms_mobile/features/warehouse/presentation/cubit/warehouse_form/warehouse_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class CreateWarehouseForm extends StatefulWidget {
  final bool isEdit;
  final int index;

  CreateWarehouseForm({
    super.key,
    this.isEdit = false,
    this.index = -1,
  });

  @override
  State<CreateWarehouseForm> createState() => _CreateWarehouseFormState();
}

class _CreateWarehouseFormState extends State<CreateWarehouseForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(GetUsers(
        filterUserInput: FilterUserInput(role: [UserRole.STORE_MANAGER.name])));
  }

  @override
  Widget build(BuildContext context) {
    final warehouseCubit = context.watch<WarehouseFormCubit>();
    final nameField = warehouseCubit.state.nameField;
    final locationField = warehouseCubit.state.locationField;
    final managerDropdown = warehouseCubit.state.managerDropdown;

    // Build a Form widget using the _formKey created above.
    return Form(
      child: BlocBuilder<WarehouseFormCubit, WarehouseFormState>(
        builder: (warehouseContext, warehouseState) {
          return BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextFormField(
                          initialValue: nameField.value,
                          label: "Name",
                          onChanged: warehouseCubit.nameChanged,
                          errorMessage: nameField.errorMessage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextFormField(
                          initialValue: locationField.value,
                          label: "Location",
                          onChanged: warehouseCubit.locationChanged,
                          errorMessage: locationField.errorMessage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomDropdown(
                    initialSelection: managerDropdown.value,
                    onSelected: (dynamic value) {
                      final selectedManager = state.users?.firstWhere(
                        (user) => user.id == value,
                      );

                      if (selectedManager != null) {
                        warehouseCubit.managerChanged(selectedManager);
                      }
                    },
                    dropdownMenuEntries: state.users
                            ?.map((e) => DropdownMenuEntry<String>(
                                  label: e.fullName!,
                                  value: e.id,
                                ))
                            .toList() ??
                        [],
                    enableFilter: false,
                    errorMessage: managerDropdown.errorMessage,
                    label: 'Store Managers',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      warehouseCubit.onSubmit();
                      final formState = warehouseCubit.state;
                      debugPrint(
                          "Form STatus ${formState}");
                      if (warehouseCubit.state.isValid) {
                        if (widget.isEdit) {
                          // final updated = WarehouseEntity(
                          //   name: nameField.value,
                          //   location: locationField.value,
                          //   companyId: warehouseState.companyId,
                          // );

                          // BlocProvider.of<MaterialIssueLocalBloc>(context).add(
                          //     EditMaterialIssueMaterialLocal(
                          //         updated, widget.index));
                        } else {
                          BlocProvider.of<WarehouseBloc>(context).add(
                            CreateWarehouseEvent(
                              createWarehouseParamsEntity:
                                  CreateWarehouseParamsEntity(
                                companyId: "",
                                name: nameField.value,
                                location: locationField.value,
                                storeManagers: [
                                  WarehouseStoreManagerEntity(
                                    storeManager:
                                        warehouseCubit.state.selectedManager,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: widget.isEdit
                        ? const Text('Save Changes')
                        : const Text('Add Warehouse'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

enum NameValidationError { empty }

class NameField extends FormzInput<String, NameValidationError> {
  const NameField.pure([super.value = '', this.name = ""]) : super.pure();
  const NameField.dirty(super.value, {required this.name}) : super.dirty();

  final String name;

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == NameValidationError.empty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  NameValidationError? validator(String value) {
    if (value.isEmpty) {
      return NameValidationError.empty;
    }
    return null;
  }
}

enum LocationValidationError { empty }

class LocationField extends FormzInput<String, LocationValidationError> {
  const LocationField.pure([super.value = '', this.location = ""])
      : super.pure();
  const LocationField.dirty(super.value, {required this.location})
      : super.dirty();

  final String location;

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == LocationValidationError.empty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  LocationValidationError? validator(String value) {
    if (value.isEmpty) {
      return LocationValidationError.empty;
    }
    return null;
  }
}

enum ManagerDropdownError { invalid }

class ManagerDropdown extends FormzInput<String, ManagerDropdownError> {
  const ManagerDropdown.pure([super.value = '']) : super.pure();
  const ManagerDropdown.dirty([super.value = '']) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == ManagerDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  ManagerDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return ManagerDropdownError.invalid;
    }
    return null;
  }
}
