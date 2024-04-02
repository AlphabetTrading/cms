import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/home/domain/repository/material_transaction_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_return.dart';

class GetMaterialReturnUseCase
    implements UseCase<List<MaterialReturnEntity>, void> {
  final MaterialTransactionRepository _materialTransactionRepository;

  GetMaterialReturnUseCase(this._materialTransactionRepository);

  @override
  Future<DataState<List<MaterialReturnEntity>>> call({void params}) {
    return _materialTransactionRepository.getMaterialReturns();
  }
}
