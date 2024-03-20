import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/home/domain/usecases/get_material_transactions.dart';
import 'package:cms_mobile/features/home/presentation/bloc/material_transactions/material_transactions_event.dart';
import 'package:cms_mobile/features/home/presentation/bloc/material_transactions/material_transactions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialTransactionBloc
    extends Bloc<MaterialTransactionEvent, MaterialTransactionState> {
  final GetMaterialTransactionUseCase _materialTransactionUseCase;

  MaterialTransactionBloc(this._materialTransactionUseCase)
      : super(const MaterialTransactionInitial()) {
    on<GetMaterialTransactions>(onGetMaterialTransactions);
  }

  void onGetMaterialTransactions(GetMaterialTransactions event,
      Emitter<MaterialTransactionState> emit) async {
    emit(const MaterialTransactionLoading());
    final dataState = await _materialTransactionUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(MaterialTransactionsuccess(materialTransactions: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(MaterialTransactionFailed(error: dataState.error!));
    }
  }
}
