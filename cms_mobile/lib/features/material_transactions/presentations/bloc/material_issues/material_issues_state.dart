import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:equatable/equatable.dart';

abstract class MaterialIssueState extends Equatable {
  final MaterialIssueEntityListWithMeta? materialIssues;
  final Failure? error;

  const MaterialIssueState({this.materialIssues, this.error});

  @override
  List<Object?> get props => [materialIssues, error];
}

class MaterialIssueInitial extends MaterialIssueState {
  const MaterialIssueInitial();
}

class MaterialIssueLoading extends MaterialIssueState {
  const MaterialIssueLoading();
}

class MaterialIssueSuccess extends MaterialIssueState {
  const MaterialIssueSuccess(
      {required MaterialIssueEntityListWithMeta materialIssues})
      : super(materialIssues: materialIssues);
}

class MaterialIssueFailed extends MaterialIssueState {
  const MaterialIssueFailed({required Failure error}) : super(error: error);
}

class MaterialIssueEmpty extends MaterialIssueState {
  const MaterialIssueEmpty();
}
