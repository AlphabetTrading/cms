import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_receive_form/material_receive_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_receive/material_receive_edit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_receive/create_material_receive_form.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class MaterialReceiveWarehouseFormCubit
    extends Cubit<MaterialReceiveWarehouseFormState> {
  MaterialReceiveWarehouseFormCubit({
    String? warehouseId,
  }) : super(MaterialReceiveWarehouseFormState(
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
  // void onChange(Change<MaterialReceiveFormState> change) {
  //   super.onChange(change);
  //   print('Current State: ${change.currentState}');
  //   print('Next State: ${change.nextState}');
  // }

  // MaterialReceiveFormState copyWith({
  //   bool? isValid,
  //   FormStatus? formStatus,
  //   QuantityField? quantityField,
  // }) {
  //   return MaterialReceiveFormState(
  //     isValid: isValid ?? this.isValid,
  //     formStatus: formStatus ?? this.formStatus,
  //     quantityField: quantityField ?? this.quantityField,
  //   );
  // }
}

class MaterialReceiveFormCubit extends Cubit<MaterialReceiveFormState> {
  MaterialReceiveFormCubit({
    String? materialId,
    String? materialReceiveId,
    // String? warehouseId,
    double? quantity,
    double? inStock,
    String? remark,
  }) : super(MaterialReceiveFormState(
          // materialDropdown: MaterialDropdown.pure(materialId ?? ""),
          // materialReceiveDropdown:
          //     MaterialDropdown.pure(materialReceiveId ?? ""),
          // warehouseDropdown: WarehouseDropdown.pure(warehouseId ?? ""),
          // quantityField: QuantityField.pure(value: quantity.toString()),
          inStock: inStock ?? 0.0,
          // remarkField: RemarkField.pure(remark ?? ""),
        ));

  void quantityChanged(String value) {
    final QuantityField quantityField =
        QuantityField.dirty(value, inStock: state.inStock);

    emit(
      state.copyWith(
        // quantityField: quantityField,
        isValid: Formz.validate([
          state.materialReceiveDropdown,
          state.quantityField,
          state.materialDropdown,
          state.remarkField
        ]),
      ),
    );
  }

  void materialChanged(WarehouseProductEntity materialEntity) {
    final MaterialDropdown materialDropdown =
        MaterialDropdown.dirty(materialEntity.productVariant.id);

    emit(
      state.copyWith(
        // materialDropdown: materialDropdown,
        inStock: materialEntity.quantity,
        isValid: Formz.validate([
          state.materialReceiveDropdown,
          state.quantityField,
          state.materialDropdown,
          state.remarkField
        ]),
      ),
    );
  }

  void materialReceiveChanged(MaterialReceiveEntity materialReceiveEntity) {
    final MaterialDropdown materialReceiveDropdown =
        MaterialDropdown.dirty(materialReceiveEntity.id!);

    emit(
      state.copyWith(
        // materialReceiveDropdown: materialReceiveDropdown,
        isValid: Formz.validate([
          state.materialReceiveDropdown,
          state.quantityField,
          state.materialDropdown,
          state.materialReceiveDropdown,
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
        // remarkField: remarkField,
        isValid: Formz.validate([
          state.materialReceiveDropdown,
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
        formStatus: FormStatus.invalid,
        // quantityField: QuantityField.dirty(state.quantityField.value,
        //     inStock: state.inStock),
        // materialDropdown: MaterialDropdown.dirty(state.materialDropdown.value),
        // materialReceiveDropdown:
        //     MaterialReceiveDropdown.dirty(state.materialReceiveDropdown.value),
        //     WarehouseDropdown.dirty(state.warehouseDropdown.value)
        // unitDropdown: UnitDropdown.dirty(state.unitDropdown.value),
        // remarkField: RemarkField.dirty(state.remarkField.value),
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
  // void onChange(Change<MaterialReceiveFormState> change) {
  //   super.onChange(change);
  //   print('Current State: ${change.currentState}');
  //   print('Next State: ${change.nextState}');
  // }

  // MaterialReceiveFormState copyWith({
  //   bool? isValid,
  //   FormStatus? formStatus,
  //   QuantityField? quantityField,
  // }) {
  //   return MaterialReceiveFormState(
  //     isValid: isValid ?? this.isValid,
  //     formStatus: formStatus ?? this.formStatus,
  //     quantityField: quantityField ?? this.quantityField,
  //   );
  // }
}
