import 'dart:io';

import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_proforma_form/material_proforma_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/common/form_info_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/common/modal_error.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class MaterialProformaFrom extends StatefulWidget {
  final bool isEdit;
  final int index;
  final Function(MaterialProformaMaterialEntity) onAddItem;
  final MaterialRequestItem? selectedRequestedMaterial;

  MaterialProformaFrom(
      {super.key,
      this.isEdit = false,
      this.index = -1,
      required this.onAddItem,
      required this.selectedRequestedMaterial});

  @override
  State<MaterialProformaFrom> createState() => _MaterialProformaFromState();
}

class _MaterialProformaFromState extends State<MaterialProformaFrom> {
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

  File? image;
  MultipartFile? multipartFile;

  Future pickImage(
      ImageSource source, MaterialProformaItemFormCubit proformaCubit) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      proformaCubit.photoChanged(image.path);

      final bytes = await image.readAsBytes();
      multipartFile = MultipartFile.fromBytes(
        'photo',
        bytes,
        filename: '${DateTime.now().second}.jpg',
      );

      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final proformaItemFormCubit =
        context.watch<MaterialProformaItemFormCubit>();
    final priceField = proformaItemFormCubit.state.priceField;
    final vendorField = proformaItemFormCubit.state.vendorField;
    final remarkField = proformaItemFormCubit.state.remarkField;
    final photoField = proformaItemFormCubit.state.photoField;
    UnitOfMeasure? unit =
        widget.selectedRequestedMaterial?.productVariant?.unitOfMeasure;
    double? quantity = widget.selectedRequestedMaterial?.quantity;
    double? price = double.tryParse(priceField.value) ?? 0;
    double? totalPrice = quantity != null ? price * quantity : 0;

    // Build a Form widget using the _formKey created above.
    return Form(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (widget.selectedRequestedMaterial == null)
            ? const ModalError(
                errorMessage: "Please select material request and material")
            : Container(),
        CustomTextFormField(
          initialValue: vendorField.value,
          label: "Vendor Name",
          onChanged: proformaItemFormCubit.vendorChanged,
          errorMessage: vendorField.errorMessage,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormInfoItem(
                title: "Quantity Requested",
                value: quantity != null ? quantity.toString() : "N/A"),
            FormInfoItem(
                title: "Unit", value: unit != null ? unit.name : "N/A"),
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
            const SizedBox(
              width: 10,
            ),
            FormInfoItem(title: "Total Price", value: totalPrice.toString()),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  pickImage(ImageSource.gallery, proformaItemFormCubit);
                },
                child: Text("Upload Photo"),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  pickImage(ImageSource.camera, proformaItemFormCubit);
                },
                child: Text("Take Photo"),
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 10,
        ),
        if (image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              image!,
              height: 80,
              width: 60,
              fit: BoxFit.cover,
            ),
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
          onPressed: (widget.selectedRequestedMaterial == null)
              ? null
              : () {
                  proformaItemFormCubit.onSubmit();
                  if (proformaItemFormCubit.state.isValid) {
                    if (widget.isEdit) {
                      // final updated = MaterialReturnMaterialEntity(
                      //   material: selectedMaterial,
                      //   issueVoucherId: selectedMaterialIssue?.id ?? "",
                      //   quantity: double.parse(quantityField.value),
                      //   remark: remarkField.value,
                      // );

                      // BlocProvider.of<MaterialReturnLocalBloc>(context).add(
                      //     EditMaterialReturnMaterialLocal(updated, widget.index));
                    } else {
                      final newItem = MaterialProformaMaterialEntity(
                          vendor: vendorField.value,
                          unitPrice: double.parse(priceField.value),
                          multipartFile: multipartFile,
                          photo: photoField.value,
                          remark: remarkField.value,
                          quantity: quantity ?? 0);
                      widget.onAddItem(newItem);
                    }
                    Navigator.pop(context);
                  }
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
    // if (value?.isEmpty ?? true) {
    //   return PhotoFieldError.invalid;
    // }
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
