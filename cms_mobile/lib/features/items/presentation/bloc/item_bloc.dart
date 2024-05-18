import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/items/domain/usecases/get_all_warehouse_items.dart';
import 'package:cms_mobile/features/items/domain/usecases/get_items.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_event.dart';
import 'package:cms_mobile/features/items/presentation/bloc/item_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final GetItemsUseCase _getItemsUseCase;
  final GetAllWarehouseItemsUseCase _getAllWarehouseItemsUseCase;

  ItemBloc(this._getItemsUseCase,this._getAllWarehouseItemsUseCase) : super(const ItemInitial()) {
    on<GetItems>(onGetItems);
    on<GetAllWarehouseItems>(onGetAllWarehouseItems);

  }

  void onGetItems(GetItems event, Emitter<ItemState> emit) async {
    emit(const ItemsLoading());
    
    final dataState = await _getItemsUseCase(params: event.getItemsInputEntity);
    
    
    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(ItemsSuccess(warehouseItems: dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(ItemsFailed(error: dataState.error!));
    }
  }
  void onGetAllWarehouseItems(GetAllWarehouseItems event, Emitter<ItemState> emit) async{
    emit(const AllWarehouseItemsLoading());
    final dataState = await _getAllWarehouseItemsUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty){
      emit(AllWarehouseItemsSuccess(allWarehouseItems: dataState.data!));
    }
     if (dataState is DataFailed) {
      emit(AllWarehouseItemsFailed(error: dataState.error!));
    }


  }
}
