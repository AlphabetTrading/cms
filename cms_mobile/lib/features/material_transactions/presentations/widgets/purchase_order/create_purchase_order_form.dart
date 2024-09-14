import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/purchase_order_form/purchase_order_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/purchase_order_form/purchase_order_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/purchase_order/create_purchase_order_material_request.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/purchase_order/create_purchase_order_proforma.dart';

import 'package:cms_mobile/features/products/presentation/bloc/product_bloc.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
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

    final remarkField = purchaseOrderFormCubit.state.remarkField;

    return BlocBuilder<PurchaseOrderFormCubit, PurchaseOrderFormState>(
        builder: (context, state) {
      return Form(
          child: Column(children: [
        SwitchListTile(
          title: const Text("Toggle to use Proforma/Material Request"),
          value: state.isProforma,
          onChanged: (value) {
            context.read<PurchaseOrderFormCubit>().toggleIsProforma(value);
          },
        ),
        const SizedBox(
          height: 10,
        ),
        state.isProforma
            ? const CreatePurchaseOrderProforma()
            : const CreatePurchaseOrderMaterialRequestForm(),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            purchaseOrderFormCubit.onSubmit();
            if (purchaseOrderFormCubit.state.isValid) {
              final materialRequestItemId = purchaseOrderFormCubit
                  .state.materialRequestItemDropdown.value;
              final proformaId =
                  purchaseOrderFormCubit.state.proformaDropdown.value;

              final updatedMaterialEntity = PurchaseOrderMaterialEntity(
                isProforma: state.isProforma,
                materialRequestItemId: materialRequestItemId,
                materialRequestItem: state.selectedMaterialRequest?.items
                    ?.firstWhere((element) =>
                        element.id ==
                        purchaseOrderFormCubit
                            .state.materialRequestItemDropdown.value),
                proformaId: proformaId,
                quantity: purchaseOrderFormCubit.state.quantity,
                remark: remarkField.value,
                unitPrice: double.tryParse(state.unitPriceField.value) ?? 0,
                totalPrice: purchaseOrderFormCubit.state.totalPrice,
              );

              debugPrint(updatedMaterialEntity.toString());
              debugPrint("updatedMaterialEntity");

              if (widget.isEdit) {
                BlocProvider.of<PurchaseOrderLocalBloc>(context).add(
                    EditPurchaseOrderMaterialLocal(
                        updatedMaterialEntity, widget.index));
              } else {
                BlocProvider.of<PurchaseOrderLocalBloc>(context).add(
                  AddPurchaseOrderMaterialLocal(updatedMaterialEntity),
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
      ]));
    });
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
