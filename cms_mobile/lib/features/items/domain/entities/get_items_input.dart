class GetWarehouseItemsInputEntity {
  PaginationInput? paginationInput;
  FilterWarehouseItemInput? filterWarehouseItemInput;
  GetWarehouseItemsInputEntity(
      {this.filterWarehouseItemInput, this.paginationInput});
  Map<String, dynamic> toJson() {
    return {
      "paginationInput": paginationInput?.toJson() ?? {},
      "filterWarehouseProductInput":
          filterWarehouseItemInput!.toJson() ?? {}
    };
  }
}

class PaginationInput {
  int? skip;
  int? take;
  PaginationInput({this.skip, this.take});
  Map<String, dynamic> toJson() {
    return {"skip": skip, "take": take};
  }
}

class FilterWarehouseItemInput {
  String? warehouseId;
  FilterWarehouseItemInput({this.warehouseId});

  Map<String, dynamic> toJson() {
    return {"warehouseId": warehouseId};
  }
}
