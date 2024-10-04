import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_orders/purchase_order_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_receive_form/material_receive_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/common/form_info_item.dart';
import 'package:cms_mobile/features/products/presentation/utils/unit_of_measure.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class CreateMaterialReceiveForm extends StatefulWidget {
  final bool isEdit;
  final int index;

  const CreateMaterialReceiveForm({
    super.key,
    this.isEdit = false,
    this.index = -1,
  });

  @override
  State<CreateMaterialReceiveForm> createState() =>
      _CreateMaterialReceiveFormState();
}

class _CreateMaterialReceiveFormState extends State<CreateMaterialReceiveForm> {
  final myController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<PurchaseOrderBloc>().add(
          GetPurchaseOrdersEvent(
            filterPurchaseOrderInput: FilterPurchaseOrderInput(),
            orderBy: OrderByPurchaseOrderInput(createdAt: "desc"),
            paginationInput: PaginationInput(skip: 0, take: 20),
          ),
        );
    myController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    final text = myController.text;
    print('Second text field: $text (${text.characters.length})');
  }

  @override
  Widget build(BuildContext context) {
    final materialReceiveFormCubit = context.watch<MaterialReceiveFormCubit>();
    final transportationField =
        materialReceiveFormCubit.state.transportationField;
    final loadingField = materialReceiveFormCubit.state.loadingField;
    final unloadingField = materialReceiveFormCubit.state.unloadingField;
    final purchaseOrderDropdown =
        materialReceiveFormCubit.state.purchaseOrderDropdown;

    final materialDropdown = materialReceiveFormCubit.state.materialDropdown;
    // final warehouseDropdown = materialReceiveFormCubit.state.warehouseDropdown;
    // final unitDropdown = materialReceiveFormCubit.state.unitDropdown;
    final remarkField = materialReceiveFormCubit.state.remarkField;
    final receivedQuantityField =
        materialReceiveFormCubit.state.receivedQuantityField;

    // Build a Form widget using the _formKey created above.
    return Form(
      child: BlocBuilder<WarehouseBloc, WarehouseState>(
        builder: (warehouseContext, warehouseState) {
          return BlocBuilder<PurchaseOrderBloc, PurchaseOrderState>(
            builder: (context, state) {
              List<PurchaseOrderEntity>? purchaseOrders =
                  state.purchaseOrders?.items;
              PurchaseOrderEntity? selectedPurchaseOrder =
                  purchaseOrderDropdown.value != ""
                      ? purchaseOrders?.firstWhere((element) =>
                          element.id == purchaseOrderDropdown.value)
                      : null;

              List<PurchaseOrderItemEntity>? materials =
                  selectedPurchaseOrder?.items;

              PurchaseOrderItemEntity? selectedMaterial =
                  materialDropdown.value != ""
                      ? materials?.firstWhereOrNull(
                          (element) => element.id == materialDropdown.value)
                      : null;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDropdown(
                    initialSelection: selectedPurchaseOrder,
                    onSelected: (dynamic value) {
                      materialReceiveFormCubit.purchaseOrderChanged(value);
                      myController.text = "";
                      // context
                      //     .read<PurchaseOrderDetailsCubit>()
                      //     .onGetPurchaseOrderDetails(purchaseOrderId: value);
                    },
                    dropdownMenuEntries: purchaseOrders != null
                        ? purchaseOrders
                            .map((e) => DropdownMenuEntry<PurchaseOrderEntity>(
                                label: e.serialNumber ?? e.id ?? "N/A",
                                value: e))
                            .toList()
                        : [],
                    enableFilter: false,
                    errorMessage: purchaseOrderDropdown.errorMessage,
                    label: 'Purchase Order',
                    trailingIcon: state is PurchaseOrderLoading
                        ? const CircularProgressIndicator()
                        : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  CustomDropdown(
                    initialSelection: selectedMaterial,
                    onSelected: (dynamic value) {
                      materialReceiveFormCubit.materialChanged(value);
                    },
                    controller: myController,
                    dropdownMenuEntries: materials
                            ?.map((e) => DropdownMenuEntry<
                                    PurchaseOrderItemEntity>(
                                label: e.materialRequestItem != null
                                    ? "${e.materialRequestItem?.productVariant?.product?.name} - ${e.materialRequestItem?.productVariant?.variant}"
                                    : "${e.proforma?.materialRequestItem?.productVariant?.product?.name} - ${e.proforma?.materialRequestItem?.productVariant?.variant}",
                                value: e))
                            .toList() ??
                        [],

                    enableFilter: false,
                    errorMessage: materialDropdown.errorMessage,
                    label: 'Material',

                    // label: "Material"
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FormInfoItem(
                          title: "Unit",
                          value: selectedMaterial?.materialRequestItem != null
                              ? unitOfMeasureDisplay(selectedMaterial
                                  ?.materialRequestItem
                                  ?.productVariant
                                  ?.unitOfMeasure)
                              : unitOfMeasureDisplay(selectedMaterial
                                  ?.proforma
                                  ?.materialRequestItem
                                  ?.productVariant
                                  ?.unitOfMeasure)),
                      FormInfoItem(
                          title: "Quantity Purchased",
                          value:
                              selectedMaterial?.quantity?.toString() ?? "N/A"),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      FormInfoItem(
                          title: "Unit Cost",
                          value:
                              selectedMaterial?.unitPrice.toString() ?? "N/A"),
                      FormInfoItem(
                          title: "Total cost",
                          value:
                              selectedMaterial?.totalPrice.toString() ?? "N/A"),
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
                              double.tryParse(loadingField.value) != null
                                  ? loadingField.value
                                  : "",
                          keyboardType: TextInputType.number,
                          label: "Loading Cost",
                          onChanged: materialReceiveFormCubit.loadingChanged,
                          errorMessage: loadingField.errorMessage,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: CustomTextFormField(
                          initialValue:
                              double.tryParse(unloadingField.value) != null
                                  ? unloadingField.value
                                  : "",
                          keyboardType: TextInputType.number,
                          label: "Unloading Cost",
                          onChanged: materialReceiveFormCubit.unloadingChanged,
                          errorMessage: unloadingField.errorMessage,
                        ),
                      ),
                      // FormInfoItem(
                      //     title: "Total Cost(To be returned)", value:(quantityField.value*selectedMaterial?.unitCost).toString()?? "N/A"),
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
                              double.tryParse(transportationField.value) != null
                                  ? transportationField.value
                                  : "",
                          keyboardType: TextInputType.number,
                          label: "Transportation Cost",
                          onChanged:
                              materialReceiveFormCubit.transportationChanged,
                          errorMessage: transportationField.errorMessage,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),

                      Flexible(
                        child: CustomTextFormField(
                          initialValue:
                              double.tryParse(receivedQuantityField.value) !=
                                      null
                                  ? receivedQuantityField.value
                                  : "",
                          keyboardType: TextInputType.number,
                          label: "Received Quantity",
                          onChanged:
                              materialReceiveFormCubit.receivedQuantityChanged,
                          errorMessage: receivedQuantityField.errorMessage,
                        ),
                      ),
                      // FormInfoItem(
                      //     title: "Total Cost(To be returned)", value:(quantityField.value*selectedMaterial?.unitCost).toString()?? "N/A"),
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
                    onChanged: materialReceiveFormCubit.remarkChanged,
                    errorMessage: remarkField.errorMessage,
                  ),
                  const SizedBox(
                    height: 10,
                  ), //
                  ElevatedButton(
                    onPressed: () {
                      materialReceiveFormCubit.onSubmit();
                      if (materialReceiveFormCubit.state.isValid) {
                        if (widget.isEdit) {
                          final updated = MaterialReceiveMaterialEntity(
                            // material: selectedMaterial,
                            receivedQuantity:
                                double.parse(receivedQuantityField.value),
                            purchaseOrderItem: selectedMaterial!,
                            transportationCost:
                                double.parse(transportationField.value),
                            loadingCost: double.parse(loadingField.value),
                            unloadingCost: double.parse(unloadingField.value),
                            remark: remarkField.value,
                          );

                          // BlocProvider.of<MaterialReceiveLocalBloc>(context)
                          //     .add(EditMaterialReceiveMaterialLocal(
                          // updated, widget.index));
                        } else {
                          BlocProvider.of<MaterialReceiveLocalBloc>(context)
                              .add(
                            AddMaterialReceiveMaterialLocal(
                              MaterialReceiveMaterialEntity(
                                receivedQuantity:
                                    double.parse(receivedQuantityField.value),
                                purchaseOrderItem: selectedMaterial!,
                                transportationCost:
                                    double.parse(transportationField.value),
                                loadingCost: double.parse(loadingField.value),
                                unloadingCost:
                                    double.parse(unloadingField.value),
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

enum NumberValidationError { empty, notNumber, greaterThanMax }

class NumberField extends FormzInput<String, NumberValidationError> {
  const NumberField.pure({
    String value = "",
  }) : super.pure(value);

  const NumberField.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == NumberValidationError.empty) {
      return 'This field is required';
    }
    if (displayError == NumberValidationError.notNumber) {
      return 'The value must be a number';
    }
    if (displayError == NumberValidationError.greaterThanMax) {
      return 'The value cannot be less than 0';
    }
    return null;
  }

  @override
  NumberValidationError? validator(String value) {
    if (value.isEmpty) {
      return NumberValidationError.empty;
    } else if (double.tryParse(value) == null) {
      return NumberValidationError.notNumber;
    } else if (double.parse(value) < 0) {
      return NumberValidationError.greaterThanMax;
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

enum PurchaseOrderDropdownError { invalid }

class PurchaseOrderDropdown
    extends FormzInput<String, PurchaseOrderDropdownError> {
  const PurchaseOrderDropdown.pure([String value = '']) : super.pure(value);
  const PurchaseOrderDropdown.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PurchaseOrderDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  PurchaseOrderDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return PurchaseOrderDropdownError.invalid;
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
