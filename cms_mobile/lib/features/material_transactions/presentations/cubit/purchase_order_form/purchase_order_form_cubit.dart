import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/purchase_order_form/purchase_order_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/purchase_order/create_purchase_order_form.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class PurchaseOrderFormCubit extends Cubit<PurchaseOrderFormState> {
  PurchaseOrderFormCubit({
    bool? isProforma,
    String? vendor,
    String? proformaId,
    String? materialRequestId,
    String? materialRequestItemId,
    double? quantity,
    double? unitPrice,
    double? totalPrice,
    String? remark,
  }) : super(PurchaseOrderFormState(
          isProforma: isProforma ?? false,
          materialRequestDropdown:
              MaterialRequestDropdown.pure(materialRequestId ?? ""),
          materialRequestItemDropdown:
              MaterialRequestItemDropdown.pure(materialRequestItemId ?? ""),
          proformaDropdown: ProformaDropdown.pure(proformaId ?? ""),
          vendor: vendor ?? "",
          quantity: quantity ?? 0,
          remarkField: RemarkField.pure(remark ?? ""),
          unitPriceField: UnitPriceField.pure(unitPrice.toString()),
          totalPrice: totalPrice ?? 0,
        ));

  void toggleIsProforma(bool value) {
    emit(state.copyWith(isProforma: value));
  }

  void materialRequestChanged(MaterialRequestEntity materialRequest) {
    final selectedRequest = materialRequest;

    emit(state.copyWith(
      materialRequestDropdown:
          MaterialRequestDropdown.dirty(materialRequest.id!),
      selectedMaterialRequest: selectedRequest,
      materialRequestItemDropdown: const MaterialRequestItemDropdown.pure(),
      isValid: Formz.validate([state.materialRequestDropdown]),
    ));
  }

  void materialRequestItemChanged(MaterialRequestItem materialRequestItem) {
    emit(state.copyWith(
      materialRequestItemDropdown:
          MaterialRequestItemDropdown.dirty(materialRequestItem.id!),
      quantity: materialRequestItem.quantity,
      // unit: materialRequestItem.productVariant?.unitOfMeasure,
      isValid: Formz.validate([state.materialRequestDropdown]),
    ));
  }

  void proformaChanged(MaterialProformaEntity proforma) {
    final selectedProforma = proforma.selectedProformaItem;

    emit(state.copyWith(
      proformaDropdown: ProformaDropdown.dirty(proforma.id!),
      materialRequestDropdown: MaterialRequestDropdown.pure(),
      materialRequestItemDropdown: MaterialRequestItemDropdown.pure(),
      quantity: selectedProforma?.quantity,
      unitPriceField: UnitPriceField.dirty(
          selectedProforma?.unitPrice.toString() ?? "",
          unitPrice: selectedProforma?.unitPrice ?? 0),
      totalPrice: (selectedProforma?.unitPrice ?? 0) *
          (selectedProforma?.quantity ?? 0),
      vendor: selectedProforma?.vendor ?? "",
      isValid: Formz.validate(
          [state.proformaDropdown, state.unitPriceField, state.vendorField]),
    ));
  }

  void unitPriceChanged(String value) {
    final UnitPriceField unitPriceField =
        UnitPriceField.dirty(value, unitPrice: state.unitPriceField.unitPrice);
    emit(state.copyWith(
        unitPriceField: unitPriceField,
        isValid: Formz.validate([state.unitPriceField])));
  }

  void remarkChanged(String value) {
    final RemarkField remarkField = RemarkField.dirty(value);

    emit(
      state.copyWith(
        remarkField: remarkField,
        isValid: Formz.validate([state.remarkField]),
      ),
    );
  }

  void onSubmit() {
    emit(
      state.copyWith(
        formStatus: FormStatus.validating,
        unitPriceField: UnitPriceField.dirty(
            state.unitPriceField.unitPrice.toString(),
            unitPrice: state.unitPriceField.unitPrice),
        materialRequestDropdown:
            MaterialRequestDropdown.dirty(state.materialRequestDropdown.value),
        materialRequestItemDropdown: MaterialRequestItemDropdown.dirty(
            state.materialRequestItemDropdown.value),
        proformaDropdown: ProformaDropdown.dirty(state.proformaDropdown.value),
        quantity: state.quantity,
        totalPrice: state.totalPrice,
        vendor: state.vendor,
        remarkField: RemarkField.dirty(state.remarkField.value),
        isValid: Formz.validate([
          state.unitPriceField,
          state.materialRequestDropdown,
          state.materialRequestItemDropdown,
          state.proformaDropdown,
          state.remarkField
        ]),
      ),
    );
  }
}
