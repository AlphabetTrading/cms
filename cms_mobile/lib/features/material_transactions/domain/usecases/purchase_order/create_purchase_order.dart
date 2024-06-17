import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/purchase_order_repository.dart';

class CreatePurchaseOrderUseCase
    implements UseCase<String, CreatePurchaseOrderParamsEntity> {
  final PurchaseOrderRepository repository;

  CreatePurchaseOrderUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {CreatePurchaseOrderParamsEntity? params}) async {
    return await repository.createPurchaseOrder(
      params: params!,
    );
  }
}
