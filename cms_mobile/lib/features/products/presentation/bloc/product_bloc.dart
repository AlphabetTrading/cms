import 'package:cms_mobile/core/resources/data_state.dart';
import 'package:cms_mobile/features/products/domain/usecases/get_all_warehouse_products.dart';
import 'package:cms_mobile/features/products/domain/usecases/get_products.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_event.dart';
import 'package:cms_mobile/features/products/presentation/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetAllWarehouseProductsUseCase _getAllWarehouseProductsUseCase;

  ProductBloc(this._getProductsUseCase, this._getAllWarehouseProductsUseCase)
      : super(const ProductInitial()) {
    on<GetWarehouseProducts>(onGetWarehouseProducts);
    on<GetAllWarehouseProducts>(onGetAllWarehouseProducts);
  }

  void onGetWarehouseProducts(
      GetWarehouseProducts event, Emitter<ProductState> emit) async {
    emit(const WarehouseProductsLoading());

    final dataState =
        await _getProductsUseCase(params: event.getProductsInputEntity);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(WarehouseProductsSuccess(warehouseProducts: dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(WarehouseProductsFailed(error: dataState.error!));
    }
  }

  void onGetAllWarehouseProducts(
      GetAllWarehouseProducts event, Emitter<ProductState> emit) async {
    emit(const AllWarehouseProductsLoading());
    debugPrint('GetAllWarehouseProducts');
    final dataState =
        await _getAllWarehouseProductsUseCase(params: event.projectId);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(AllWarehouseProductsSuccess(allWarehouseProducts: dataState.data!));
      debugPrint("fetched data: ${dataState.data!.length}");
    }
    if (dataState is DataFailed) {
      emit(AllWarehouseProductsFailed(error: dataState.error!));

    }
  }
}
