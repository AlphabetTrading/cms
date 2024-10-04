import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_issue_form/material_issue_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_issue/create_material_issue.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_issue/create_material_issue_form.dart';
import 'package:cms_mobile/features/products/domain/entities/product.dart';
import 'package:cms_mobile/features/warehouse/domain/entities/warehouse.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class MaterialIssueWarehouseFormCubit
    extends Cubit<MaterialIssueWarehouseFormState> {
  MaterialIssueWarehouseFormCubit({
    String? warehouseId,
  }) : super(MaterialIssueWarehouseFormState(
          warehouseDropdown: WarehouseDropdown.pure(warehouseId ?? ""),
        ));

  void warehouseChanged(WarehouseEntity warehouseEntity) {
    final WarehouseDropdown warehouseDropdown =
        WarehouseDropdown.dirty(warehouseEntity.id ?? "");

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
  // void onChange(Change<MaterialIssueFormState> change) {
  //   super.onChange(change);
  //   print('Current State: ${change.currentState}');
  //   print('Next State: ${change.nextState}');
  // }

  // MaterialIssueFormState copyWith({
  //   bool? isValid,
  //   FormStatus? formStatus,
  //   QuantityField? quantityField,
  // }) {
  //   return MaterialIssueFormState(
  //     isValid: isValid ?? this.isValid,
  //     formStatus: formStatus ?? this.formStatus,
  //     quantityField: quantityField ?? this.quantityField,
  //   );
  // }
}

class MaterialIssueFormCubit extends Cubit<MaterialIssueFormState> {
  MaterialIssueFormCubit({
    String? materialId,
    // String? warehouseId,
    double? quantity,
    SubStructureUseDescription? subUseDescription,
    SuperStructureUseDescription? superUseDescription,
    UseType? useType,
    double? inStock,
    String? remark,
  }) : super(MaterialIssueFormState(
            materialDropdown: MaterialDropdown.pure(materialId ?? ""),
            // warehouseDropdown: WarehouseDropdown.pure(warehouseId ?? ""),
            subStructureUseDropdown: SubStructureUseDropdown.pure(
              value:
                  subUseDescription ?? SubStructureUseDescription.DEFAULT_VALUE,
            ),
            superStructureUseDropdown: SuperStructureUseDropdown.pure(
                value: superUseDescription ??
                    SuperStructureUseDescription.DEFAULT_VALUE),
            useTypeDropdown:
                UseTypeDropdown.pure(useType ?? UseType.DEFAULT_VALUE),
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
          state.quantityField,
          state.materialDropdown,
          state.subStructureUseDropdown,
          state.superStructureUseDropdown,
          state.useTypeDropdown,
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
        materialDropdown: materialDropdown,
        inStock: materialEntity.quantity,
        isValid: Formz.validate([
          state.quantityField,
          state.materialDropdown,
          // state.warehouseDropdown,
          state.useTypeDropdown,
          state.subStructureUseDropdown,
          state.superStructureUseDropdown,
          // state.unitDropdown,
          state.remarkField
        ]),
      ),
    );
  }

  // void warehouseChanged(WarehouseEntity warehouseEntity) {
  //   final WarehouseDropdown warehouseDropdown =
  //       WarehouseDropdown.dirty(warehouseEntity.id);

  //   emit(
  //     state.copyWith(
  //       warehouseDropdown: warehouseDropdown,
  //       isValid: Formz.validate([
  //         state.quantityField,
  //         state.materialDropdown,
  //         state.warehouseDropdown,
  //         state.useTypeDropdown,
  //         state.subStructureUseDropdown,
  //         state.superStructureUseDropdown,
  //         // state.unitDropdown,
  //         state.remarkField
  //       ]),
  //     ),
  //   );
  // }

  void useTypeChanged(UseType value) {
    final UseTypeDropdown useTypeDropdown = UseTypeDropdown.dirty(value);

    emit(
      state.copyWith(
        useTypeDropdown: useTypeDropdown,
        isValid: Formz.validate([
          state.quantityField,
          state.materialDropdown,
          state.subStructureUseDropdown,
          // state.warehouseDropdown,

          state.superStructureUseDropdown,
          state.useTypeDropdown,
          // state.unitDropdown,
          state.remarkField
        ]),
      ),
    );
  }

  void subStructureDescriptionChanged(SubStructureUseDescription value) {
    final SubStructureUseDropdown subStructureUseDropdown =
        SubStructureUseDropdown.dirty(value,
            useType: state.useTypeDropdown.value);

    emit(
      state.copyWith(
        subStructureUseDropdown: subStructureUseDropdown,
        isValid: Formz.validate([
          state.quantityField,
          state.materialDropdown,
          state.subStructureUseDropdown,
          // state.warehouseDropdown,
          state.superStructureUseDropdown,
          state.useTypeDropdown,
          state.remarkField
        ]),
      ),
    );
  }

  void superStructureDescriptionChanged(SuperStructureUseDescription value) {
    final SuperStructureUseDropdown superStructureUseDropdown =
        SuperStructureUseDropdown.dirty(value,
            useType: state.useTypeDropdown.value);

    emit(
      state.copyWith(
        superStructureUseDropdown: superStructureUseDropdown,
        isValid: Formz.validate([
          state.quantityField,
          state.materialDropdown,
          // state.warehouseDropdown,
          state.subStructureUseDropdown,
          state.superStructureUseDropdown,
          state.useTypeDropdown,
          // state.unitDropdown,
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
          state.quantityField,
          state.materialDropdown,
          // state.warehouseDropdown,
          state.subStructureUseDropdown,
          state.superStructureUseDropdown,
          state.useTypeDropdown,
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
        // warehouseDropdown:
        //     WarehouseDropdown.dirty(state.warehouseDropdown.value),
        useTypeDropdown: UseTypeDropdown.dirty(state.useTypeDropdown.value),
        subStructureUseDropdown: SubStructureUseDropdown.dirty(
            state.subStructureUseDropdown.value,
            useType: state.useTypeDropdown.value),
        superStructureUseDropdown: SuperStructureUseDropdown.dirty(
            state.superStructureUseDropdown.value,
            useType: state.useTypeDropdown.value),
        // unitDropdown: UnitDropdown.dirty(state.unitDropdown.value),
        remarkField: RemarkField.dirty(state.remarkField.value),
        isValid: Formz.validate([
          state.quantityField,
          state.materialDropdown,
          // state.warehouseDropdown,
          state.subStructureUseDropdown,
          state.superStructureUseDropdown,
          state.useTypeDropdown,
          // state.unitDropdown,
          state.remarkField
        ]),
      ),
    );
  }

  // @override
  // void onChange(Change<MaterialIssueFormState> change) {
  //   super.onChange(change);
  //   print('Current State: ${change.currentState}');
  //   print('Next State: ${change.nextState}');
  // }

  // MaterialIssueFormState copyWith({
  //   bool? isValid,
  //   FormStatus? formStatus,
  //   QuantityField? quantityField,
  // }) {
  //   return MaterialIssueFormState(
  //     isValid: isValid ?? this.isValid,
  //     formStatus: formStatus ?? this.formStatus,
  //     quantityField: quantityField ?? this.quantityField,
  //   );
  // }
}
