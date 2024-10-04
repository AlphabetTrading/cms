import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_issues/material_issue_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_return_local/material_return_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_return_form/material_return_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/common/form_info_item.dart';
import 'package:cms_mobile/features/products/presentation/utils/unit_of_measure.dart';
import 'package:cms_mobile/features/warehouse/presentation/bloc/warehouse/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class CreateMaterialReturnForm extends StatefulWidget {
  final bool isEdit;
  final int index;

  CreateMaterialReturnForm({
    super.key,
    this.isEdit = false,
    this.index = -1,
  });

  @override
  State<CreateMaterialReturnForm> createState() =>
      _CreateMaterialReturnFormState();
}

class _CreateMaterialReturnFormState extends State<CreateMaterialReturnForm> {
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
    final materialReturnFormCubit = context.watch<MaterialReturnFormCubit>();
    final quantityField = materialReturnFormCubit.state.quantityField;
    final materialIssueDropdown =
        materialReturnFormCubit.state.materialIssueDropdown;

    final materialDropdown = materialReturnFormCubit.state.materialDropdown;
    // final warehouseDropdown = materialReturnFormCubit.state.warehouseDropdown;
    // final unitDropdown = materialReturnFormCubit.state.unitDropdown;
    final remarkField = materialReturnFormCubit.state.remarkField;

    // Build a Form widget using the _formKey created above.
    return Form(
      child: BlocBuilder<WarehouseBloc, WarehouseState>(
        builder: (warehouseContext, warehouseState) {
          return BlocBuilder<MaterialIssueBloc, MaterialIssueState>(
            builder: (context, state) {
              List<MaterialIssueEntity>? materialIssues =
                  state.materialIssues?.items;
              MaterialIssueEntity? selectedMaterialIssue =
                  materialIssueDropdown.value != ""
                      ? materialIssues?.firstWhere((element) =>
                          element.id == materialIssueDropdown.value)
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
                      materialReturnFormCubit.materialIssueChanged(value);
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
                    errorMessage: materialIssueDropdown.errorMessage,
                    label: 'Material Issue',
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
                      materialReturnFormCubit.materialChanged(value);
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
                          title: "Issued From",
                          value:
                              selectedMaterialIssue?.warehouseStore?.name ?? "N/A"),
                      FormInfoItem(
                          title: "Unit Cost",
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
                              double.tryParse(quantityField.value) != null
                                  ? quantityField.value
                                  : "",
                          keyboardType: TextInputType.number,
                          label: "Quantity (in unit)",
                          onChanged: materialReturnFormCubit.quantityChanged,
                          errorMessage: quantityField.errorMessage,
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
                    onChanged: materialReturnFormCubit.remarkChanged,
                    errorMessage: remarkField.errorMessage,
                  ),
                  const SizedBox(
                    height: 10,
                  ), //
                  ElevatedButton(
                    onPressed: () {
                      materialReturnFormCubit.onSubmit();
                      if (materialReturnFormCubit.state.isValid) {
                        if (widget.isEdit) {
                          final updated = MaterialReturnMaterialEntity(
                            material: selectedMaterial,
                            issueVoucherId: selectedMaterialIssue?.id ?? "",
                            quantity: double.parse(quantityField.value),
                            remark: remarkField.value,
                          );

                          BlocProvider.of<MaterialReturnLocalBloc>(context).add(
                              EditMaterialReturnMaterialLocal(
                                  updated, widget.index));
                        } else {
                          BlocProvider.of<MaterialReturnLocalBloc>(context).add(
                            AddMaterialReturnMaterialLocal(
                              MaterialReturnMaterialEntity(
                                material: selectedMaterial,
                                issueVoucherId: selectedMaterialIssue?.id ?? "",
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
  final double issuedQuantity;
  const QuantityField.pure({
    String value = "",
    this.issuedQuantity = 0.0,
  }) : super.pure(value);

  const QuantityField.dirty(
    String value, {
    required this.issuedQuantity,
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
      return 'Quantity cannot be greater than the issued quantity';
    }
    return null;
  }

  @override
  QuanityValidationError? validator(String value) {
    if (value.isEmpty) {
      return QuanityValidationError.empty;
    } else if (double.tryParse(value) == null) {
      return QuanityValidationError.notNumber;
    } else if (double.parse(value) > issuedQuantity) {
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

enum MaterialIssueDropdownError { invalid }

class MaterialIssueDropdown
    extends FormzInput<String, MaterialIssueDropdownError> {
  const MaterialIssueDropdown.pure([String value = '']) : super.pure(value);
  const MaterialIssueDropdown.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == MaterialIssueDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  MaterialIssueDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return MaterialIssueDropdownError.invalid;
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
