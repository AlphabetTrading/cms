import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/home/domain/entities/material_transaction.dart';
import 'package:cms_mobile/features/home/domain/repository/material_transaction_repository.dart';

class GetMaterialTransactionUseCase
    implements UseCase<List<MaterialTransactionEntity>, void> {
      
  final MaterialTransactionRepository _materialTransactionRepository;

  GetMaterialTransactionUseCase(this._materialTransactionRepository);

  @override
  Future<DataState<List<MaterialTransactionEntity>>> call({void params}) {
    return _materialTransactionRepository.getMaterialTransactions();
  }
}
