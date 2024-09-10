import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/purchase_order_form/purchase_order_form_cubit.dart';

import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_state.dart';
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
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context)
        .add(const GetAllWarehouseProducts(""));
  }

  @override
  Widget build(BuildContext context) {
    final purchaseOrderFormCubit = context.watch<PurchaseOrderFormCubit>();

    final unitPriceField = purchaseOrderFormCubit.state.unitPriceField;
    final materialRequestDropdown =
        purchaseOrderFormCubit.state.materialRequestDropdown;
    final materialRequestItemDropdown =
        purchaseOrderFormCubit.state.materialRequestItemDropdown;
    final proformaDropdown = purchaseOrderFormCubit.state.proformaDropdown;
    final remarkField = purchaseOrderFormCubit.state.remarkField;

    return Container();
    // Build a Form widget using the _formKey created above.
    // return Form(
    //   child: BlocBuilder<ProductBloc, ProductState>(
    //     builder: (context, state) {
    //       return Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           CustomDropdown(
    //             initialSelection: materialDropdown.value != ""
    //                 ? state.allWarehouseProducts?.firstWhere((element) =>
    //                     element.productVariant.id == materialDropdown.value)
    //                 : null,
    //             onSelected: (dynamic value) =>
    //                 purchaseOrderFormCubit.materialChanged(value),
    //             dropdownMenuEntries: state.allWarehouseProducts
    //                     ?.map((e) => DropdownMenuEntry<WarehouseProductEntity>(
    //                         label:
    //                             '${e.productVariant.product!.name} - ${e.productVariant.variant}',
    //                         value: e))
    //                     .toList() ??
    //                 [],
    //             enableFilter: false,
    //             errorMessage: materialDropdown.errorMessage, label: 'Material',
    //             trailingIcon: state is AllWarehouseProductsLoading
    //                 ? const CircularProgressIndicator()
    //                 : null,
    //             // label: "Material"
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ), // SizedBox(height: 10,
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             children: [
    //               Flexible(
    //                 child: Column(
    //                   children: [
    //                     Text("Unit",
    //                         style: Theme.of(context).textTheme.labelMedium),
    //                     materialDropdown.value != ""
    //                         ? Text(state.allWarehouseProducts
    //                                 ?.firstWhere((element) =>
    //                                     element.productVariant.id ==
    //                                     materialDropdown.value)
    //                                 .productVariant
    //                                 .unitOfMeasure
    //                                 ?.name ??
    //                             "N/A")
    //                         : Text("N/A")
    //                   ],
    //                 ),
    //               ),
    //               Flexible(
    //                 child: Column(
    //                   children: [
    //                     Text("In Stock",
    //                         style: Theme.of(context).textTheme.labelMedium),
    //                     materialDropdown.value != ""
    //                         ? Text(state.allWarehouseProducts
    //                                 ?.firstWhere((element) =>
    //                                     element.productVariant.id ==
    //                                     materialDropdown.value)
    //                                 .quantity
    //                                 .toString() ??
    //                             "N/A")
    //                         : Text("N/A")
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),

    //           Row(
    //             children: [
    //               Flexible(
    //                 child: CustomTextFormField(
    //                   initialValue:
    //                       double.tryParse(unitPriceField.value) != null
    //                           ? unitPriceField.value
    //                           : "",
    //                   keyboardType: TextInputType.number,
    //                   label: "Requested Quantity (in unit)",
    //                   onChanged: purchaseOrderFormCubit.quantityChanged,
    //                   errorMessage: unitPriceField.errorMessage,
    //                 ),
    //               ),
    //               const SizedBox(
    //                 width: 10,
    //               ),
    //               Column(
    //                 children: [
    //                   Text("To be purchased",
    //                       style: Theme.of(context).textTheme.labelMedium),
    //                   materialDropdown.value != "" &&
    //                           double.tryParse(unitPriceField.value) != null
    //                       ? Text((double.parse(unitPriceField.value) -
    //                               (state.allWarehouseProducts!
    //                                   .firstWhere((element) =>
    //                                       element.productVariant.id ==
    //                                       materialDropdown.value)
    //                                   .quantity))
    //                           .toString())
    //                       : Text("N/A"),
    //                 ],
    //               )
    //             ],
    //           ),

    //           const SizedBox(
    //             height: 10,
    //           ),

    //           CustomTextFormField(
    //             initialValue: remarkField.value,
    //             label: "Remark",
    //             keyboardType: TextInputType.multiline,
    //             maxLines: 3,
    //             onChanged: purchaseOrderFormCubit.remarkChanged,
    //             errorMessage: remarkField.errorMessage,
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ), //
    //           // ElevatedButton(
    //           //   onPressed: () {
    //           //     materialRequestFormCubit.onSubmit();
    //           //     if (materialRequestFormCubit.state.isValid) {
    //           //       if (widget.isEdit) {
    //           //         final updated = PurchaseOrderMaterialEntity(
    //           //           material: state.allWarehouseProducts!.firstWhere(
    //           //               (element) =>
    //           //                   element.productVariant.id ==
    //           //                   materialDropdown.value),
    //           //           // unit: unitDropdown.value,
    //           //           requestedQuantity: double.parse(quantityField.value),
    //           //           remark: remarkField.value,
    //           //         );

    //           //         BlocProvider.of<PurchaseOrderLocalBloc>(context).add(
    //           //             EditPurchaseOrderMaterialLocal(
    //           //                 updated, widget.index));
    //           //       } else {
    //           //         BlocProvider.of<PurchaseOrderLocalBloc>(context).add(
    //           //           AddPurchaseOrderMaterialLocal(
    //           //             PurchaseOrderMaterialEntity(
    //           //               material: state.allWarehouseProducts?.firstWhere(
    //           //                   (element) =>
    //           //                       element.productVariant.id ==
    //           //                       materialDropdown.value),
    //           //               // unit: unitDropdown.value,
    //           //               requestedQuantity:
    //           //                   double.parse(quantityField.value),
    //           //               remark: remarkField.value,
    //           //             ),
    //           //           ),
    //           //         );
    //           //       }
    //           //       Navigator.pop(context);
    //           //     }
    //           //   },
    //           //   style: ElevatedButton.styleFrom(
    //           //     minimumSize: const Size.fromHeight(50),
    //           //   ),
    //           //   child: widget.isEdit
    //           //       ? const Text('Save Changes')
    //           //       : const Text('Add Material'),
    //           // ),
    //         ],
    //       );
    //     },
    //   ),

    // );
  }
}

