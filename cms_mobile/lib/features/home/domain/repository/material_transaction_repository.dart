import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/domain/entities/material_transaction.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';

abstract class MaterialTransactionRepository {
  Future<DataState<List<MaterialTransactionEntity>>> getMaterialTransactions();
  Future<DataState<List<PurchaseOrderEntity>>> getPurchaseOrders();
  Future<DataState<List<MaterialRequestEntity>>> getMaterialRequests();
  Future<DataState<List<MaterialReceiveEntity>>> getMaterialReceivings();
  Future<DataState<List<MaterialIssueEntity>>> getMaterialIssues();
  Future<DataState<List<MaterialReturnEntity>>> getMaterialReturns();
}
