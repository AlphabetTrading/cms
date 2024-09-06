import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/purchase_order_repository.dart';

class GeneratePurchaseOrderPdfUseCase implements UseCase<String, String> {
  final PurchaseOrderRepository repository;

  GeneratePurchaseOrderPdfUseCase(this.repository);

  @override
  Future<DataState<String>> call({String? params}) async {
    return await repository.generatePurchaseOrderPdf(
      id: params!,
    );
  }
}
