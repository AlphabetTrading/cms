import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:equatable/equatable.dart';

class MaterialIssueState extends Equatable {
  final MaterialIssueEntityListWithMeta? materialIssues;
  final MaterialIssueEntityListWithMeta? myMaterialIssues;
  final MaterialIssueEntity? materialIssue;
  final bool hasReachedMax;

  final Failure? error;

  const MaterialIssueState({
    this.materialIssues,
    this.myMaterialIssues,
    this.error,
    this.materialIssue,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [
        materialIssues,
        myMaterialIssues,
        error,
        materialIssue,
        hasReachedMax,
      ];

  @override
  String toString() {
    return 'MaterialIssueState { materialIssues: $materialIssues, myMaterialIssues: $myMaterialIssues, error: $error, materialIssue: $materialIssue, hasReachedMax: $hasReachedMax }';
  }

  MaterialIssueState copyWith({
    MaterialIssueEntityListWithMeta? materialIssues,
    MaterialIssueEntityListWithMeta? myMaterialIssues,
    MaterialIssueEntity? materialIssue,
    bool? hasReachedMax,
    Failure? error,
  }) {
    return MaterialIssueState(
      materialIssues: materialIssues ?? this.materialIssues,
      myMaterialIssues: myMaterialIssues ?? this.myMaterialIssues,
      materialIssue: materialIssue ?? this.materialIssue,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error ?? this.error,
    );
  
  }

 
}

class MaterialIssueInitial extends MaterialIssueState {
  const MaterialIssueInitial();
}

class MaterialIssuesLoading extends MaterialIssueState {
  const MaterialIssuesLoading();
}

class MaterialIssuesSuccess extends MaterialIssueState {
  const MaterialIssuesSuccess(
      {required MaterialIssueEntityListWithMeta materialIssues,
      required MaterialIssueEntityListWithMeta myMaterialIssues})
      : super(
            materialIssues: materialIssues, myMaterialIssues: myMaterialIssues);

  // MaterialIssuesSuccess copyWith({
  //   MaterialIssueEntityListWithMeta? materialIssues,
  //   MaterialIssueEntityListWithMeta? myMaterialIssues,
  //   bool? hasReachedMax,
  // }) {
  //   return MaterialIssuesSuccess(
  //     materialIssues: materialIssues ?? this.materialIssues!,
  //     myMaterialIssues: myMaterialIssues ?? this.myMaterialIssues!,
  //   );
  // }

   MaterialIssueState copyWith({
    MaterialIssueEntityListWithMeta? materialIssues,
    MaterialIssueEntityListWithMeta? myMaterialIssues,
    MaterialIssueEntity? materialIssue,
    bool? hasReachedMax,
    Failure? error,
  }) {
    return MaterialIssuesSuccess(
      materialIssues: materialIssues ?? this.materialIssues!,
      myMaterialIssues: myMaterialIssues ?? this.myMaterialIssues!,
    );
  }
}

class MaterialIssuesFailed extends MaterialIssueState {
  const MaterialIssuesFailed({required Failure error}) : super(error: error);
}

class MaterialIssuesEmpty extends MaterialIssueState {
  const MaterialIssuesEmpty();
}

// Get Material Issue Details
// class MaterialIssueDetailsLoading extends MaterialIssueState {
//   const MaterialIssueDetailsLoading();
// }

// class MaterialIssueDetailsSuccess extends MaterialIssueState {
//   const MaterialIssueDetailsSuccess(
//       {required MaterialIssueEntity materialIssue})
//       : super(materialIssue: materialIssue);
// }

// class MaterialIssueDetailsFailed extends MaterialIssueState {
//   const MaterialIssueDetailsFailed({required Failure error})
//       : super(error: error);
// }

// Create Material Issue
class CreateMaterialIssueLoading extends MaterialIssueState {
  const CreateMaterialIssueLoading();
}

class CreateMaterialIssueSuccess extends MaterialIssueState {
  const CreateMaterialIssueSuccess();
}

class CreateMaterialIssueFailed extends MaterialIssueState {
  const CreateMaterialIssueFailed({required Failure error})
      : super(error: error);
}


class ApproveMaterialIssueLoading extends MaterialIssueState {
  const ApproveMaterialIssueLoading();
}

class ApproveMaterialIssueSuccess extends MaterialIssueState {
  const ApproveMaterialIssueSuccess();
}

class ApproveMaterialIssueFailed extends MaterialIssueState {
  const ApproveMaterialIssueFailed({required Failure error})
      : super(error: error);
}
