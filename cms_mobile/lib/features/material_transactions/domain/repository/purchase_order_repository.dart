import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';

abstract class PurchaseOrderRepository {
  Future<DataState<String>> createPurchaseOrder(
      {required CreatePurchaseOrderParamsEntity params});

  Future<DataState<PurchaseOrderEntity>> getPurchaseOrderDetails(
      {required String params});

  Future<DataState<String>> editPurchaseOrder(
      {required EditPurchaseOrderParamsEntity params});

  Future<DataState<String>> deletePurchaseOrder({required String materialId});

  Future<DataState<String>> generatePurchaseOrderPdf({required String id});

  Future<DataState<PurchaseOrderEntityListWithMeta>> getPurchaseOrders({
    FilterPurchaseOrderInput? filterPurchaseOrderInput,
    OrderByPurchaseOrderInput? orderBy,
    PaginationInput? paginationInput,
    bool? mine,
  });
}
