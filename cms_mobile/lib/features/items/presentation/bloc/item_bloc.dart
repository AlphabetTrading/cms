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
    on<GetWarehouseItems>(onGetWarehouseItems);
    on<GetAllWarehouseItems>(onGetAllWarehouseItems);


  }

  void onGetWarehouseItems(GetWarehouseItems event, Emitter<ItemState> emit) async {
    emit(const WarehouseItemsLoading());
    print("******** Get Warehouse Items Called Bloc Loading");
    
    final dataState = await _getItemsUseCase(params: event.getItemsInputEntity);
    
    
    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
    print("******** Get Warehouse Items Called Bloc Success");

      emit(WarehouseItemsSuccess(warehouseItems: dataState.data!));
    }
    if (dataState is DataFailed) {
    print("******** Get Warehouse Items Called Bloc Failed");

      emit(WarehouseItemsFailed(error: dataState.error!));
    }
  }
  void onGetAllWarehouseItems(GetAllWarehouseItems event, Emitter<ItemState> emit) async{
    emit(const AllWarehouseItemsLoading());
    final dataState = await _getAllWarehouseItemsUseCase(params: event.projectId);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty){
      emit(AllWarehouseItemsSuccess(allWarehouseItems: dataState.data!));
    }
     if (dataState is DataFailed) {
      emit(AllWarehouseItemsFailed(error: dataState.error!));
    }


  }
}
