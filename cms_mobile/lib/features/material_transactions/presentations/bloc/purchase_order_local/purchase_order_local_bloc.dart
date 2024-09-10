import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/purchase_order_local/purchase_order_local_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseOrderLocalBloc
    extends Bloc<PurchaseOrderLocalEvent, PurchaseOrderLocalState> {
  PurchaseOrderLocalBloc() : super(const PurchaseOrderLocalState()) {
    on<GetPurchaseOrderMaterialsLocal>((event, emit) {});

    on<AddPurchaseOrderMaterialLocal>((event, emit) {
      final updatedList = List<PurchaseOrderMaterialEntity>.from(
          state.purchaseOrderMaterials ?? [])
        ..add(event.purchaseOrderMaterial);
      emit(PurchaseOrderLocalState(purchaseOrderMaterials: updatedList));
    });

    on<DeletePurchaseOrderMaterialLocal>((event, emit) {
      final updatedList = List<PurchaseOrderMaterialEntity>.from(
          state.purchaseOrderMaterials ?? [])
        ..removeAt(event.index);
      emit(PurchaseOrderLocalState(purchaseOrderMaterials: updatedList));
    });
    on<EditPurchaseOrderMaterialLocal>((event, emit) {
      final updatedList = List<PurchaseOrderMaterialEntity>.from(
          state.purchaseOrderMaterials ?? [])
        ..removeAt(event.index)
        ..insert(event.index, event.purchaseOrderMaterial);
      emit(PurchaseOrderLocalState(purchaseOrderMaterials: updatedList));
    });

    on<ClearPurchaseOrderMaterialsLocal>((event, emit) {
      emit(const PurchaseOrderLocalState(purchaseOrderMaterials: []));
    });
  }
}
