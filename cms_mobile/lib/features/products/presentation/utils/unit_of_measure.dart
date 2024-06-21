

import 'package:cms_mobile/features/products/data/models/product.dart';

Map<UnitOfMeasure, String> unitOfMeasureMap = {
  UnitOfMeasure.berga: "Berga",
  UnitOfMeasure.kg: "Kilogram",
  UnitOfMeasure.liter: "Liter",
  UnitOfMeasure.m2: "Square Meter",
  UnitOfMeasure.m3: "Cubic Meter",
  UnitOfMeasure.pcs: "Pieces",
  UnitOfMeasure.packet: "Packet",
  UnitOfMeasure.quintal: "Quintal",
};

String unitOfMeasureDisplay(UnitOfMeasure? unitOfMeasure) {
  try {
    if(unitOfMeasure == null) return "N/A";
    return unitOfMeasureMap[unitOfMeasure]!;
  } catch (e) {
    return "N/A";
  }
}

// // Function to convert string to UnitOfMeasure enum
// UnitOfMeasure unitOfMeasureFromString(String? value) {
//   return UnitOfMeasure.values.firstWhere(
//     (e) => e.toString().split('.').last == value,
//     orElse: () => UnitOfMeasure.DEFAULT_VALUE,
//   );
// }
