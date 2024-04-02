import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/home/domain/repository/material_transaction_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receiving.dart';

class GetMaterialReceivingUseCase
    implements UseCase<List<MaterialReceivingEntity>, void> {
  final MaterialTransactionRepository _materialTransactionRepository;

  GetMaterialReceivingUseCase(this._materialTransactionRepository);

  @override
  Future<DataState<List<MaterialReceivingEntity>>> call({void params}) {
    return _materialTransactionRepository.getMaterialReceivings();
  }
}
