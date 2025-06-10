import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/data/models/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/purchase_order_repository.dart';

class ApprovePurchaseOrderUseCase
    implements UseCase<String, ApprovePurchaseOrderParamsModel> {
  final PurchaseOrderRepository repository;

  ApprovePurchaseOrderUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {ApprovePurchaseOrderParamsModel? params}) async {
    return await repository.approvePurchaseOrder(
      decision: params!.decision,
      purchaseOrderId: params.purchaseOrderId,
    );
  }
}
