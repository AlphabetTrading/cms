import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_issue_form/material_issue_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/purchase_order_form/purchase_order_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_state.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class CreatePurchaseOrderForm extends StatefulWidget {
  final bool isEdit;
  final int index;

  CreatePurchaseOrderForm({
    super.key,
    this.isEdit = false,
    this.index = -1,
  });

  @override
  State<CreatePurchaseOrderForm> createState() =>
      _CreatePurchaseOrderFormState();
}

class _CreatePurchaseOrderFormState extends State<CreatePurchaseOrderForm> {
  @override
  Widget build(BuildContext context) {
    final purchaseOrderFormCubit = context.watch<PurchaseOrderFormCubit>();
    final quantityField = purchaseOrderFormCubit.state.quantityField;
    final materialDropdown = purchaseOrderFormCubit.state.materialDropdown;
    // final warehouseDropdown = purchaseOrderFormCubit.state.warehouseDropdown;
    final useTypeDropdown = purchaseOrderFormCubit.state.useTypeDropdown;
    final subStructureUseDropdown =
        purchaseOrderFormCubit.state.subStructureUseDropdown;
    final superStructureUseDropdown =
        purchaseOrderFormCubit.state.superStructureUseDropdown;

    // final unitDropdown = purchaseOrderFormCubit.state.unitDropdown;
    final remarkField = purchaseOrderFormCubit.state.remarkField;

    // Build a Form widget using the _formKey created above.
    return Form(
      child: BlocBuilder<WarehouseBloc, WarehouseState>(
        builder: (warehouseContext, warehouseState) {
          return BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  state.warehouseProducts == null ||
                          state.warehouseProducts!.isEmpty
                      ? Text(
                          "Please select a warehouse first",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.error),
                        )
                      : const SizedBox(),
                  CustomDropdown(
                    initialSelection: materialDropdown.value != ""
                        ? state.warehouseProducts?.firstWhere((element) =>
                            element.productVariant.id == materialDropdown.value)
                        : null,
                    onSelected: (dynamic value) {
                      purchaseOrderFormCubit.materialChanged(value);
                    },
                    dropdownMenuEntries: state.warehouseProducts
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
                    // label: "Material"
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Unit",
                                style: Theme.of(context).textTheme.labelMedium),
                            materialDropdown.value != ""
                                ? Text(state.warehouseProducts
                                        ?.firstWhere((element) =>
                                            element.productVariant.id ==
                                            materialDropdown.value)
                                        .productVariant
                                        .unitOfMeasure
                                        ?.name ??
                                    "N/A")
                                : Text("N/A")
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("In Stock",
                                style: Theme.of(context).textTheme.labelMedium),
                            materialDropdown.value != ""
                                ? Text(state.warehouseProducts
                                        ?.firstWhere((element) =>
                                            element.productVariant.id ==
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
                          initialValue:
                              double.tryParse(quantityField.value) != null
                                  ? quantityField.value
                                  : "",
                          keyboardType: TextInputType.number,
                          label: "Quantity (in unit)",
                          onChanged: purchaseOrderFormCubit.quantityChanged,
                          errorMessage: quantityField.errorMessage,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  CustomDropdown(
                    initialSelection: useTypeDropdown.value,
                    onSelected: (dynamic value) =>
                        purchaseOrderFormCubit.useTypeChanged(value),
                    dropdownMenuEntries: UseType.values
                        .map((e) => DropdownMenuEntry<UseType>(
                            label: useTypeDisplay[e] ?? "", value: e))
                        .toList()
                        .sublist(0, UseType.values.length - 1),
                    enableFilter: false,
                    errorMessage: useTypeDropdown.errorMessage,
                    label: 'Use Type',
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  useTypeDropdown.value == UseType.SUB_STRUCTURE
                      ? CustomDropdown(
                          initialSelection: subStructureUseDropdown.value !=
                                  SubStructureUseDescription.DEFAULT_VALUE
                              ? SubStructureUseDescription.values.firstWhere(
                                  (element) =>
                                      element == subStructureUseDropdown.value)
                              : null,
                          onSelected: (dynamic value) => purchaseOrderFormCubit
                              .subStructureDescriptionChanged(value),
                          dropdownMenuEntries: SubStructureUseDescription.values
                              .map((e) => DropdownMenuEntry<
                                      SubStructureUseDescription>(
                                  label: subStructureUseDescriptionDisplay[e] ??
                                      "",
                                  value: e))
                              .toList()
                              .sublist(0,
                                  SubStructureUseDescription.values.length - 1),
                          enableFilter: false,
                          errorMessage: subStructureUseDropdown.errorMessage,
                          label: 'Use Description',
                        )
                      : CustomDropdown(
                          initialSelection: superStructureUseDropdown.value !=
                                  SuperStructureUseDescription.DEFAULT_VALUE
                              ? SuperStructureUseDescription.values.firstWhere(
                                  (element) =>
                                      element ==
                                      superStructureUseDropdown.value)
                              : null,
                          onSelected: (dynamic value) => purchaseOrderFormCubit
                              .superStructureDescriptionChanged(value),
                          dropdownMenuEntries: SuperStructureUseDescription
                              .values
                              .map((e) => DropdownMenuEntry<
                                      SuperStructureUseDescription>(
                                  label:
                                      superStructureUseDescriptionDisplay[e] ??
                                          "",
                                  value: e))
                              .toList()
                              .sublist(
                                  0,
                                  SuperStructureUseDescription.values.length -
                                      1),
                          enableFilter: false,
                          errorMessage: superStructureUseDropdown.errorMessage,
                          label: 'Use Description',
                        ),
                  const SizedBox(
                    height: 10,
                  ),

                  CustomTextFormField(
                    initialValue: remarkField.value,
                    label: "Remark",
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    onChanged: purchaseOrderFormCubit.remarkChanged,
                    errorMessage: remarkField.errorMessage,
                  ),
                  const SizedBox(
                    height: 10,
                  ), //
                  ElevatedButton(
                    onPressed: () {
                      purchaseOrderFormCubit.onSubmit();
                      if (purchaseOrderFormCubit.state.isValid) {
                        if (widget.isEdit) {
                          final updated = PurchaseOrderMaterialEntity(
                            material: state.warehouseProducts?.firstWhere(
                                (element) =>
                                    element.productVariant.id ==
                                    materialDropdown.value),
                            useType: useTypeDropdown.value,
                            subStructureDescription:
                                subStructureUseDropdown.value,
                            superStructureDescription:
                                superStructureUseDropdown.value,
                            quantity: double.parse(quantityField.value),
                            remark: remarkField.value,
                          );

                          BlocProvider.of<PurchaseOrderLocalBloc>(context).add(
                              EditPurchaseOrderMaterialLocal(
                                  updated, widget.index));
                        } else {
                          BlocProvider.of<PurchaseOrderLocalBloc>(context).add(
                            AddPurchaseOrderMaterialLocal(
                              PurchaseOrderMaterialEntity(
                                material: state.warehouseProducts?.firstWhere(
                                    (element) =>
                                        element.productVariant.id ==
                                        materialDropdown.value),
                                useType: useTypeDropdown.value,
                                subStructureDescription:
                                    subStructureUseDropdown.value,
                                superStructureDescription:
                                    superStructureUseDropdown.value,
                                quantity: double.parse(quantityField.value),
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
          );
        },
      ),
    );
  }
}

enum QuanityValidationError { empty, notNumber, greaterThanMax }

class QuantityField extends FormzInput<String, QuanityValidationError> {
  final double inStock;
  const QuantityField.pure({
    String value = "",
    this.inStock = 0,
  }) : super.pure(value);

  const QuantityField.dirty(
    String value, {
    required this.inStock,
  }) : super.dirty(value);

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
    } else if (double.parse(value) > inStock) {
      return QuanityValidationError.greaterThanMax;
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

enum UseTypeDropdownError { invalid }

class UseTypeDropdown extends FormzInput<UseType, UseTypeDropdownError> {
  const UseTypeDropdown.pure([UseType value = UseType.DEFAULT_VALUE])
      : super.pure(value);
  const UseTypeDropdown.dirty([UseType value = UseType.DEFAULT_VALUE])
      : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == UseTypeDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  UseTypeDropdownError? validator(UseType? value) {
    if (value == UseType.DEFAULT_VALUE) {
      return UseTypeDropdownError.invalid;
    }
    return null;
  }
}

enum SubStructureUseDropdownError { invalid }

class SubStructureUseDropdown extends FormzInput<SubStructureUseDescription,
    SubStructureUseDropdownError> {
  final UseType? useType;
  const SubStructureUseDropdown.pure(
      {SubStructureUseDescription value =
          SubStructureUseDescription.DEFAULT_VALUE,
      this.useType})
      : super.pure(value);
  const SubStructureUseDropdown.dirty(SubStructureUseDescription value,
      {required this.useType})
      : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == SubStructureUseDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  SubStructureUseDropdownError? validator(SubStructureUseDescription? value) {
    if (value == SubStructureUseDescription.DEFAULT_VALUE &&
        useType == UseType.SUB_STRUCTURE) {
      return SubStructureUseDropdownError.invalid;
    }
    return null;
  }
}

enum SuperStructureUseDropdownError { invalid }

class SuperStructureUseDropdown extends FormzInput<SuperStructureUseDescription,
    SuperStructureUseDropdownError> {
  final UseType? useType;

  const SuperStructureUseDropdown.pure(
      {SuperStructureUseDescription value =
          SuperStructureUseDescription.DEFAULT_VALUE,
      this.useType})
      : super.pure(value);
  const SuperStructureUseDropdown.dirty(SuperStructureUseDescription value,
      {required this.useType})
      : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == SuperStructureUseDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  SuperStructureUseDropdownError? validator(
      SuperStructureUseDescription? value) {
    if (value == SuperStructureUseDescription.DEFAULT_VALUE &&
        useType == UseType.SUPER_STRUCTURE) {
      return SuperStructureUseDropdownError.invalid;
    }
    return null;
  }
}

// enum UnitDropdownError { invalid }

// class UnitDropdown extends FormzInput<String, UnitDropdownError> {
//   const UnitDropdown.pure([String value = '']) : super.pure(value);
//   const UnitDropdown.dirty([String value = '']) : super.dirty(value);

//   String? get errorMessage {
//     if (isValid || isPure) return null;

//     if (displayError == UnitDropdownError.invalid) {
//       return 'This field is required';
//     }
//     return null;
//   }

//   @override
//   UnitDropdownError? validator(String? value) {
//     if (value?.isEmpty ?? true) {
//       return UnitDropdownError.invalid;
//     }
//     return null;
//   }
// }

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
