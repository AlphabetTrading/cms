import 'package:cms_mobile/core/entities/pagination.dart';

class GetWarehouseItemsInputEntity {
  PaginationInput? paginationInput;
  FilterWarehouseItemInput? filterWarehouseItemInput;
  GetWarehouseItemsInputEntity(
      {this.filterWarehouseItemInput, this.paginationInput});
  Map<String, dynamic> toJson() {
    return {
      "paginationInput": paginationInput?.toJson() ?? {},
      "filterWarehouseProductInput": filterWarehouseItemInput!.toJson() ?? {}
    };
  }
}

class FilterWarehouseItemInput {
  String? warehouseId;
  FilterWarehouseItemInput({this.warehouseId});

  Map<String, dynamic> toJson() {
    return {"warehouseId": warehouseId};
  }
}
