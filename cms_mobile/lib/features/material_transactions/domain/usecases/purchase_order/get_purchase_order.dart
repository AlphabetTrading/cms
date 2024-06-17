import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/home/domain/repository/material_transaction_repository.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/purchase_order_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/vouchers_repository.dart';

class GetPurchaseOrderUseCase
    implements UseCase<List<PurchaseOrderEntity>, void> {
  final MaterialTransactionRepository _materialTransactionRepository;

  GetPurchaseOrderUseCase(this._materialTransactionRepository);

  @override
  Future<DataState<List<PurchaseOrderEntity>>> call({void params}) {
    return _materialTransactionRepository.getPurchaseOrders();
  }
}

class GetPurchaseOrdersUseCase
    implements UseCase<PurchaseOrderEntityListWithMeta, PurchaseOrderParams?> {
  final PurchaseOrderRepository _purchaseOrderRepository;

  GetPurchaseOrdersUseCase(this._purchaseOrderRepository);

  @override
  Future<DataState<PurchaseOrderEntityListWithMeta>> call(
      {PurchaseOrderParams? params}) {
    return _purchaseOrderRepository.getPurchaseOrders(
      filterPurchaseOrderInput: params?.filterPurchaseOrderInput,
      orderBy: params?.orderBy,
      paginationInput: params?.paginationInput,
    );
  }
}

class PurchaseOrderParams {
  FilterPurchaseOrderInput? filterPurchaseOrderInput;
  OrderByPurchaseOrderInput? orderBy;
  PaginationInput? paginationInput;

  PurchaseOrderParams({
    this.filterPurchaseOrderInput,
    this.orderBy,
    this.paginationInput,
  });
}
