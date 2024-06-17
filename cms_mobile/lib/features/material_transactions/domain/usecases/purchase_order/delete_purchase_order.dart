import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/purchase_order_repository.dart';

class DeletePurchaseOrderUseCase implements UseCase<String, String> {
  final PurchaseOrderRepository repository;

  DeletePurchaseOrderUseCase(this.repository);

  @override
  Future<DataState<String>> call({String? params}) async {
    return await repository.deletePurchaseOrder(
      materialId: params!,
    );
  }
}
