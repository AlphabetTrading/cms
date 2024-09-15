import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/purchase_order/purchase_order_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/purchase_order_repository.dart';

class PurchaseOrderRepositoryImpl extends PurchaseOrderRepository {
  final PurchaseOrderDataSource dataSource;

  PurchaseOrderRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<String>> createPurchaseOrder(
      {required CreatePurchaseOrderParamsEntity params}) {
    return dataSource.createPurchaseOrder(
        createPurchaseOrderParamsModel:
            CreatePurchaseOrderParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<PurchaseOrderModel>> getPurchaseOrderDetails(
      {required String params}) {
    return dataSource.getPurchaseOrderDetails(params: params);
  }

  @override
  Future<DataState<String>> editPurchaseOrder(
      {required EditPurchaseOrderParamsEntity params}) {
    return dataSource.editPurchaseOrder(
        editPurchaseOrderParamsModel:
            EditPurchaseOrderParamsModel.fromEntity(params));
  }

  @override
  Future<DataState<String>> deletePurchaseOrder({required String materialId}) {
    return dataSource.deletePurchaseOrder(materialId: materialId);
  }

  @override
  Future<DataState<String>> generatePurchaseOrderPdf({required String id}) {
    return dataSource.generatePurchaseOrderPdf(id: id);
  }

  @override
  Future<DataState<PurchaseOrderEntityListWithMeta>> getPurchaseOrders(
      {FilterPurchaseOrderInput? filterPurchaseOrderInput,
      OrderByPurchaseOrderInput? orderBy,
      PaginationInput? paginationInput,
      bool? mine}) {
    return dataSource.fetchPurchaseOrders(
      filterPurchaseOrderInput: filterPurchaseOrderInput,
      orderBy: orderBy,
      paginationInput: paginationInput,
      mine: mine,
    );
  }
}
