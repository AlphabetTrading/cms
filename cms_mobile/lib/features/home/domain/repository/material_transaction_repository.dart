import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/domain/entities/material_transaction.dart';

abstract class MaterialTransactionRepository {
  Future<DataState<List<MaterialTransactionEntity>>> getMaterialTransactions();
}
