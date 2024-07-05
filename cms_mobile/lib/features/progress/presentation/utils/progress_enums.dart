import 'package:cms_mobile/features/progress/domain/entities/task.dart';

Priority priorityFromString(String? value) {
  return Priority.values.firstWhere(
    (e) => e.toString().split('.').last == value,
    orElse: () => Priority.DEFAULT_VALUE,
  );
}

Map<Priority, String> priorityDisplay = {
  Priority.CRITICAL: "Critical",
  Priority.HIGH: "High",
  Priority.MEDIUM: "Medium",
  Priority.LOW: "Low",
  Priority.DEFAULT_VALUE: "",
};

CompletionStatus completionStatusFromString(String? value) {
  return CompletionStatus.values.firstWhere(
    (e) => e.toString().split('.').last == value,
    orElse: () => CompletionStatus.DEFAULT_VALUE,
  );
}

Map<CompletionStatus, String> completionStatusDisplay = {
  CompletionStatus.COMPLETED: "Completed",
  CompletionStatus.ONGOING: "Ongoing",
  CompletionStatus.TODO: "Todo",
  CompletionStatus.DEFAULT_VALUE: "",
};
