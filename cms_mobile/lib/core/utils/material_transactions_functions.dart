import 'package:cms_mobile/core/routes/route_names.dart';

class MaterialTransactionsHelperFunctions {
  static Map<String, dynamic> getMaterialInfoByType(
      String materialRequestType) {
    switch (materialRequestType) {
      case 'MATERIAL_REQUEST':
        return {
          'path': RoutePaths.materialRequests,
          'routeName': RouteNames.materialRequests,
          'title': 'Material Requests',
        };
      case 'MATERIAL_ISSUE':
        return {
          'path': RoutePaths.materialIssue,
          'routeName': RouteNames.materialIssue,
          'title': 'Material Issues',
        };
      case 'MATERIAL_RETURN':
        return {
          'path': RoutePaths.materialReturn,
          'routeName': RouteNames.materialReturn,
          'title': 'Material Returns',
        };
      case 'MATERIAL_RECEIVING':
        return {
          'path': RoutePaths.materialReceiving,
          'routeName': RouteNames.materialReceiving,
          'title': 'Material Receiving',
        };
      case 'PURCHASE_ORDER':
        return {
          'path': RoutePaths.purchaseOrder,
          'routeName': RouteNames.purchaseOrder,
          'title': 'Purchase Orders',
        };
      case 'MATERIAL_TRANSFER':
        return {
          'path': RoutePaths.materialTransfer,
          'routeName': RouteNames.materialTransfer,
          'title': 'Material Transfers',
        };
      default:
        return {
          'path': RoutePaths.materialRequests,
          'routeName': RouteNames.materialRequests,
          'title': 'Material Requests',
        };
    }
  }
}
