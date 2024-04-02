import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/domain/entities/material_transaction.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart.dart';

abstract class VouchersRepository {
  Future<DataState<List<MaterialTransactionEntity>>> getMaterialTransactions();
  Future<DataState<List<PurchaseOrderEntity>>> getPurchaseOrders();
  Future<DataState<List<MaterialRequestEntity>>> getMaterialRequests();
  Future<DataState<List<MaterialReceivingEntity>>> getMaterialReceivings();
  Future<DataState<MaterialIssueListWithMeta>> getMaterialIssues(
    FilterMaterialIssueInput? filterMaterialIssueInput,
    OrderByMaterialIssueInput? orderBy,
    PaginationInput? paginationInput,
  );
  Future<DataState<List<MaterialReturnEntity>>> getMaterialReturns();
}
