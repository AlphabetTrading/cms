import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/daily_site_data_form/daily_site_data_add_material_form_cubit.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_state.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class AddMaterialForm extends StatefulWidget {
  final bool isEdit;
  final int index;

  const AddMaterialForm({
    super.key,
    this.isEdit = false,
    this.index = -1,
  });

  @override
  State<AddMaterialForm> createState() => _AddMaterialFormState();
}

class _AddMaterialFormState extends State<AddMaterialForm> {
  @override
  Widget build(BuildContext context) {
    final dailySiteDataFormCubit =
        context.watch<DailySiteDataAddMaterialFormCubit>();
    final materialDropdown = dailySiteDataFormCubit.state.materialDropdown;
    final unitDropdown = dailySiteDataFormCubit.state.unitDropdown;
    final quantityUsedField = dailySiteDataFormCubit.state.quantityUsedField;
    final quantityWastedField =
        dailySiteDataFormCubit.state.quantityWastedField;

    // Build a Form widget using the _formKey created above.
    return Form(
      child: BlocBuilder<WarehouseBloc, WarehouseState>(
        builder: (warehouseContext, warehouseState) {
          return BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is AllWarehouseProductsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is AllWarehouseProductsFailed) {
                return Center(
                  child: Text(state.error?.errorMessage ?? "An error occured"),
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDropdown(
                    initialSelection: materialDropdown.value != ""
                        ? state.allWarehouseProducts?.firstWhere((element) =>
                            element.productVariant.id == materialDropdown.value)
                        : null,
                    onSelected: (dynamic value) {
                      dailySiteDataFormCubit.materialChanged(value);
                    },
                    dropdownMenuEntries: state.allWarehouseProducts
                            ?.map((e) => DropdownMenuEntry<
                                    WarehouseProductEntity>(
                                label:
                                    '${e.productVariant.product!.name} - ${e.productVariant.variant}',
                                value: e))
                            .toList() ??
                        [],
                    enableFilter: false,
                    errorMessage: materialDropdown.errorMessage,
                    label: 'Material',
                    trailingIcon: state is WarehouseProductsLoading
                        ? const CircularProgressIndicator()
                        : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextFormField(
                          initialValue:
                              double.tryParse(quantityUsedField.value) != null
                                  ? quantityUsedField.value
                                  : "",
                          keyboardType: TextInputType.number,
                          label: "Quantity Used",
                          onChanged: dailySiteDataFormCubit.quantityUsedChanged,
                          errorMessage: quantityUsedField.errorMessage,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: CustomTextFormField(
                          initialValue:
                              double.tryParse(quantityUsedField.value) != null
                                  ? quantityWastedField.value
                                  : "",
                          keyboardType: TextInputType.number,
                          label: "Quantity Wasted",
                          onChanged:
                              dailySiteDataFormCubit.quantityWastedChanged,
                          errorMessage: quantityUsedField.errorMessage,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: CustomDropdown(
                          onSelected: (dynamic value) => {
                            dailySiteDataFormCubit.unitChanged(value),
                          },
                          dropdownMenuEntries: UnitOfMeasure.values
                              .map((e) => DropdownMenuEntry<UnitOfMeasure>(
                                  label: e.name.toString() ?? "1", value: e))
                              .toList()
                              .sublist(0, UnitOfMeasure.values.length - 1),
                          enableFilter: false,
                          errorMessage: unitDropdown.errorMessage,
                          label: 'Unit Measure',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      dailySiteDataFormCubit.submit();
                      // if (dailySiteDataFormCubit.state.isValid) {
                      //   if (widget.isEdit) {
                      //     final updated = DailySiteDataEnitity(
                      //       id: state.dailySiteDatas[widget.index].id,
                      //       // material: state.warehouseProducts?.firstWhere(
                      //       //     (element) =>
                      //       //         element.productVariant.id ==
                      //       //         materialDropdown.value),
                      //       // useType: useTypeDropdown.value,
                      //       // subStructureDescription:
                      //       //     unitOfMeastureDropdown.value,
                      //       // superStructureDescription:
                      //       //     superStructureUseDropdown.value,
                      //       // quantity: double.parse(quantityUsedField.value),
                      //       // remark: taskNameField.value,

                      //     );

                      //     BlocProvider.of<DailySiteDataLocalBloc>(context).add(
                      //         EditDailySiteDataMaterialLocal(
                      //             updated, widget.index));
                      //   } else {
                      //     BlocProvider.of<DailySiteDataLocalBloc>(context).add(
                      //       AddDailySiteDataMaterialLocal(
                      //         DailySiteDataEnitity(
                      //           material: state.warehouseProducts?.firstWhere(
                      //               (element) =>
                      //                   element.productVariant.id ==
                      //                   materialDropdown.value),
                      //           useType: useTypeDropdown.value,
                      //           subStructureDescription:
                      //               unitOfMeastureDropdown.value,
                      //           superStructureDescription:
                      //               superStructureUseDropdown.value,
                      //           quantity: double.parse(quantityUsedField.value),
                      //           remark: taskNameField.value,
                      //         ),
                      //       ),
                      //     );
                      //   }
                      // Navigator.pop(context);
                      // }
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
          );
        },
      ),
    );
  }
}

enum QuanityUsedValidationError { empty, notNumber, greaterThanMax }

class QuantityUsedField extends FormzInput<String, QuanityUsedValidationError> {
  const QuantityUsedField.pure({
    String value = "",
  }) : super.pure(value);

  const QuantityUsedField.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == QuanityUsedValidationError.empty) {
      return 'This field is required';
    }
    if (displayError == QuanityUsedValidationError.notNumber) {
      return 'Quantity must be a number';
    }
    if (displayError == QuanityUsedValidationError.greaterThanMax) {
      return 'Quantity cannot be greater than the quantity in stock';
    }
    return null;
  }

  @override
  QuanityUsedValidationError? validator(String value) {
    if (value.isEmpty) {
      return QuanityUsedValidationError.empty;
    } else if (double.tryParse(value) == null) {
      return QuanityUsedValidationError.notNumber;
    }
    return null;
  }
}

enum QuanityWastedValidationError { empty, notNumber, greaterThanMax }

class QuantityWastedField
    extends FormzInput<String, QuanityWastedValidationError> {
  const QuantityWastedField.pure({
    String value = "",
  }) : super.pure(value);

  const QuantityWastedField.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == QuanityUsedValidationError.empty) {
      return 'This field is required';
    }
    if (displayError == QuanityUsedValidationError.notNumber) {
      return 'Quantity must be a number';
    }
    if (displayError == QuanityUsedValidationError.greaterThanMax) {
      return 'Quantity cannot be greater than the quantity in stock';
    }
    return null;
  }

  @override
  QuanityWastedValidationError? validator(String value) {
    if (value.isEmpty) {
      return QuanityWastedValidationError.empty;
    } else if (double.tryParse(value) == null) {
      return QuanityWastedValidationError.notNumber;
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

enum TaskNameValidationError { invalid }

class TaskNameField extends FormzInput<String, TaskNameValidationError> {
  const TaskNameField.pure([super.value = '']) : super.pure();
  const TaskNameField.dirty([super.value = '']) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == TaskNameValidationError.invalid) {
      return 'Characters cannot exceed 100';
    }

    return null;
  }

  @override
  TaskNameValidationError? validator(String value) {
    if (value.length > 100) {
      return TaskNameValidationError.invalid;
    }
    return null;
  }
}
