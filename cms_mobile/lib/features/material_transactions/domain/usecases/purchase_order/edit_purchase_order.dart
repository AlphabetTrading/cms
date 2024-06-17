import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/purchase_order_repository.dart';

class EditPurchaseOrderUseCase
    implements UseCase<String, EditPurchaseOrderParamsEntity> {
  final PurchaseOrderRepository repository;

  EditPurchaseOrderUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {EditPurchaseOrderParamsEntity? params}) async {
    return await repository.editPurchaseOrder(
      params: params!,
    );
  }
}
