import 'package:cms_mobile/features/material_transactions/presentations/pages/material_proforma/create_material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_proforma/material_proforma_form.dart';
import 'package:equatable/equatable.dart';

enum FormStatus { invalid, valid, validating }

class MaterialProformaMainFormState extends Equatable {
  final FormStatus formStatus;
  final MaterialRequestDropdown materialRequestDropdown;
  final MaterialDropdown materialDropdown;

  final bool isValid;

  const MaterialProformaMainFormState(
      {this.materialRequestDropdown = const MaterialRequestDropdown.pure(),
      this.materialDropdown = const MaterialDropdown.pure(),
      this.formStatus = FormStatus.invalid,
      this.isValid = false});

  MaterialProformaMainFormState copyWith(
      {bool? isValid,
      FormStatus? formStatus,
      MaterialRequestDropdown? materialRequestDropdown,
      MaterialDropdown? materialDropdown}) {
    return MaterialProformaMainFormState(
        isValid: isValid ?? this.isValid,
        formStatus: formStatus ?? this.formStatus,
        materialRequestDropdown:
            materialRequestDropdown ?? this.materialRequestDropdown,
        materialDropdown: materialDropdown ?? this.materialDropdown);
  }

  @override
  String toString() {
    return 'ProformaMainFormState(materialRequestDropdown: $materialRequestDropdown, materialDropdown: $materialDropdown, isValid: $isValid, formStatus: $formStatus)';
  }

  @override
  List<Object?> get props =>
      [materialRequestDropdown, materialDropdown, isValid, formStatus];
}

class MaterialProformaItemFormState extends Equatable {
  final FormStatus formStatus;
  final bool isValid;
  final PriceField priceField;
  final VendorField vendorField;
  final RemarkField remarkField;
  final PhotoField photoField;

  const MaterialProformaItemFormState(
      { this.formStatus = FormStatus.invalid,
       this.isValid = false,
       this.priceField = const PriceField.pure(),
       this.vendorField = const VendorField.pure(),
       this.remarkField = const RemarkField.pure(),
       this.photoField = const PhotoField.pure()});

  MaterialProformaItemFormState copyWith(
      {FormStatus? formStatus,
      bool? isValid,
      PriceField? priceField,
      VendorField? vendorField,
      RemarkField? remarkField,
      PhotoField? photoField}) {
    return MaterialProformaItemFormState(
        formStatus: formStatus ?? this.formStatus,
        isValid: isValid ?? this.isValid,
        priceField: priceField ?? this.priceField,
        vendorField: vendorField ?? this.vendorField,
        remarkField: remarkField ?? this.remarkField,
        photoField: photoField ?? this.photoField);
  }

  @override
  List<Object?> get props => [formStatus, isValid, priceField, vendorField, remarkField, photoField];
}
