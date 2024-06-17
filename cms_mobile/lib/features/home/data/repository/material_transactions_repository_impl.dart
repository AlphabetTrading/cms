import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/home/domain/entities/material_transaction.dart';
import 'package:cms_mobile/features/home/domain/repository/material_transaction_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';

class MaterialTransactionRepositoryImpl extends MaterialTransactionRepository {
  final MaterialTransactionsDataSource dataSource;

  MaterialTransactionRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<List<MaterialTransactionEntity>>> getMaterialTransactions() {
    return dataSource.fetchMaterialTransactions();
  }

  @override
  Future<DataState<List<MaterialIssueEntity>>> getMaterialIssues(
      
  ) {
    // TODO: implement getMaterialIssues
    throw UnimplementedError();
  }

  @override
  Future<DataState<List<MaterialReceiveEntity>>> getMaterialReceivings() {
    // TODO: implement getMaterialReceivings
    throw UnimplementedError();
  }

  @override
  Future<DataState<List<MaterialRequestEntity>>> getMaterialRequests() {
    // TODO: implement getMaterialRequests
    throw UnimplementedError();
  }

  @override
  Future<DataState<List<MaterialReturnEntity>>> getMaterialReturns() {
    // TODO: implement getMaterialReturns
    throw UnimplementedError();
  }

  @override
  Future<DataState<List<PurchaseOrderEntity>>> getPurchaseOrders() {
    // TODO: implement getPurchaseOrders
    throw UnimplementedError();
  }
}
