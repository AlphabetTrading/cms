import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_requests/material_request_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_request.dart';

abstract class MaterialRequestEvent {
  const MaterialRequestEvent();
}

class GetMaterialRequestsEvent extends MaterialRequestEvent {
  const GetMaterialRequestsEvent();
}

class GetMaterialRequestEvent extends MaterialRequestEvent {
  final FilterMaterialRequestInput? filterMaterialRequestInput;
  final OrderByMaterialRequestInput? orderBy;
  final PaginationInput? paginationInput;
  final bool? mine;

  const GetMaterialRequestEvent(
      {this.filterMaterialRequestInput,
      this.orderBy,
      this.paginationInput,
      this.mine});
}

class CreateMaterialRequestEvent extends MaterialRequestEvent {
  final CreateMaterialRequestParamsEntity createMaterialRequestParamsEntity;

  const CreateMaterialRequestEvent(
      {required this.createMaterialRequestParamsEntity});
}

class UpdateMaterialRequestEvent extends MaterialRequestEvent {
  final String id;
  const UpdateMaterialRequestEvent(this.id);
}

class DeleteMaterialRequestEvent extends MaterialRequestEvent {
  final String id;
  const DeleteMaterialRequestEvent(this.id);
}
