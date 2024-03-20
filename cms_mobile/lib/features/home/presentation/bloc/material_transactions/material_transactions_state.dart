import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/domain/entities/material_transaction.dart';
import 'package:equatable/equatable.dart';

abstract class MaterialTransactionState extends Equatable {
  final List<MaterialTransactionEntity>? materialTransactions;
  final Failure? error;

  const MaterialTransactionState({this.materialTransactions, this.error});

  @override
  List<Object?> get props => [materialTransactions, error];
}

class MaterialTransactionInitial extends MaterialTransactionState {
  const MaterialTransactionInitial();
}

class MaterialTransactionLoading extends MaterialTransactionState {
  const MaterialTransactionLoading();
}

class MaterialTransactionsuccess extends MaterialTransactionState {
  const MaterialTransactionsuccess(
      {required List<MaterialTransactionEntity> materialTransactions})
      : super(materialTransactions: materialTransactions);
}

class MaterialTransactionFailed extends MaterialTransactionState {
  const MaterialTransactionFailed({required Failure error})
      : super(error: error);
}

class MaterialTransactionEmpty extends MaterialTransactionState {
  const MaterialTransactionEmpty();
}
