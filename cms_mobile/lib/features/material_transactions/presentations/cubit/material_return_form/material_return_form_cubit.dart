import 'package:cms_mobile/features/items/domain/entities/item.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_return_form/material_return_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_return/create_material_return.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_return/create_material_return_form.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class MaterialReturnWarehouseFormCubit
    extends Cubit<MaterialReturnWarehouseFormState> {
  MaterialReturnWarehouseFormCubit({
    String? warehouseId,
  }) : super(MaterialReturnWarehouseFormState(
          warehouseDropdown: WarehouseDropdown.pure(warehouseId ?? ""),
        ));
  void warehouseChanged(WarehouseEntity warehouseEntity) {
    final WarehouseDropdown warehouseDropdown =
        WarehouseDropdown.dirty(warehouseEntity.id);

    emit(
      state.copyWith(
        warehouseDropdown: warehouseDropdown,
        isValid: Formz.validate([
          state.warehouseDropdown,
        ]),
      ),
    );
  }

  void onSubmit() {
    emit(
      state.copyWith(
        warehouseDropdown:
            WarehouseDropdown.dirty(state.warehouseDropdown.value),
        isValid: Formz.validate([
          state.warehouseDropdown,
        ]),
      ),
    );
  }

  // @override
  // void onChange(Change<MaterialReturnFormState> change) {
  //   super.onChange(change);
  //   print('Current State: ${change.currentState}');
  //   print('Next State: ${change.nextState}');
  // }

  // MaterialReturnFormState copyWith({
  //   bool? isValid,
  //   FormStatus? formStatus,
  //   QuantityField? quantityField,
  // }) {
  //   return MaterialReturnFormState(
  //     isValid: isValid ?? this.isValid,
  //     formStatus: formStatus ?? this.formStatus,
  //     quantityField: quantityField ?? this.quantityField,
  //   );
  // }
}

class MaterialReturnFormCubit extends Cubit<MaterialReturnFormState> {
  MaterialReturnFormCubit({
    String? materialId,
    String? materialIssueId,
    // String? warehouseId,
    double? quantity,
    double? inStock,
    String? remark,
  }) : super(MaterialReturnFormState(
            materialDropdown: MaterialDropdown.pure(materialId ?? ""),
            materialIssueDropdown: MaterialIssueDropdown.pure(materialIssueId ?? ""),
            // warehouseDropdown: WarehouseDropdown.pure(warehouseId ?? ""),
            quantityField: QuantityField.pure(value: quantity.toString()),
            inStock: inStock ?? 0.0,
            remarkField: RemarkField.pure(remark ?? "")));

  void quantityChanged(String value) {
    final QuantityField quantityField =
        QuantityField.dirty(value, inStock: state.inStock);

    emit(
      state.copyWith(
        quantityField: quantityField,
        isValid: Formz.validate([
          state.materialIssueDropdown,
          state.quantityField,
          state.materialDropdown,
          state.remarkField
        ]),
      ),
    );
  }

  void materialChanged(WarehouseItemEntity materialEntity) {
    final MaterialDropdown materialDropdown =
        MaterialDropdown.dirty(materialEntity.itemVariant.id!);

    emit(
      state.copyWith(
        materialDropdown: materialDropdown,
        inStock: materialEntity.quantity,
        isValid: Formz.validate([
          state.materialIssueDropdown,
          state.quantityField,
          state.materialDropdown,
          state.remarkField
        ]),
      ),
    );
  }

  void materialIssueChanged(MaterialIssueEntity materialIssueEntity) {
    final MaterialIssueDropdown materialIssueDropdown =
        MaterialIssueDropdown.dirty(materialIssueEntity.id!);

    emit(
      state.copyWith(
        materialIssueDropdown: materialIssueDropdown,
        isValid: Formz.validate([
          state.materialIssueDropdown,
          state.quantityField,
          state.materialDropdown,
          state.materialIssueDropdown,
          state.remarkField
        ]),
      ),
    );
  }



  // void unitChanged(String value) {
  //   final UnitDropdown unitDropdown = UnitDropdown.dirty(value);

  //   emit(
  //     state.copyWith(
  //       // unitDropdown: unitDropdown,
  //       isValid: Formz.validate([
  //         state.quantityField,
  //         state.materialDropdown,
  //         // state.unitDropdown,
  //         state.remarkField
  //       ]),
  //     ),
  //   );
  // }

  void remarkChanged(String value) {
    final RemarkField remarkField = RemarkField.dirty(value);

    emit(
      state.copyWith(
        remarkField: remarkField,
        isValid: Formz.validate([
          state.materialIssueDropdown,
          state.quantityField,
          state.materialDropdown,
          // state.warehouseDropdown,

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
        quantityField: QuantityField.dirty(state.quantityField.value,
            inStock: state.inStock),
        materialDropdown: MaterialDropdown.dirty(state.materialDropdown.value),
          materialIssueDropdown: MaterialIssueDropdown.dirty(state.materialIssueDropdown.value),
        //     WarehouseDropdown.dirty(state.warehouseDropdown.value)
        // unitDropdown: UnitDropdown.dirty(state.unitDropdown.value),
        remarkField: RemarkField.dirty(state.remarkField.value),
        isValid: Formz.validate([
          state.quantityField,
          state.materialDropdown,
          // state.warehouseDropdown,
          // state.unitDropdown,
          state.remarkField
        ]),
      ),
    );
  }

  // @override
  // void onChange(Change<MaterialReturnFormState> change) {
  //   super.onChange(change);
  //   print('Current State: ${change.currentState}');
  //   print('Next State: ${change.nextState}');
  // }

  // MaterialReturnFormState copyWith({
  //   bool? isValid,
  //   FormStatus? formStatus,
  //   QuantityField? quantityField,
  // }) {
  //   return MaterialReturnFormState(
  //     isValid: isValid ?? this.isValid,
  //     formStatus: formStatus ?? this.formStatus,
  //     quantityField: quantityField ?? this.quantityField,
  //   );
  // }
}
