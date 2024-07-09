import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/proforma_form/proforma_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/common/form_info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ProformaFrom extends StatefulWidget {
  final bool isEdit;
  final int index;

  ProformaFrom({
    super.key,
    this.isEdit = false,
    this.index = -1,
  });

  @override
  State<ProformaFrom> createState() => _ProformaFromState();
}

class _ProformaFromState extends State<ProformaFrom> {
  final myController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // context.read<MaterialIssueBloc>().add(
    //       GetMaterialIssues(
    //         filterMaterialIssueInput: FilterMaterialIssueInput(),
    //         orderBy: OrderByMaterialIssueInput(createdAt: "desc"),
    //         paginationInput: PaginationInput(skip: 0, take: 20),
    //       ),
    //     );
    // myController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    final text = myController.text;
    print('Second text field: $text (${text.characters.length})');
  }

  @override
  Widget build(BuildContext context) {
    final proformaItemFormCubit = context.watch<ProformaItemFormCubit>();
    final priceField = proformaItemFormCubit.state.priceField;
    final vendorField = proformaItemFormCubit.state.vendorField;
    final remarkField = proformaItemFormCubit.state.remarkField;
    final photoField = proformaItemFormCubit.state.photoField;

    // Build a Form widget using the _formKey created above.
    return Form(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          initialValue: vendorField.value,
          label: "Vendor Name",
          onChanged: proformaItemFormCubit.vendorChanged,
          errorMessage: vendorField.errorMessage,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormInfoItem(title: "Quantity Requested", value: "N/A"),
            FormInfoItem(title: "Unit", value: "N/A"),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
              child: CustomTextFormField(
                initialValue: double.tryParse(priceField.value) != null
                    ? priceField.value
                    : "",
                keyboardType: TextInputType.number,
                label: "Price Per Unit",
                onChanged: proformaItemFormCubit.priceChanged,
                errorMessage: priceField.errorMessage,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            FormInfoItem(title: "Total Price", value: "N/A"),
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
          onChanged: proformaItemFormCubit.remarkChanged,
          errorMessage: remarkField.errorMessage,
        ),
        const SizedBox(
          height: 10,
        ), //
        ElevatedButton(
          onPressed: () {
            // priceField.onSubmit();
            // if (priceField.state.isValid) {
            //   if (widget.isEdit) {
            //     final updated = MaterialReturnMaterialEntity(
            //       material: selectedMaterial,
            //       issueVoucherId: selectedMaterialIssue?.id ?? "",
            //       quantity: double.parse(quantityField.value),
            //       remark: remarkField.value,
            //     );

            //     BlocProvider.of<MaterialReturnLocalBloc>(context).add(
            //         EditMaterialReturnMaterialLocal(updated, widget.index));
            //   } else {
            //     BlocProvider.of<MaterialReturnLocalBloc>(context).add(
            //       AddMaterialReturnMaterialLocal(
            //         MaterialReturnMaterialEntity(
            //           material: selectedMaterial,
            //           issueVoucherId: selectedMaterialIssue?.id ?? "",
            //           quantity: double.parse(quantityField.value),
            //           remark: remarkField.value,
            //         ),
            //       ),
            //     );
            //   }
            //   Navigator.pop(context);
            // }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: widget.isEdit
              ? const Text('Save Changes')
              : const Text('Add Proforma Item'),
        ),
      ],
    ));
  }
}

enum PriceValidationError { empty, notNumber, lessThanZero }

class PriceField extends FormzInput<String, PriceValidationError> {
  const PriceField.pure([
    String value = "",
  ]) : super.pure(value);

  const PriceField.dirty([String value = ""]) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PriceValidationError.empty) {
      return 'This field is required';
    }
    if (displayError == PriceValidationError.notNumber) {
      return 'Price must be a number';
    }
    if (displayError == PriceValidationError.lessThanZero) {
      return 'Price cannot be less than zero';
    }
    return null;
  }

  @override
  PriceValidationError? validator(String value) {
    if (value.isEmpty) {
      return PriceValidationError.empty;
    } else if (double.tryParse(value) == null) {
      return PriceValidationError.notNumber;
    } else if (double.parse(value) < 0) {
      return PriceValidationError.lessThanZero;
    }
    return null;
  }
}

enum VendorFieldError { invalid }

class VendorField extends FormzInput<String, VendorFieldError> {
  const VendorField.pure([String value = '']) : super.pure(value);
  const VendorField.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == VendorFieldError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  VendorFieldError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return VendorFieldError.invalid;
    }
    return null;
  }
}

enum PhotoFieldError { invalid }

class PhotoField extends FormzInput<String, PhotoFieldError> {
  const PhotoField.pure([String value = '']) : super.pure(value);
  const PhotoField.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PhotoFieldError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  PhotoFieldError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return PhotoFieldError.invalid;
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
