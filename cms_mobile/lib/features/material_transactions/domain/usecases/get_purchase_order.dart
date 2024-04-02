import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/home/domain/repository/material_transaction_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart.dart';

class GetPurchaseOrderUseCase
    implements UseCase<List<PurchaseOrderEntity>, void> {
  final MaterialTransactionRepository _materialTransactionRepository;

  GetPurchaseOrderUseCase(this._materialTransactionRepository);

  @override
  Future<DataState<List<PurchaseOrderEntity>>> call({void params}) {
    return _materialTransactionRepository.getPurchaseOrders();
  }
}
