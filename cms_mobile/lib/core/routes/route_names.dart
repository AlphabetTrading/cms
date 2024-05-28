class RoutePaths {
  static const String signup = 'signup';
  static const String login = 'login';
  static const String forgotPassword = 'forgotPassword';
  static const String resetPassword = 'resetPassword';
  static const String home = '/';
  static const String materialReturn = 'material_return';
  static const String materialReceiving = 'material_receiving';
  static const String purchaseOrder = 'purchase_order';
  static const String items = 'items/:warehouseId';

  // material request
  static const String materialRequest = 'material_request';
  static const String materialRequests = 'material-requests';
  static const String createMaterialRequest =
      'material_request/create_material_request';
  static const String materialRequestDetails =
      'material_request/material_request_details';

  // material issue
  static const String materialIssue = 'material_issue';
  static const String materialIssueDetails = 'material_issue/:materialIssueId';
  static const String materialIssueCreate = 'material_issue/create';
  static const String materialIssueEdit =
      'material_issue/edit/:materialIssueId';
}

class RouteNames {
  static const String home = 'home';
  static const String materialRequests = 'material-requests';
  static const String details = 'details';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String forgotPassword = 'forgotPassword';
  static const String resetPassword = 'resetPassword';
  static const String materialRequest = 'material_request';
  static const String materialReturn = 'material_return';
  static const String materialReceiving = 'material_receiving';
  static const String purchaseOrder = 'purchase_order';
  static const String createMaterialRequest = 'create_material_request';
  static const String materialRequestDetails = 'material_request_details';
  static const String items = 'items';

  // material issue
  static const String materialIssue = 'material_issue';
  static const String materialIssueCreate = 'material_issue_create';
  static const String materialIssueDetails = 'material_issue_details';
  static const String materialIssueEdit = 'material_issue_edit';
}
