import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:equatable/equatable.dart';

class DailySiteDataState extends Equatable {
  final DailySiteDataEntityListWithMeta? dailySiteDatas;
  final DailySiteDataEntityListWithMeta? myDailySiteDatas;
  final DailySiteDataEntity? dailySiteData;
  final bool hasReachedMax;

  final Failure? error;

  const DailySiteDataState({
    this.dailySiteDatas,
    this.myDailySiteDatas,
    this.error,
    this.dailySiteData,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [
        dailySiteDatas,
        myDailySiteDatas,
        error,
        dailySiteData,
        hasReachedMax,
      ];

  @override
  String toString() {
    return 'DailySiteDataState { DailySiteDatas: $dailySiteDatas, myDailySiteDatas: $myDailySiteDatas, error: $error, DailySiteData: $dailySiteData, hasReachedMax: $hasReachedMax }';
  }

  DailySiteDataState copyWith({
    DailySiteDataEntityListWithMeta? dailySiteDatas,
    DailySiteDataEntityListWithMeta? myDailySiteDatas,
    DailySiteDataEntity? dailySiteData,
    bool? hasReachedMax,
    Failure? error,
  }) {
    return DailySiteDataState(
      dailySiteDatas: dailySiteDatas ?? this.dailySiteDatas,
      myDailySiteDatas: myDailySiteDatas ?? this.myDailySiteDatas,
      dailySiteData: dailySiteData ?? this.dailySiteData,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error ?? this.error,
    );
  }
}

class DailySiteDataInitial extends DailySiteDataState {
  const DailySiteDataInitial();
}

class DailySiteDatasLoading extends DailySiteDataState {
  const DailySiteDatasLoading();
}

class DailySiteDatasSuccess extends DailySiteDataState {
  const DailySiteDatasSuccess(
      {required DailySiteDataEntityListWithMeta dailySiteDatas,
      required DailySiteDataEntityListWithMeta myDailySiteDatas})
      : super(
            dailySiteDatas: dailySiteDatas, myDailySiteDatas: myDailySiteDatas);

  // DailySiteDatasSuccess copyWith({
  //   DailySiteDataEntityListWithMeta? DailySiteDatas,
  //   DailySiteDataEntityListWithMeta? myDailySiteDatas,
  //   bool? hasReachedMax,
  // }) {
  //   return DailySiteDatasSuccess(
  //     DailySiteDatas: DailySiteDatas ?? this.DailySiteDatas!,
  //     myDailySiteDatas: myDailySiteDatas ?? this.myDailySiteDatas!,
  //   );
  // }

  DailySiteDataState copyWith({
    DailySiteDataEntityListWithMeta? dailySiteDatas,
    DailySiteDataEntityListWithMeta? myDailySiteDatas,
    DailySiteDataEntity? dailySiteData,
    bool? hasReachedMax,
    Failure? error,
  }) {
    return DailySiteDatasSuccess(
      dailySiteDatas: dailySiteDatas ?? this.dailySiteDatas!,
      myDailySiteDatas: myDailySiteDatas ?? this.myDailySiteDatas!,
    );
  }
}

class DailySiteDatasFailed extends DailySiteDataState {
  const DailySiteDatasFailed({required Failure error}) : super(error: error);
}

class DailySiteDatasEmpty extends DailySiteDataState {
  const DailySiteDatasEmpty();
}

// Get Material Issue Details
// class DailySiteDataDetailsLoading extends DailySiteDataState {
//   const DailySiteDataDetailsLoading();
// }

// class DailySiteDataDetailsSuccess extends DailySiteDataState {
//   const DailySiteDataDetailsSuccess(
//       {required DailySiteDataEntity DailySiteData})
//       : super(DailySiteData: DailySiteData);
// }

// class DailySiteDataDetailsFailed extends DailySiteDataState {
//   const DailySiteDataDetailsFailed({required Failure error})
//       : super(error: error);
// }

// Create Material Issue
class CreateDailySiteDataLoading extends DailySiteDataState {
  const CreateDailySiteDataLoading();
}

class CreateDailySiteDataSuccess extends DailySiteDataState {
  const CreateDailySiteDataSuccess();
}

class CreateDailySiteDataFailed extends DailySiteDataState {
  const CreateDailySiteDataFailed({required Failure error})
      : super(error: error);
}
