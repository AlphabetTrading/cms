import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/daily_site_data/daily_site_data_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';

abstract class DailySiteDataEvent {
  const DailySiteDataEvent();
}

class GetDailySiteDatas extends DailySiteDataEvent {
  final FilterDailySiteDataInput? filterDailySiteDataInput;
  final OrderByDailySiteDataInput? orderBy;
  final PaginationInput? paginationInput;
  final bool? mine;
  const GetDailySiteDatas({
    this.filterDailySiteDataInput,
    this.orderBy,
    this.paginationInput,
    this.mine,
  });
}

class GetDailySiteData extends DailySiteDataEvent {
  final FilterDailySiteDataInput filterDailySiteDataInput;
  final OrderByDailySiteDataInput orderBy;
  final PaginationInput paginationInput;
  const GetDailySiteData(
    this.filterDailySiteDataInput,
    this.orderBy,
    this.paginationInput,
  );
}

class GetDailySiteDataDetailsEvent extends DailySiteDataEvent {
  final String dailySiteDataId;
  const GetDailySiteDataDetailsEvent({required this.dailySiteDataId});
}

class UpdateDailySiteData extends DailySiteDataEvent {
  final String id;
  const UpdateDailySiteData(this.id);
}

class DeleteDailySiteData extends DailySiteDataEvent {
  final String id;
  const DeleteDailySiteData(this.id);
}

class CreateDailySiteDataEvent extends DailySiteDataEvent {
  final CreateDailySiteDataParamsEntity createDailySiteDataParamsEntity;

  const CreateDailySiteDataEvent(
      {required this.createDailySiteDataParamsEntity});
}

class UpdateDailySiteDataEvent extends DailySiteDataEvent {
  final String id;
  const UpdateDailySiteDataEvent(this.id);
}

class DeleteDailySiteDataEventLocal extends DailySiteDataEvent {
  final String dailySiteDataId;
  final bool isMine;
  const DeleteDailySiteDataEventLocal({
    required this.dailySiteDataId,
    required this.isMine,
  });
}
