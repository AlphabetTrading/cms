import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_bloc.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_event.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_event.dart';
import 'package:cms_mobile/features/items/domain/entities/item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_request_form/material_request_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class CreateMaterialRequestForm extends StatefulWidget {
  final bool isEdit;
  final int index;

  CreateMaterialRequestForm({
    super.key,
    this.isEdit = false,
    this.index = -1,
  });

  @override
  State<CreateMaterialRequestForm> createState() =>
      _CreateMaterialRequestFormState();
}

class _CreateMaterialRequestFormState extends State<CreateMaterialRequestForm> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ItemBloc>(context).add(const GetAllWarehouseItems(""));
  }

  @override
  Widget build(BuildContext context) {
    final materialRequestFormCubit = context.watch<MaterialRequestFormCubit>();

    final quantityField = materialRequestFormCubit.state.quantityField;
    final materialDropdown = materialRequestFormCubit.state.materialDropdown;
    // final unitDropdown = materialRequestFormCubit.state.unitDropdown;
    final remarkField = materialRequestFormCubit.state.remarkField;
    print("materialRequestFormCubit.state.inStock");

    print(materialRequestFormCubit.state.inStock);

    // Build a Form widget using the _formKey created above.
    return Form(
      child: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdown(
                initialSelection: materialDropdown.value != ""
                    ? state.allWarehouseItems?.firstWhere((element) =>
                        element.itemVariant.id == materialDropdown.value)
                    : null,
                onSelected: (dynamic value) =>
                    materialRequestFormCubit.materialChanged(value),
                dropdownMenuEntries: state.allWarehouseItems
                        ?.map((e) => DropdownMenuEntry<WarehouseItemEntity>(
                            label:
                                '${e.itemVariant.item!.name} - ${e.itemVariant.variant}',
                            value: e))
                        .toList() ??
                    [],
                enableFilter: false,
                errorMessage: materialDropdown.errorMessage, label: 'Material',
                trailingIcon: state is AllWarehouseItemsLoading
                    ? const CircularProgressIndicator()
                    : null,
                // label: "Material"
              ),
              const SizedBox(
                height: 10,
              ), // SizedBox(height: 10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Text("Unit",
                            style: Theme.of(context).textTheme.labelMedium),
                        materialDropdown.value != ""
                            ? Text(state.allWarehouseItems
                                    ?.firstWhere((element) =>
                                        element.itemVariant.id ==
                                        materialDropdown.value)
                                    .itemVariant
                                    .unit ??
                                "N/A")
                            : Text("N/A")
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Text("In Stock",
                            style: Theme.of(context).textTheme.labelMedium),
                        materialDropdown.value != ""
                            ? Text(state.allWarehouseItems
                                    ?.firstWhere((element) =>
                                        element.itemVariant.id ==
                                        materialDropdown.value)
                                    .quantity
                                    .toString() ??
                                "N/A")
                            : Text("N/A")
                      ],
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
                      initialValue: double.tryParse(quantityField.value) != null
                          ? quantityField.value
                          : "",
                      keyboardType: TextInputType.number,
                      label: "Requested Quantity (in unit)",
                      onChanged: materialRequestFormCubit.quantityChanged,
                      errorMessage: quantityField.errorMessage,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text("To be purchased",
                          style: Theme.of(context).textTheme.labelMedium),
                      materialDropdown.value != "" &&
                              double.tryParse(quantityField.value) != null
                          ? Text((double.parse(quantityField.value) -
                                  (state.allWarehouseItems!
                                      .firstWhere((element) =>
                                          element.itemVariant.id ==
                                          materialDropdown.value)
                                      .quantity))
                              .toString())
                          : Text("N/A"),
                    ],
                  )
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              CustomTextFormField(
                initialValue: remarkField.value,
                label: "Remark",
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onChanged: materialRequestFormCubit.remarkChanged,
                errorMessage: remarkField.errorMessage,
              ),
              const SizedBox(
                height: 10,
              ), //
              ElevatedButton(
                onPressed: () {
                  materialRequestFormCubit.onSubmit();
                  if (materialRequestFormCubit.state.isValid) {
                    if (widget.isEdit) {
                      final updated = MaterialRequestMaterialEntity(
                        material: state.allWarehouseItems!.firstWhere(
                            (element) =>
                                element.itemVariant.id ==
                                materialDropdown.value),
                        // unit: unitDropdown.value,
                        requestedQuantity: double.parse(quantityField.value),
                        remark: remarkField.value,
                      );

                      BlocProvider.of<MaterialRequestLocalBloc>(context).add(
                          EditMaterialRequestMaterialLocal(
                              updated, widget.index));
                    } else {
                      BlocProvider.of<MaterialRequestLocalBloc>(context).add(
                        AddMaterialRequestMaterialLocal(
                          MaterialRequestMaterialEntity(
                            material: state.allWarehouseItems?.firstWhere(
                                (element) =>
                                    element.itemVariant.id ==
                                    materialDropdown.value),
                            // unit: unitDropdown.value,
                            requestedQuantity:
                                double.parse(quantityField.value),
                            remark: remarkField.value,
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
                    : const Text('Add Material'),
              ),
            ],
          );
        },
      ),
    );
  }
}

enum QuanityValidationError { empty, notNumber, lessThanMin }

class QuantityField extends FormzInput<String, QuanityValidationError> {
  const QuantityField.pure({
    String value = "",
    this.inStock = 0,
  }) : super.pure(value);

  const QuantityField.dirty(
    String value, {
    required this.inStock,
  }) : super.dirty(value);

  final double inStock;

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == QuanityValidationError.empty) {
      return 'This field is required';
    }
    if (displayError == QuanityValidationError.notNumber) {
      return 'Quantity must be a number';
    }
    if (displayError == QuanityValidationError.lessThanMin) {
      return 'Quantity must be greater than the quantity in stock';
    }
    return null;
  }

  @override
  QuanityValidationError? validator(String value) {
    print("inStock");
    print(inStock);

    if (value.isEmpty) {
      return QuanityValidationError.empty;
    } else if (double.tryParse(value) == null) {
      return QuanityValidationError.notNumber;
    } else if (double.parse(value) <= inStock) {
      return QuanityValidationError.lessThanMin;
    }
    return null;
  }
}

enum MaterialDropdownError { invalid }

class MaterialDropdown extends FormzInput<String, MaterialDropdownError> {
  const MaterialDropdown.pure([String value = '']) : super.pure(value);
  const MaterialDropdown.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == MaterialDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  MaterialDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return MaterialDropdownError.invalid;
    }

    return null;
  }
}

enum UnitDropdownError { invalid }

class UnitDropdown extends FormzInput<String, UnitDropdownError> {
  const UnitDropdown.pure([String value = '']) : super.pure(value);
  const UnitDropdown.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == UnitDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  UnitDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return UnitDropdownError.invalid;
    }
    return null;
  }
}

enum RemarkValidationError { invalid }

class RemarkField extends FormzInput<String, RemarkValidationError> {
  const RemarkField.pure([String value = '']) : super.pure(value);
  const RemarkField.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == RemarkValidationError.invalid) {
      return 'Characters cannot exceed 100';
    }

    return null;
  }

  @override
  RemarkValidationError? validator(String value) {
    if (value.length > 100) {
      return RemarkValidationError.invalid;
    }
    return null;
  }
}
