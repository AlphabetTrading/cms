import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_receive_form/material_receive_form_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/material_receive/create_material_receive.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_receive/create_material_receive_form.dart';
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
        formStatus: FormStatus.validating,
        warehouseDropdown:
            WarehouseDropdown.dirty(state.warehouseDropdown.value),
        isValid: Formz.validate([
          state.warehouseDropdown,
        ]),
      ),
    );
  }

  @override
  void onChange(Change<MaterialReceiveWarehouseFormState> change) {
    super.onChange(change);
    print('warehouse Current State: ${change.currentState}');
    print('warehouse Next State: ${change.nextState}');
  }
}

class MaterialReceiveFormCubit extends Cubit<MaterialReceiveFormState> {
  MaterialReceiveFormCubit({
    String? materialId,
    String? purchaseOrderItemId,
    // String? warehouseId,
    double? transportationCost,
    double? loadingCost,
    double? unloadingCost,
    double? receivedQuantity,
    String? remark,
  }) : super(MaterialReceiveFormState(
            receivedQuantityField:NumberField.pure(value:receivedQuantity.toString()),
            materialDropdown: MaterialDropdown.pure(materialId ?? ""),
            purchaseOrderDropdown:
                PurchaseOrderDropdown.pure(purchaseOrderItemId ?? ""),
            transportationField:
                NumberField.pure(value: transportationCost.toString()),
            loadingField: NumberField.pure(value: loadingCost.toString()),
            unloadingField: NumberField.pure(value: unloadingCost.toString()),
            remarkField: RemarkField.pure(remark ?? "")));

  void receivedQuantityChanged(String value) {
    final NumberField receivedQuantityField = NumberField.dirty(value);

    emit(
      state.copyWith(
        receivedQuantityField: receivedQuantityField,
        isValid: Formz.validate([
          state.transportationField,
          state.loadingField,
          state.unloadingField,
          state.materialDropdown,
          state.purchaseOrderDropdown,
          state.remarkField,
          state.receivedQuantityField
        ]),
      ),
    );
  }
            

  void materialChanged(IssueVoucherMaterialEntity materialEntity) {
    final MaterialDropdown materialDropdown =
        MaterialDropdown.dirty(materialEntity.productVariant?.id ?? "");

    emit(
      state.copyWith(
        materialDropdown: materialDropdown,
        isValid: Formz.validate([
          state.transportationField,
          state.loadingField,
          state.unloadingField,
          state.materialDropdown,
          state.purchaseOrderDropdown,
          state.remarkField,
          state.receivedQuantityField
        ]),
      ),
    );
  }

  void purchaseOrderChanged(MaterialIssueEntity materialIssueEntity) {
    final PurchaseOrderDropdown materialIssueDropdown =
        PurchaseOrderDropdown.dirty(materialIssueEntity.id!);

    emit(
      state.copyWith(
        purchaseOrderDropdown: materialIssueDropdown,
        materialDropdown: MaterialDropdown.pure(),
        isValid: Formz.validate([
          state.transportationField,
          state.loadingField,
          state.unloadingField,
          state.materialDropdown,
          state.purchaseOrderDropdown,
          state.remarkField,
          state.receivedQuantityField
        ]),
      ),
    );
  }

  void loadingChanged(String value) {
    final NumberField loadingField = NumberField.dirty(value);

    emit(
      state.copyWith(
        loadingField: loadingField,
        isValid: Formz.validate([
          state.transportationField,
          state.loadingField,
          state.unloadingField,
          state.materialDropdown,
          state.purchaseOrderDropdown,
          state.remarkField,
          state.receivedQuantityField
        ]),
      ),
    );
  }

  void unloadingChanged(String value) {
    final NumberField unloadingField = NumberField.dirty(value);

    emit(
      state.copyWith(
        unloadingField: unloadingField,
        isValid: Formz.validate([
          state.transportationField,
          state.loadingField,
          state.unloadingField,
          state.materialDropdown,
          state.purchaseOrderDropdown,
          state.remarkField,
          state.receivedQuantityField
        ]),
      ),
    );
  }

  void transportationChanged(String value) {
    final NumberField transportationField = NumberField.dirty(value);

    emit(
      state.copyWith(
        transportationField: transportationField,
        isValid: Formz.validate([
          state.transportationField,
          state.loadingField,
          state.unloadingField,
          state.materialDropdown,
          state.purchaseOrderDropdown,
          state.remarkField,
          state.receivedQuantityField
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
  //         state.remarkField,
  // state.receivedQuantityField
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
          state.transportationField,
          state.loadingField,
          state.unloadingField,
          state.materialDropdown,
          state.purchaseOrderDropdown,
          state.remarkField,
          state.receivedQuantityField
        ]),
      ),
    );
  }

  void onSubmit() {
    emit(
      state.copyWith(
        formStatus: FormStatus.validating,
        materialDropdown: MaterialDropdown.dirty(state.materialDropdown.value),
        purchaseOrderDropdown:
            PurchaseOrderDropdown.dirty(state.purchaseOrderDropdown.value),
        transportationField: NumberField.dirty(state.transportationField.value),
        loadingField: NumberField.dirty(state.loadingField.value),
        unloadingField: NumberField.dirty(state.unloadingField.value),
        remarkField: RemarkField.dirty(state.remarkField.value),
        receivedQuantityField:NumberField.dirty(state.receivedQuantityField.value),
        isValid: Formz.validate([
          state.transportationField,
          state.loadingField,
          state.unloadingField,
          state.materialDropdown,
          state.purchaseOrderDropdown,
          state.remarkField,
          state.receivedQuantityField
        ]),
      ),
    );
  }

  @override
  void onChange(Change<MaterialReceiveFormState> change) {
    super.onChange(change);
    print('Current State: ${change.currentState}');
    print('Next State: ${change.nextState}');
  }
}
