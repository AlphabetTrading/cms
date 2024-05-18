import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/items/domain/usecases/get_items.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_event.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final GetItemsUseCase _getItemsUseCase;
  ItemBloc(this._getItemsUseCase) : super(const ItemInitial()) {
    on<GetItems>(onGetItems);
  }

  void onGetItems(GetItems event, Emitter<ItemState> emit) async {
    emit(const ItemsLoading());
    
    final dataState = await _getItemsUseCase(params: event.getItemsInputEntity);
    
    
    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(ItemsSuccess(items: dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(ItemsFailed(error: dataState.error!));
    }
  }
}
