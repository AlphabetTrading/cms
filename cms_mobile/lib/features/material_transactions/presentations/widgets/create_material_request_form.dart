import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request_material.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_request_local/material_request_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_request_form_cubit.dart';
import 'package:cms_mobile/features/materials/domain/entities/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class CreateMaterialRequestForm extends StatelessWidget {
  final bool isEdit;
  final int index;

  CreateMaterialRequestForm({
    super.key,
    this.isEdit = false,
    this.index = -1,
  });

  final List<MaterialEntity> materials = [
    const MaterialEntity(id: "1", name: "Material 1", quantity: 10),
    const MaterialEntity(id: "2", name: "Material 2", quantity: 510),
    const MaterialEntity(id: "3", name: "Material 3", quantity: 256),
  ];

  @override
  Widget build(BuildContext context) {
    final materialRequestFormCubit = context.watch<MaterialRequestFormCubit>();

    final quantityField = materialRequestFormCubit.state.quantityField;
    final materialDropdown = materialRequestFormCubit.state.materialDropdown;
    final unitDropdown = materialRequestFormCubit.state.unitDropdown;
    final remarkField = materialRequestFormCubit.state.remarkField;
    print("in Stockk");

    print(materialRequestFormCubit.state.inStock);

    // Build a Form widget using the _formKey created above.
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropdown(
            initialSelection: materialDropdown.value != ""
                ? materials.firstWhere(
                    (element) => element.id == materialDropdown.value)
                : null,
            onSelected: (dynamic value) =>
                materialRequestFormCubit.materialChanged(value),
            dropdownMenuEntries: materials
                .map((e) =>
                    DropdownMenuEntry<MaterialEntity>(label: e.name, value: e))
                .toList(),
            enableFilter: false,
            errorMessage: materialDropdown.errorMessage, label: 'Material',
            // label: "Material"
          ),
          const SizedBox(
            height: 10,
          ), // SizedBox(height: 10,
          Row(
            children: [
              Flexible(
                child: CustomDropdown(
                    initialSelection: unitDropdown.value,
                    onSelected: (dynamic value) =>
                        materialRequestFormCubit.unitChanged(value),
                    errorMessage: unitDropdown.errorMessage,
                    dropdownMenuEntries: [
                      "m2",
                      "Quintal",
                      "Kg",
                    ]
                        .map((e) =>
                            DropdownMenuEntry<String>(label: e, value: e))
                        .toList(),
                    enableFilter: false,
                    label: "Unit"),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: CustomTextFormField(
                  initialValue: double.tryParse(quantityField.value) != null
                      ? quantityField.value
                      : "",
                  keyboardType: TextInputType.number,
                  label: "Requested Quantity",
                  onChanged: materialRequestFormCubit.quantityChanged,
                  errorMessage: quantityField.errorMessage,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          Row(
            children: [
              Flexible(
                  child: CustomTextFormField(
                controller: TextEditingController(
                    text: materialDropdown.value != ""
                        ? materials
                            .firstWhere((element) =>
                                element.id == materialDropdown.value)
                            .quantity
                            .toString()
                        : ""),
                label: "In Stock",
                readOnly: true,
              )),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                  child: CustomTextFormField(
                controller: materialDropdown.value != "" &&
                        double.tryParse(quantityField.value) != null
                    ? TextEditingController(
                        text: (double.parse(quantityField.value) -
                                materials
                                    .firstWhere((element) =>
                                        element.id == materialDropdown.value)
                                    .quantity)
                            .toString())
                    : TextEditingController(text: ""),
                label: "To be Purchased",
                readOnly: true,
              ))
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          //
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
                if (isEdit) {
                  final updated = MaterialRequestMaterialEntity(
                    material: materials.firstWhere(
                        (element) => element.id == materialDropdown.value),
                    unit: unitDropdown.value,
                    requestedQuantity: double.parse(quantityField.value),
                    remark: remarkField.value,
                  );

                  BlocProvider.of<MaterialRequestLocalBloc>(context)
                      .add(EditMaterialRequestMaterialLocal(updated, index));
                } else {
                  BlocProvider.of<MaterialRequestLocalBloc>(context).add(
                    AddMaterialRequestMaterialLocal(
                      MaterialRequestMaterialEntity(
                        material: materials.firstWhere(
                            (element) => element.id == materialDropdown.value),
                        unit: unitDropdown.value,
                        requestedQuantity: double.parse(quantityField.value),
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
            child: isEdit
                ? const Text('Save Changes')
                : const Text('Add Material'),
          ),
        ],
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
