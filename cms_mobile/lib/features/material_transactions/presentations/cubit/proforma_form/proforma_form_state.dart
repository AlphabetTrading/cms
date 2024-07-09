import 'package:cms_mobile/features/material_transactions/presentations/pages/proforma/create_proforma.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/proforma/proforma_form.dart';
import 'package:equatable/equatable.dart';

enum FormStatus { invalid, valid, validating }

class ProformaMainFormState extends Equatable {
  final FormStatus formStatus;
  final MaterialRequestDropdown materialRequestDropdown;
  final MaterialDropdown materialDropdown;

  final bool isValid;

  const ProformaMainFormState(
      {this.materialRequestDropdown = const MaterialRequestDropdown.pure(),
      this.materialDropdown = const MaterialDropdown.pure(),
      this.formStatus = FormStatus.invalid,
      this.isValid = false});

  ProformaMainFormState copyWith(
      {bool? isValid,
      FormStatus? formStatus,
      MaterialRequestDropdown? materialRequestDropdown,
      MaterialDropdown? materialDropdown}) {
    return ProformaMainFormState(
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

class ProformaItemFormState extends Equatable {
  final FormStatus formStatus;
  final bool isValid;
  final PriceField priceField;
  final VendorField vendorField;
  final RemarkField remarkField;
  final PhotoField photoField;

  const ProformaItemFormState(
      { this.formStatus = FormStatus.invalid,
       this.isValid = false,
       this.priceField = const PriceField.pure(),
       this.vendorField = const VendorField.pure(),
       this.remarkField = const RemarkField.pure(),
       this.photoField = const PhotoField.pure()});

  ProformaItemFormState copyWith(
      {FormStatus? formStatus,
      bool? isValid,
      PriceField? priceField,
      VendorField? vendorField,
      RemarkField? remarkField,
      PhotoField? photoField}) {
    return ProformaItemFormState(
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
