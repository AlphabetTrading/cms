class MaterialTransactionsHelperFunctions {
  // create an object with pathname, route name, and title
  static Map<String, dynamic> getMaterialInfoByType(
      String materialRequestType) {
    switch (materialRequestType) {
      case 'MATERIAL_REQUEST':
        return {
          'path': 'material_requests/:type',
          'routeName': 'material_requests',
          'title': 'Material Requests',
        };
      case 'MATERIAL_ISSUE':
        return {
          'path': 'material_receivings/',
          'routeName': 'material_receivings',
          'title': 'Material Issues',
        };
      case 'MATERIAL_RETURN':
        return {
          'path': 'material_returns',
          'routeName': 'material_returns',
          'title': 'Material Returns',
        };
      case 'MATERIAL_ORDER':
        return {
          'path': 'material_returns',
          'routeName': 'material_returns',
          'title': 'Material Returns',
        };
      default:
        return {
          'path': 'material_requests/:type',
          'routeName': 'material_requests',
          'title': 'Material Requests',
        };
    }
  }
}
