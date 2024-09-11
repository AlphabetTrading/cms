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
          'path': RoutePaths.purchaseOrders,
          'routeName': RouteNames.purchaseOrders,
          'title': 'Purchase Orders',
        };
      case 'MATERIAL_TRANSFER':
        return {
          'path': RoutePaths.materialTransfer,
          'routeName': RouteNames.materialTransfer,
          'title': 'Material Transfers',
        };
      case 'PROFORMA':
        return {
          'path': RoutePaths.materialProforma,
          'routeName': RouteNames.materialProforma,
          'title': 'Material Proforma',
        };
      case 'DAILY_SITE_DATA':
        return {
          'path': RoutePaths.dailySiteData,
          'routeName': RouteNames.dailySiteData,
          'title': 'Daily Site Data',
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
