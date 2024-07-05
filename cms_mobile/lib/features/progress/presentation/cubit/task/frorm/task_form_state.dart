import 'package:cms_mobile/features/progress/presentation/widgets/task_form.dart';
import 'package:equatable/equatable.dart';

enum FormStatus { invalid, valid, validating }

class TaskFormState extends Equatable {
  final bool isValid;
  final FormStatus formStatus;
  final PriorityDropdown priorityDropdown;
  final DescriptionField descriptionField;
  final TitleField titleField;
  final DatePickerField datePickerField;
  final UserDropdown userDropdown;
  final CompletionStatusDropdown completionStatusDropdown;


  const TaskFormState(
      {this.isValid = false,
      this.formStatus = FormStatus.invalid,
      this.priorityDropdown = const PriorityDropdown.pure(),
      this.descriptionField = const DescriptionField.pure(),
      this.titleField = const TitleField.pure(),
      this.datePickerField = const DatePickerField.pure(),
      this.userDropdown = const UserDropdown.pure(),
      this.completionStatusDropdown = const CompletionStatusDropdown.pure()

      });

  TaskFormState copyWith({
    bool? isValid,
    FormStatus? formStatus,
    PriorityDropdown? priorityDropdown,
    DescriptionField? descriptionField,
    TitleField? titleField,
    DatePickerField? datePickerField,
    UserDropdown? userDropdown,
    CompletionStatusDropdown? completionStatusDropdown
  }) {
    return TaskFormState(
        isValid: isValid ?? this.isValid,
        formStatus: formStatus ?? this.formStatus,
        priorityDropdown: priorityDropdown ?? this.priorityDropdown,
        descriptionField: descriptionField ?? this.descriptionField,
        titleField: titleField ?? this.titleField,
        datePickerField: datePickerField ?? this.datePickerField,
        userDropdown: userDropdown ?? this.userDropdown,
        completionStatusDropdown: completionStatusDropdown ?? this.completionStatusDropdown
        );
  }

  @override
  String toString() {
    return 'TaskFormState{isValid: $isValid, formStatus: $formStatus, priorityDropdown: $priorityDropdown, descriptionField: $descriptionField, titleField: $titleField, datePickerField: $datePickerField}';
  }

  @override
  List<Object?> get props => [
        isValid,
        formStatus,
        priorityDropdown,
        descriptionField,
        titleField,
        datePickerField,
        userDropdown,
        completionStatusDropdown
      ];
}
