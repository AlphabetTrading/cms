import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/core/usecase/usecase.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_receiving.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_receive.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_issue_repository.dart';
import 'package:cms_mobile/features/material_transactions/domain/repository/material_receive_repository.dart';

class ApproveMaterialReceiveUseCase
    implements UseCase<String, ApproveMaterialReceiveParamsEntity> {
  final MaterialReceiveRepository repository;

  ApproveMaterialReceiveUseCase(this.repository);

  @override
  Future<DataState<String>> call(
      {ApproveMaterialReceiveParamsEntity? params}) async {
    return await repository.approveMaterialReceive(
     params: params!
    );
  }
}
