import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_request_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/create_material_request_form.dart';
import 'package:cms_mobile/features/items/domain/entities/item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class MaterialRequestFormCubit extends Cubit<MaterialRequestFormState> {
  MaterialRequestFormCubit(
      {String? materialId,
      double? requestedQuantity,
      // String? unit,
      String? remark,
      })
      : super(MaterialRequestFormState(
            materialDropdown: MaterialDropdown.pure(materialId ?? ""),
            quantityField: QuantityField.pure(value:requestedQuantity.toString()),
            // unitDropdown: UnitDropdown.pure(unit ?? ""),
            remarkField: RemarkField.pure(remark ?? "")));

  void quantityChanged(String value) {
    final QuantityField quantityField = QuantityField.dirty(value, inStock: state.inStock);

    emit(
      state.copyWith(
        quantityField: quantityField,
        isValid: Formz.validate([
          state.quantityField,
          state.materialDropdown,
          // state.unitDropdown,
          state.remarkField
        ]),
      ),
    );
  }

  void materialChanged(WarehouseItemEntity materialEntity) {
    final MaterialDropdown materialDropdown = MaterialDropdown.dirty(materialEntity.itemVariant.id);

    emit(
      state.copyWith(
        materialDropdown: materialDropdown,
        inStock: materialEntity.quantity,
        isValid: Formz.validate([
          state.quantityField,
          state.materialDropdown,
          // state.unitDropdown,
          state.remarkField
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
          state.quantityField,
          state.materialDropdown,
          // state.unitDropdown,
          state.remarkField
        ]),
      ),
    );
  }

  void remarkChanged(String value) {
    final RemarkField remarkField = RemarkField.dirty(value);

    emit(
      state.copyWith(
        remarkField: remarkField,
        isValid: Formz.validate([
          state.quantityField,
          state.materialDropdown,
          // state.unitDropdown,
          state.remarkField
        ]),
      ),
    );
  }

  void onSubmit() {
    emit(
      state.copyWith(
        formStatus: FormStatus.validating,
        quantityField: QuantityField.dirty(state.quantityField.value, inStock: state.inStock),
        materialDropdown: MaterialDropdown.dirty(state.materialDropdown.value),
        unitDropdown: UnitDropdown.dirty(state.unitDropdown.value),
        remarkField: RemarkField.dirty(state.remarkField.value),
        isValid: Formz.validate([
          state.quantityField,
          state.materialDropdown,
          // state.unitDropdown,
          state.remarkField
        ]),
      ),
    );
  }

  // @override
  // void onChange(Change<MaterialRequestFormState> change) {
  //   super.onChange(change);
  //   print('Current State: ${change.currentState}');
  //   print('Next State: ${change.nextState}');
  // }

  // MaterialRequestFormState copyWith({
  //   bool? isValid,
  //   FormStatus? formStatus,
  //   QuantityField? quantityField,
  // }) {
  //   return MaterialRequestFormState(
  //     isValid: isValid ?? this.isValid,
  //     formStatus: formStatus ?? this.formStatus,
  //     quantityField: quantityField ?? this.quantityField,
  //   );
  // }
}
