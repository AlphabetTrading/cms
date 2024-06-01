import 'package:cms_mobile/core/entities/pagination.dart';

class GetWarehouseProductsInputEntity {
  PaginationInput? paginationInput;
  FilterWarehouseProductInput? filterWarehouseProductInput;
  GetWarehouseProductsInputEntity(
      {this.filterWarehouseProductInput, this.paginationInput});
  Map<String, dynamic> toJson() {
    return {
      "paginationInput": paginationInput?.toJson() ?? {},
      "filterWarehouseProductInput": filterWarehouseProductInput!.toJson() ?? {}
    };
  }
}

class FilterWarehouseProductInput {
  String? warehouseId;
  FilterWarehouseProductInput({this.warehouseId});

  Map<String, dynamic> toJson() {
    return {"warehouseId": warehouseId};
  }
}
