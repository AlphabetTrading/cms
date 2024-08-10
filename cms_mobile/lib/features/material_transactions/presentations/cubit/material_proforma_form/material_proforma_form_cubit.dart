import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_proforma_form/material_proforma_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_proforma/create_material_proforma.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_proforma/material_proforma_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

enum FormStatus { invalid, valid, validating }

class MaterialProformaMainFormCubit extends Cubit<MaterialProformaMainFormState> {
  MaterialProformaMainFormCubit({
    String? materialRequestId,
    String? materialId,
  }) : super(MaterialProformaMainFormState(
          materialRequestDropdown:
              MaterialRequestDropdown.pure(materialRequestId ?? ""),
          materialDropdown: MaterialDropdown.pure(materialId ?? ""),
        ));

  void materialRequestChanged(MaterialRequestEntity materialRequest) {
    final MaterialRequestDropdown materialRequestDropdown =
        MaterialRequestDropdown.dirty(materialRequest.id ?? "");

    emit(
      state.copyWith(
        materialRequestDropdown: materialRequestDropdown,
        isValid: Formz.validate(
            [state.materialDropdown, state.materialRequestDropdown]),
      ),
    );
  }

  void materialChanged(MaterialRequestItem material) {
    // could be productVariantId
    final MaterialDropdown materialDropdown =
        MaterialDropdown.dirty(material.id ?? "");

    emit(
      state.copyWith(
        materialDropdown: materialDropdown,
        isValid: Formz.validate(
            [state.materialDropdown, state.materialRequestDropdown]),
      ),
    );
  }

  void onSubmit() {
    emit(
      state.copyWith(
        materialRequestDropdown:
            MaterialRequestDropdown.dirty(state.materialRequestDropdown.value),
        materialDropdown: MaterialDropdown.dirty(state.materialDropdown.value),
        isValid: Formz.validate(
            [state.materialDropdown, state.materialRequestDropdown]),
      ),
    );
  }
}

class MaterialProformaItemFormCubit extends Cubit<MaterialProformaItemFormState> {
  MaterialProformaItemFormCubit({
    String? vendor,
    double? price,
    String? photo,
    String? remark,
  }) : super(MaterialProformaItemFormState(
          priceField: PriceField.pure(price.toString()),
          vendorField: VendorField.pure(vendor ?? ""),
          remarkField: RemarkField.pure(remark ?? ""),
          photoField: PhotoField.pure(photo ?? ""),
        ));

  void vendorChanged(String vendor) {
    final VendorField vendorField = VendorField.dirty(vendor);

    emit(
      state.copyWith(
        vendorField: vendorField,
        isValid: Formz.validate([
          state.priceField,
          state.vendorField,
          state.remarkField,
          state.photoField
        ]),
      ),
    );
  }

  void priceChanged(String price) {
    final PriceField priceField = PriceField.dirty(price);

    emit(
      state.copyWith(
        priceField: priceField,
        isValid: Formz.validate([
          state.priceField,
          state.vendorField,
          state.remarkField,
          state.photoField
        ]),
      ),
    );
  }

  void photoChanged(String photo) {
    final PhotoField photoField = PhotoField.dirty(photo);

    emit(
      state.copyWith(
        photoField: photoField,
        isValid: Formz.validate([
          state.priceField,
          state.vendorField,
          state.remarkField,
          state.photoField
        ]),
      ),
    );
  }

  void remarkChanged(String remark) {
    final RemarkField remarkField = RemarkField.dirty(remark);

    emit(
      state.copyWith(
        remarkField: remarkField,
        isValid: Formz.validate([
          state.priceField,
          state.vendorField,
          state.remarkField,
          state.photoField
        ]),
      ),
    );
  }

  void onSubmit() {
    emit(
      state.copyWith(
        priceField: PriceField.dirty(state.priceField.value),
        vendorField: VendorField.dirty(state.vendorField.value),
        remarkField: RemarkField.dirty(state.remarkField.value),
        photoField: PhotoField.dirty(state.photoField.value),
        isValid: Formz.validate([
          state.priceField,
          state.vendorField,
          state.remarkField,
          state.photoField
        ]),
      
      ),
    );
  }
}
