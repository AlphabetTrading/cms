import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/home/domain/repository/material_transaction_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';

class GetMaterialRequestUseCase
    implements UseCase<List<MaterialRequestEntity>, void> {
  final MaterialTransactionRepository _materialTransactionRepository;

  GetMaterialRequestUseCase(this._materialTransactionRepository);

  @override
  Future<DataState<List<MaterialRequestEntity>>> call({void params}) {
    return _materialTransactionRepository.getMaterialRequests();
  }
}
