import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/domain/entities/material_transaction.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/vouchers_repository.dart';
import 'package:flutter/material.dart';

class VoucherRepositoryImpl extends VouchersRepository {
  final VoucherDataSource dataSource;

  VoucherRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<List<MaterialRequestEntity>>> getMaterialRequests() {
    return dataSource.fetchMaterialRequests();
  }

  @override
  Future<DataState<
  MaterialIssueListWithMeta
  >> getMaterialIssues(
      FilterMaterialIssueInput? filterMaterialIssueInput,
      OrderByMaterialIssueInput? orderBy,
      PaginationInput? paginationInput) {
    debugPrint(
        'getMaterialIssues, filterMaterialIssueInput: $filterMaterialIssueInput, orderBy: $orderBy, paginationInput: $paginationInput');

    return dataSource.fetchMaterialIssues(
      filterMaterialIssueInput: filterMaterialIssueInput,
      orderBy: orderBy,
      paginationInput: paginationInput,
    );
  }

  @override
  Future<DataState<List<MaterialReceivingEntity>>> getMaterialReceivings() {
    throw UnimplementedError();
  }

  @override
  Future<DataState<List<MaterialReturnEntity>>> getMaterialReturns() {
    throw UnimplementedError();
  }

  @override
  Future<DataState<List<MaterialTransactionEntity>>> getMaterialTransactions() {
    throw UnimplementedError();
  }

  @override
  Future<DataState<List<PurchaseOrderEntity>>> getPurchaseOrders() {
    throw UnimplementedError();
  }
}
