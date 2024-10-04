import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/daily_site_data_form/daily_site_data_add_material_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/daily_site_data_form/daily_site_data_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_request_form/material_request_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/daily_site_data/add_material_form.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_state.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class CreateDailySiteDataForm extends StatefulWidget {
  final bool isEdit;
  final int index;

  const CreateDailySiteDataForm({
    super.key,
    this.isEdit = false,
    this.index = -1,
  });

  @override
  State<CreateDailySiteDataForm> createState() =>
      _CreateDailySiteDataFormState();
}

class _CreateDailySiteDataFormState extends State<CreateDailySiteDataForm> {
  @override
  Widget build(BuildContext context) {
    final dailySiteDataFormCubit = context.watch<DailySiteDataFormCubit>();
    // final materialDropdown = dailySiteDataFormCubit.state.materialDropdown;
    final unitDropdown = dailySiteDataFormCubit.state.unitDropdown;
    final quantityField = dailySiteDataFormCubit.state.quantityField;
    final taskNameField = dailySiteDataFormCubit.state.taskNameField;

    // Build a Form widget using the _formKey created above.
    return Form(
      child: BlocBuilder<WarehouseBloc, WarehouseState>(
        builder: (warehouseContext, warehouseState) {
          return BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              debugPrint('ProductBloc state: $state');

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      initialValue: taskNameField.value,
                      label: "Task Name",
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      onChanged: dailySiteDataFormCubit.taskNameChanged,
                      errorMessage: taskNameField.errorMessage,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: CustomTextFormField(
                            initialValue:
                                double.tryParse(quantityField.value) != null
                                    ? quantityField.value
                                    : "",
                            keyboardType: TextInputType.number,
                            label: "Executed Quantity",
                            onChanged: dailySiteDataFormCubit.quantityChanged,
                            errorMessage: quantityField.errorMessage,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: CustomDropdown(
                            onSelected: (dynamic value) => {
                              dailySiteDataFormCubit.unitChanged(value),
                            },
                            dropdownMenuEntries: UnitOfMeasure.values
                                .map((e) => DropdownMenuEntry<UnitOfMeasure>(
                                    label: e.name ?? "", value: e))
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
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Labor",
                                style: Theme.of(context).textTheme.labelMedium),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("Add Labor",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 200,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return _buildLaborListItem(context, {});
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Material",
                                style: Theme.of(context).textTheme.labelMedium),
                            ElevatedButton(
                              onPressed: () => showModalBottomSheet(
                                context: context,
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider<DailySiteDataFormCubit>(
                                      create: (_) => DailySiteDataFormCubit(),
                                    ),
                                    BlocProvider(
                                      create: (context) =>
                                          DailySiteDataAddMaterialFormCubit(),
                                    ),
                                  ],
                                  child: const Padding(
                                    padding: EdgeInsets.all(32.0),
                                    child: Wrap(children: [AddMaterialForm()]),
                                  ),
                                ),
                              ),
                              child: Text(
                                "Add Material",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 200,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return _buildMaterialListItem(context, {});
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        dailySiteDataFormCubit.onSubmit();
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
                        //       // quantity: double.parse(quantityField.value),
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
                        //           quantity: double.parse(quantityField.value),
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
                          : const Text('Add Task'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  _buildLaborListItem(BuildContext context, dynamic dailySiteData) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
        color: const Color(0x110F4A84),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                // dailySiteData?.name ?? 'N/A',
                'N/A',
                style: TextStyle(
                  color: Color(0xFF111416),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              PopupMenuButton(
                color: Theme.of(context).colorScheme.surface,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                      onTap: () {
                        // context.goNamed(RouteNames.dailySiteDataEdit,
                        //     pathParameters: {
                        //       'dailySiteDataId': dailySiteData.id.toString()
                        //     });
                      },
                      child: const ListTile(
                        leading: Icon(Icons.edit, color: Colors.blue),
                        title:
                            Text('Edit', style: TextStyle(color: Colors.blue)),
                      )),
                  PopupMenuItem(
                    onTap: () {
                      // context
                      //     .read<DeleteDailySiteDataCubit>()
                      //     .onDailySiteDataDelete(
                      //         dailySiteDataId: dailySiteData.id ?? "");
                    },
                    child: const ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title:
                          Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildMaterialListItem(BuildContext context, dynamic dailySiteData) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
        color: const Color(0x110F4A84),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                // dailySiteData?.name ?? 'N/A',
                'N/A',
                style: TextStyle(
                  color: Color(0xFF111416),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              PopupMenuButton(
                color: Theme.of(context).colorScheme.surface,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                      onTap: () {
                        // context.goNamed(RouteNames.dailySiteDataEdit,
                        //     pathParameters: {
                        //       'dailySiteDataId': dailySiteData.id.toString()
                        //     });
                      },
                      child: const ListTile(
                        leading: Icon(Icons.edit, color: Colors.blue),
                        title:
                            Text('Edit', style: TextStyle(color: Colors.blue)),
                      )),
                  PopupMenuItem(
                    onTap: () {
                      // context
                      //     .read<DeleteDailySiteDataCubit>()
                      //     .onDailySiteDataDelete(
                      //         dailySiteDataId: dailySiteData.id ?? "");
                    },
                    child: const ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title:
                          Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum QuanityValidationError { empty, notNumber, greaterThanMax }

class QuantityField extends FormzInput<String, QuanityValidationError> {
  const QuantityField.pure({
    String value = "",
  }) : super.pure(value);

  const QuantityField.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == QuanityValidationError.empty) {
      return 'This field is required';
    }
    if (displayError == QuanityValidationError.notNumber) {
      return 'Quantity must be a number';
    }
    if (displayError == QuanityValidationError.greaterThanMax) {
      return 'Quantity cannot be greater than the quantity in stock';
    }
    return null;
  }

  @override
  QuanityValidationError? validator(String value) {
    if (value.isEmpty) {
      return QuanityValidationError.empty;
    } else if (double.tryParse(value) == null) {
      return QuanityValidationError.notNumber;
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
