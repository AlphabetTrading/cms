import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/purchase_order_form/purchase_order_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/purchase_order/create_purchase_order_form.dart';
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
      unitPriceField: const UnitPriceField.pure(),
      totalPrice: 0,
      remarkField: const RemarkField.pure(),
      isValid: Formz.validate([state.materialRequestDropdown]),
    ));
  }

  void materialRequestItemChanged(MaterialRequestItem materialRequestItem) {
    emit(state.copyWith(
      materialRequestItemDropdown:
          MaterialRequestItemDropdown.dirty(materialRequestItem.id!),
      quantity: materialRequestItem.quantity,
      unitPriceField: const UnitPriceField.pure(),
      totalPrice: 0,
      remarkField: const RemarkField.pure(),
      isValid: Formz.validate([
        state.materialRequestDropdown,
        state.materialRequestItemDropdown,
        state.unitPriceField,
        state.remarkField
      ]),
    ));
  }

  void proformaChanged(MaterialProformaEntity proforma) {
    // final selectedProforma = proforma.items?[0];
    final selectedProforma = proforma.selectedProformaItem;

    emit(state.copyWith(
      proformaDropdown: ProformaDropdown.dirty(proforma.id),
      materialRequestDropdown: const MaterialRequestDropdown.pure(),
      materialRequestItemDropdown: const MaterialRequestItemDropdown.pure(),
      quantity: selectedProforma?.quantity,
      vendor: selectedProforma?.vendor ?? "N/A",
      unitPriceField:
          UnitPriceField.dirty('', unitPrice: selectedProforma?.unitPrice ?? 0),
      totalPrice: (selectedProforma?.quantity ?? 0) *
          (selectedProforma?.unitPrice ?? 0),
      remarkField: const RemarkField.pure(),
      isValid: Formz.validate(
          [state.proformaDropdown, state.unitPriceField, state.vendorField]),
    ));
  }

  void unitPriceChanged(String value) {
    final unitPrice = double.tryParse(value) ?? 0;
    final UnitPriceField unitPriceField =
        UnitPriceField.dirty(value, unitPrice: state.unitPriceField.unitPrice);
    emit(state.copyWith(
        unitPriceField: unitPriceField,
        totalPrice: unitPrice * state.quantity,
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
    final double? parsedUnitPrice = double.tryParse(state.unitPriceField.value);
    if (state.isProforma) {
      emit(
        state.copyWith(
          formStatus: FormStatus.validating,
          proformaDropdown:
              ProformaDropdown.dirty(state.proformaDropdown.value),
          unitPriceField: UnitPriceField.dirty(state.unitPriceField.value,
              unitPrice: parsedUnitPrice ?? 0),
          remarkField: RemarkField.dirty(state.remarkField.value),
          isValid: Formz.validate([state.proformaDropdown, state.remarkField]),
        ),
      );
    } else {}
    emit(
      state.copyWith(
        formStatus: FormStatus.validating,
        unitPriceField: UnitPriceField.dirty(state.unitPriceField.value,
            unitPrice: parsedUnitPrice ?? 0),
        materialRequestDropdown:
            MaterialRequestDropdown.dirty(state.materialRequestDropdown.value),
        materialRequestItemDropdown: MaterialRequestItemDropdown.dirty(
            state.materialRequestItemDropdown.value),
        remarkField: RemarkField.dirty(state.remarkField.value),
        isValid: Formz.validate([
          state.unitPriceField,
          state.materialRequestDropdown,
          state.materialRequestItemDropdown,
          state.remarkField
        ]),
      ),
    );
  }
}
