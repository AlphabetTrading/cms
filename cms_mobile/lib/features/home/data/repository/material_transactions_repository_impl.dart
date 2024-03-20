import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/data/data_source/remote_data_source.dart';
import 'package:cms_mobile/features/home/domain/entities/material_transaction.dart';
import 'package:cms_mobile/features/home/domain/repository/material_transaction_repository.dart';

class MaterialTransactionRepositoryImpl extends MaterialTransactionRepository {
  final MaterialTransactionsDataSource dataSource;

  MaterialTransactionRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<List<MaterialTransactionEntity>>> getMaterialTransactions() {
    return dataSource.fetchMaterialTransactions();
  }
}
