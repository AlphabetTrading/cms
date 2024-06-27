class RoutePaths {
  static const String signup = 'signup';
  static const String login = 'login';
  static const String forgotPassword = 'forgotPassword';
  static const String resetPassword = 'resetPassword';
  static const String home = '/';
  static const String items = 'items/:warehouseId';

  // material request
  static const String materialRequests = 'material_requests';
  static const String materialRequestCreate = 'material_requests/create';
  static const String materialRequestDetails = ':materialRequestId';
  static const String materialRequestEdit = 'edit/:materialRequestId';

  // material issue
  static const String materialIssue = 'material_issue';
  static const String materialIssueDetails = ':materialIssueId';
  static const String materialIssueCreate = 'create';
  static const String materialIssueEdit = 'edit/:materialIssueId';

  // materialTransfer
  static const String materialTransfer = 'material_transfer';
  static const String materialTransferDetails = ':materialTransferId';
  static const String materialTransferCreate = 'create';
  static const String materialTransferEdit = 'edit';

  // material receiving
  static const String materialReceivingCreate = 'create';
  static const String materialReceivingEdit = 'edit';
  static const String materialReceivingDetails = ':materialReceivingId';
  static const String materialReceiving = 'material_receiving';
 
  // purchase order
  static const String purchaseOrder = 'purchase_order';
  static const String purchaseOrderCreate = 'create';
  static const String purchaseOrderDetails = ':purchaseOrderId';
  static const String purchaseOrderEdit = 'edit/:purchaseOrderId';

  // material return
  static const String materialReturnCreate = 'create';
  static const String materialReturnDetails = ':materialReturnId';
  static const String materialReturnEdit = 'edit/:materialReturnId';
  static const String materialReturn = 'material_return';

  //milestone
  static const String milestoneDetails = 'milestones/:milestoneId';
  static const String taskDetails = 'task';

}

class RouteNames {
  static const String home = 'home';
  static const String details = 'details';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String forgotPassword = 'forgotPassword';
  static const String resetPassword = 'resetPassword';
  static const String items = 'items';

  // material request
  static const String materialRequests = 'material_requests';
  static const String materialRequestCreate = 'create_material_request';
  static const String materialRequestDetails = 'material_request_details';
  static const String materialRequestEdit = 'material_request_edit';

  // material issue
  static const String materialIssue = 'material_issue';
  static const String materialIssueCreate = 'material_issue_create';
  static const String materialIssueDetails = 'material_issue_details';
  static const String materialIssueEdit = 'material_issue_edit';

  // material transfer
  static const String materialTransfer = 'material_transfer';
  static const String materialTransferCreate = 'material_transfer_create';
  static const String materialTransferDetails = 'material_transfer_details';
  static const String materialTransferEdit = 'material_transfer_edit';

  // material receiving
  static const String materialReceiving = 'material_receiving';
  static const String materialReceivingCreate = 'material_receiving_create';
  static const String materialReceivingDetails = 'material_receiving_details';
  static const String materialReceivingEdit = 'material_receiving_edit';

  // purchase order
  static const String purchaseOrder = 'purchase_order';
  static const String purchaseOrderCreate = 'purchase_order_create';
  static const String purchaseOrderDetails = 'purchase_order_details';
  static const String purchaseOrderEdit = 'purchase_order_edit';


  // material return
  static const String materialReturnCreate = 'material_return_create';
  static const String materialReturnDetails = 'material_return_details';
  static const String materialReturnEdit = 'material_return_edit';
  static const String materialReturn = 'material_return';

  //progress
  static const String milestoneDetails = 'milestone_details';
  static const String taskDetails = 'task_details';

}
