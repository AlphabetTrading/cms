
import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_requests/domain/entities/material_request.dart';
import 'package:cms_mobile/features/material_requests/domain/repository/material_request_repository.dart';

class GetMaterialRequestUseCase implements UseCase<List<MaterialRequestEntity>,void>{
  
  final MaterialReceivingRepository _materialReceivingRepository;

  GetMaterialRequestUseCase(this._materialReceivingRepository);
  
  @override
  Future<DataState<List<MaterialRequestEntity>>> call({void params}) {
    return _materialReceivingRepository.getMaterialRequests();
  }
}