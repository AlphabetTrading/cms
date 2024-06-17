import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/domain/entities/material_transaction.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';

abstract class VouchersRepository {
  Future<DataState<List<MaterialTransactionEntity>>> getMaterialTransactions();
 
  Future<DataState<PurchaseOrdersListWithMeta>> getPurchaseOrders(
    FilterPurchaseOrderInput? filterPurchaseOrderInput,
    OrderByPurchaseOrderInput? orderBy,
    PaginationInput? paginationInput,
  );
}
