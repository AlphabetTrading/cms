import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_issues/material_issue_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_receive_local/material_receive_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_receive_form/material_receive_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/common/form_info_item.dart';
import 'package:cms_mobile/features/products/presentation/utils/unit_of_measure.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class CreateMaterialReceiveForm extends StatefulWidget {
  final bool isEdit;
  final int index;

  CreateMaterialReceiveForm({
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
    context.read<MaterialIssueBloc>().add(
          GetMaterialIssues(
            filterMaterialIssueInput: FilterMaterialIssueInput(),
            orderBy: OrderByMaterialIssueInput(createdAt: "desc"),
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

    // Build a Form widget using the _formKey created above.
    return Form(
      child: BlocBuilder<WarehouseBloc, WarehouseState>(
        builder: (warehouseContext, warehouseState) {
          return BlocBuilder<MaterialIssueBloc, MaterialIssueState>(
            builder: (context, state) {
              List<MaterialIssueEntity>? materialIssues =
                  state.materialIssues?.items;
              MaterialIssueEntity? selectedMaterialIssue =
                  purchaseOrderDropdown.value != ""
                      ? materialIssues?.firstWhere((element) =>
                          element.id == purchaseOrderDropdown.value)
                      : null;

              List<IssueVoucherMaterialEntity>? materials =
                  selectedMaterialIssue?.items;

              IssueVoucherMaterialEntity? selectedMaterial =
                  materialDropdown.value != ""
                      ? materials?.firstWhere((element) =>
                          element.productVariant?.id == materialDropdown.value)
                      : null;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDropdown(
                    initialSelection: selectedMaterialIssue,
                    onSelected: (dynamic value) {
                      materialReceiveFormCubit.purchaseOrderChanged(value);
                      myController.text = "";
                      // context
                      //     .read<MaterialIssueDetailsCubit>()
                      //     .onGetMaterialIssueDetails(materialIssueId: value);
                    },
                    dropdownMenuEntries: materialIssues != null
                        ? materialIssues
                            .map((e) => DropdownMenuEntry<MaterialIssueEntity>(
                                label: e.serialNumber ?? e.id ?? "N/A",
                                value: e))
                            .toList()
                        : [],
                    enableFilter: false,
                    errorMessage: purchaseOrderDropdown.errorMessage,
                    label: 'Purchase Order',
                    trailingIcon: state is MaterialIssuesLoading
                        ? const CircularProgressIndicator()
                        : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //material issue materials
                  CustomDropdown(
                    initialSelection: selectedMaterial,
                    onSelected: (dynamic value) {
                      materialReceiveFormCubit.materialChanged(value);
                    },
                    controller: myController,
                    dropdownMenuEntries: materials
                            ?.map((e) => DropdownMenuEntry<
                                    IssueVoucherMaterialEntity>(
                                label:
                                    "${e.productVariant?.product?.name} - ${e.productVariant?.variant}",
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
                          value: unitOfMeasureDisplay(
                              selectedMaterial?.productVariant?.unitOfMeasure)),
                      FormInfoItem(
                          title: "Quantity Issued",
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
                          value: selectedMaterialIssue?.warehouseStore?.name ??
                              "N/A"),
                      FormInfoItem(
                          title: "Total Quantity Purchased",
                          value:
                              selectedMaterial?.unitCost.toString() ?? "N/A"),
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
                          // final updated = MaterialReceiveMaterialEntity(
                          //   material: selectedMaterial,
                          //   purchaseOrderId: selectedMaterialIssue?.id ?? "",
                          //   transportationCost:
                          //       double.parse(transportationField.value),
                          //   loadingCost: double.parse(loadingField.value),
                          //   unloadingCost: double.parse(unloadingField.value),
                          //   remark: remarkField.value,
                          // );

                          // BlocProvider.of<MaterialReceiveLocalBloc>(context)
                          //     .add(EditMaterialReceiveMaterialLocal(
                          // updated, widget.index));
                        } else {
                          // BlocProvider.of<MaterialReceiveLocalBloc>(context)
                          //     .add(
                          //   AddMaterialReceiveMaterialLocal(
                          //     MaterialReceiveMaterialEntity(
                          //       material: selectedMaterial,
                          //       purchaseOrderId:
                          //           selectedMaterialIssue?.id ?? "",
                          //       transportationCost:
                          //           double.parse(transportationField.value),
                          //       loadingCost: double.parse(loadingField.value),
                          //       unloadingCost:
                          //           double.parse(unloadingField.value),
                          //       remark: remarkField.value,
                          //     ),
                          //   ),
                          // );
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