enum UnitPriceValidationError { empty, notNumber, lessThanMin }

class UnitPriceField extends FormzInput<String, UnitPriceValidationError> {
  const UnitPriceField.pure([String value = '', this.unitPrice = 0])
      : super.pure(value);
  const UnitPriceField.dirty(String value, {required this.unitPrice})
      : super.dirty(value);

  final double unitPrice;

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (isValid || isPure) return null;

    if (displayError == UnitPriceValidationError.empty) {
      return 'This field is required';
    }
    if (displayError == UnitPriceValidationError.notNumber) {
      return 'Unit Price must be a number';
    }

    return null;
  }

  @override
  UnitPriceValidationError? validator(String value) {
    if (value.isEmpty) {
      return UnitPriceValidationError.empty;
    } else if (double.tryParse(value) == null) {
      return UnitPriceValidationError.notNumber;
    }
    return null;
  }
}

enum MaterialRequestDropdownError { invalid }

class MaterialRequestDropdown
    extends FormzInput<String, MaterialRequestDropdownError> {
  const MaterialRequestDropdown.pure([String value = '']) : super.pure(value);
  const MaterialRequestDropdown.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == MaterialRequestDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  MaterialRequestDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return MaterialRequestDropdownError.invalid;
    }

    return null;
  }
}

enum MaterialRequestItemDropdownError { invalid }

class MaterialRequestItemDropdown
    extends FormzInput<String, MaterialRequestItemDropdownError> {
  const MaterialRequestItemDropdown.pure([String value = ''])
      : super.pure(value);
  const MaterialRequestItemDropdown.dirty([String value = ''])
      : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == MaterialRequestItemDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  MaterialRequestItemDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return MaterialRequestItemDropdownError.invalid;
    }

    return null;
  }
}

enum ProformaDropdownError { invalid }

class ProformaDropdown extends FormzInput<String, ProformaDropdownError> {
  const ProformaDropdown.pure([String value = '']) : super.pure(value);
  const ProformaDropdown.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == ProformaDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  ProformaDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return ProformaDropdownError.invalid;
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

enum VendorValidationError { empty, invalid }

class VendorField extends FormzInput<String, VendorValidationError> {
  const VendorField.pure([String value = '']) : super.pure(value);
  const VendorField.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == VendorValidationError.empty) {
      return 'Vendor can\'t be empty!';
    }

    if (displayError == VendorValidationError.invalid) {
      return 'Characters cannot exceed 100';
    }

    return null;
  }

  @override
  VendorValidationError? validator(String value) {
    if (value.length > 100) {
      return VendorValidationError.invalid;
    }
    return null;
  }
}
