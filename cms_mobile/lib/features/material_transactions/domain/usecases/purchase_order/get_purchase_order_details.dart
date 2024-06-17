import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/purchase_order.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/purchase_order_repository.dart';

class GetPurchaseOrderDetailsUseCase
    implements UseCase<PurchaseOrderEntity, String> {
  final PurchaseOrderRepository repository;

  GetPurchaseOrderDetailsUseCase(this.repository);

  @override
  Future<DataState<PurchaseOrderEntity>> call({String? params}) async {
    return await repository.getPurchaseOrderDetails(
      params: params!,
    );
  }
}
