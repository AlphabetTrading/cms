import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:equatable/equatable.dart';

abstract class MaterialIssueState extends Equatable {
  final MaterialIssueEntityListWithMeta? materialIssues;
  final MaterialIssueEntity? materialIssue;

  final Failure? error;

  const MaterialIssueState(
      {this.materialIssues, this.error, this.materialIssue});

  @override
  List<Object?> get props => [materialIssues, error];
}

class MaterialIssueInitial extends MaterialIssueState {
  const MaterialIssueInitial();
}

class MaterialIssuesLoading extends MaterialIssueState {
  const MaterialIssuesLoading();
}

class MaterialIssuesSuccess extends MaterialIssueState {
  const MaterialIssuesSuccess(
      {required MaterialIssueEntityListWithMeta materialIssues})
      : super(materialIssues: materialIssues);
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
