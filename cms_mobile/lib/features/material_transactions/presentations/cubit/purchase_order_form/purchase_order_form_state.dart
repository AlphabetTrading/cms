import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/purchase_order/create_purchase_order_form.dart';
import 'package:equatable/equatable.dart';

enum FormStatus { invalid, valid, validating }

class PurchaseOrderFormState extends Equatable {
  final bool isValid;
  final bool isProforma;
  final FormStatus formStatus;
  final UnitPriceField unitPriceField;
  final VendorField vendorField;
  final MaterialRequestDropdown materialRequestDropdown;
  final MaterialRequestItemDropdown materialRequestItemDropdown;
  final ProformaDropdown proformaDropdown;
  final RemarkField remarkField;
  final String vendor;
  final double quantity;
  final double totalPrice;
  final MaterialRequestEntity? selectedMaterialRequest;

  const PurchaseOrderFormState(
      {this.isValid = false,
      this.isProforma = false,
      this.formStatus = FormStatus.invalid,
      this.vendor = "",
      this.quantity = 0.0,
      this.totalPrice = 0.0,
      this.vendorField = const VendorField.pure(),
      this.unitPriceField = const UnitPriceField.pure(),
      this.materialRequestDropdown = const MaterialRequestDropdown.pure(),
      this.selectedMaterialRequest,
      this.materialRequestItemDropdown =
          const MaterialRequestItemDropdown.pure(),
      this.proformaDropdown = const ProformaDropdown.pure(),
      this.remarkField = const RemarkField.pure()});

  PurchaseOrderFormState copyWith({
    bool? isValid,
    bool? isProforma,
    FormStatus? formStatus,
    UnitPriceField? unitPriceField,
    VendorField? vendorField,
    MaterialRequestEntity? selectedMaterialRequest,
    MaterialRequestDropdown? materialRequestDropdown,
    MaterialRequestItemDropdown? materialRequestItemDropdown,
    ProformaDropdown? proformaDropdown,
    RemarkField? remarkField,
    String? vendor,
    double? quantity,
    double? totalPrice,
  }) {
    return PurchaseOrderFormState(
        isValid: isValid ?? this.isValid,
        isProforma: isProforma ?? this.isProforma,
        formStatus: formStatus ?? this.formStatus,
        vendor: vendor ?? this.vendor,
        vendorField: vendorField ?? this.vendorField,
        quantity: quantity ?? this.quantity,
        totalPrice: totalPrice ?? this.totalPrice,
        unitPriceField: unitPriceField ?? this.unitPriceField,
        selectedMaterialRequest:
            selectedMaterialRequest ?? this.selectedMaterialRequest,
        materialRequestDropdown:
            materialRequestDropdown ?? this.materialRequestDropdown,
        materialRequestItemDropdown:
            materialRequestItemDropdown ?? this.materialRequestItemDropdown,
        proformaDropdown: proformaDropdown ?? this.proformaDropdown,
        remarkField: remarkField ?? this.remarkField);
  }

  @override
  String toString() {
    return 'PurchaseOrderFormState{isValid: $isValid, isProforma: $isProforma, formStatus: $formStatus, unitPriceField: $unitPriceField, vendor: $vendor, vendorField: $vendorField, quantity: $quantity, materialRequestDropdown: $materialRequestDropdown, materialRequestItemDropdown: $materialRequestItemDropdown, proformaDropdown: $proformaDropdown, remarkField: $remarkField, selectedMaterialRequest: $selectedMaterialRequest}';
  }

  @override
  List<Object?> get props => [
        isValid,
        isProforma,
        formStatus,
        unitPriceField,
        isValid,
        formStatus,
        unitPriceField,
        selectedMaterialRequest,
        materialRequestDropdown,
        materialRequestItemDropdown,
        proformaDropdown,
        remarkField,
        vendor,
        vendorField,
        quantity,
        totalPrice,
      ];
}
