import 'package:cms_mobile/features/material_transactions/presentations/cubit/daily_site_data_form/daily_site_data_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/daily_site_data/create_daily_site_data_form.dart';
import 'package:cms_mobile/features/products/data/models/product.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class DailySiteDataFormCubit extends Cubit<DailySiteDataFormState> {
  DailySiteDataFormCubit({
    String? materialId,
    double? quantity,
    UnitOfMeasure? unitDropdown,
    String? taskName,
    MaterialDropdown? materialDropdown,
  }) : super(DailySiteDataFormState(
          materialDropdown: MaterialDropdown.pure(materialId ?? ""),
          unitDropdown: UnitDropdown.pure(unitDropdown?.name ?? ""),
          quantityField: QuantityField.pure(value: quantity.toString()),
          taskNameField: TaskNameField.pure(taskName ?? ""),
        ));

  void quantityChanged(String value) {
    final QuantityField quantityField = QuantityField.dirty(value);

    emit(
      state.copyWith(
        quantityField: quantityField,
        isValid: Formz.validate([state.quantityField, state.unitDropdown]),
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
          state.quantityField,
          state.materialDropdown,
          state.unitDropdown,
          state.taskNameField,
        ]),
      ),
    );
  }

  void unitChanged(String value) {
    final UnitDropdown unitDropdown = UnitDropdown.dirty(value);

    emit(
      state.copyWith(
        // unitDropdown: unitDropdown,
        isValid: Formz.validate([
          state.quantityField,
          state.materialDropdown,
          state.unitDropdown,
        ]),
      ),
    );
  }

  void taskNameChanged(String value) {
    final TaskNameField taskNameField = TaskNameField.dirty(value);

    emit(
      state.copyWith(
        isValid: Formz.validate([
          state.quantityField,
          state.unitDropdown,
          state.materialDropdown,
          // state.taskNameField,
        ]),
      ),
    );
  }

  void onSubmit() {
    emit(
      state.copyWith(
        formStatus: FormStatus.validating,
        quantityField: QuantityField.dirty(
          state.quantityField.value,
        ),
        materialDropdown: MaterialDropdown.dirty(state.materialDropdown.value),
        unitDropdown: UnitDropdown.dirty(state.unitDropdown.value),
        isValid: Formz.validate([
          state.quantityField,
          state.materialDropdown,
          state.unitDropdown,
        ]),
      ),
    );
  }

  // @override
  // void onChange(Change<DailySiteDataFormState> change) {
  //   super.onChange(change);
  //   print('Current State: ${change.currentState}');
  //   print('Next State: ${change.nextState}');
  // }

  // DailySiteDataFormState copyWith({
  //   bool? isValid,
  //   FormStatus? formStatus,
  //   QuantityField? quantityField,
  // }) {
  //   return DailySiteDataFormState(
  //     isValid: isValid ?? this.isValid,
  //     formStatus: formStatus ?? this.formStatus,
  //     quantityField: quantityField ?? this.quantityField,
  //   );
  // }
}
