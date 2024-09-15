import 'package:cms_mobile/features/material_transactions/presentations/cubit/daily_site_data_form/daily_site_data_add_material_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/daily_site_data/add_material_form.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class DailySiteDataAddMaterialFormCubit
    extends Cubit<DailySiteDataAddMaterialFormState> {
  DailySiteDataAddMaterialFormCubit({
    String? materialId,
    double? quantityWasted,
    double? quantityUsed,
    UnitOfMeasure? unitDropdown,
    MaterialDropdown? materialDrowdown,
  }) : super(DailySiteDataAddMaterialFormState(
          unitDropdown: UnitDropdown.pure(unitDropdown?.name ?? ""),
          quantityUsedField:
              QuantityUsedField.pure(value: quantityUsed.toString()),
          quantityWastedField:
              QuantityWastedField.pure(value: quantityWasted.toString()),
          materialDropdown: MaterialDropdown.pure(materialId ?? ""),
        ));

  void quantityUsedChanged(String value) {
    final QuantityUsedField quantityUsedField = QuantityUsedField.dirty(value);

    emit(
      state.copyWith(
        quantityUsedField: quantityUsedField,
        isValid: Formz.validate([
          state.quantityUsedField,
          state.quantityWastedField,
          state.materialDropdown,
          state.unitDropdown,
        ]),
      ),
    );
  }

  void quantityWastedChanged(String value) {
    final QuantityWastedField quantityWastedField =
        QuantityWastedField.dirty(value);

    emit(
      state.copyWith(
        quantityWastedField: quantityWastedField,
        isValid: Formz.validate([
          state.quantityUsedField,
          state.quantityWastedField,
          state.materialDropdown,
          state.unitDropdown,
        ]),
      ),
    );
  }

  void materialChanged(WarehouseProductEntity materialEntity) {
    final MaterialDropdown materialDropdown =
        MaterialDropdown.dirty(materialEntity.productVariant.id);

    emit(
      state.copyWith(
        materialDropdown: materialDropdown,
        isValid: Formz.validate([
          state.quantityUsedField,
          state.quantityWastedField,
          state.materialDropdown,
          state.unitDropdown,
        ]),
      ),
    );
  }

  void unitChanged(String value) {
    final UnitDropdown unitDropdown = UnitDropdown.dirty(value);

    emit(
      state.copyWith(
        unitDropdown: unitDropdown,
        isValid: Formz.validate([
          state.quantityUsedField,
          state.quantityWastedField,
          state.materialDropdown,
          state.unitDropdown,
        ]),
      ),
    );
  }

  void reset() {
    emit(
      const DailySiteDataAddMaterialFormState(
        unitDropdown: UnitDropdown.pure(),
        quantityUsedField: QuantityUsedField.pure(),
        quantityWastedField: QuantityWastedField.pure(),
        materialDropdown: MaterialDropdown.pure(),
      ),
    );
  }

  void submit() {
    emit(
      state.copyWith(
        formStatus: FormStatus.validating,
        quantityUsedField:
            QuantityUsedField.dirty(state.quantityUsedField.value),
        quantityWastedField:
            QuantityWastedField.dirty(state.quantityWastedField.value),
        materialDropdown: MaterialDropdown.dirty(state.materialDropdown.value),
        unitDropdown: UnitDropdown.dirty(state.unitDropdown.value),
      ),
    );
  }
}
