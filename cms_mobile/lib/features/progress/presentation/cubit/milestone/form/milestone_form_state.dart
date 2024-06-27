import 'package:cms_mobile/features/progress/presentation/widgets/milestone_form.dart';
import 'package:equatable/equatable.dart';

enum FormStatus { invalid, valid, validating }

class MilestoneFormState extends Equatable {
  final bool isValid;
  final FormStatus formStatus;
  final StageDropdown stageDropdown;
  final DescriptionField descriptionField;
  final TitleField titleField;
  final DatePickerField datePickerField;

  const MilestoneFormState(
      {this.isValid = false,
      this.formStatus = FormStatus.invalid,
      this.stageDropdown = const StageDropdown.pure(),
      this.descriptionField = const DescriptionField.pure(),
      this.titleField = const TitleField.pure(),
      this.datePickerField = const DatePickerField.pure()});

  MilestoneFormState copyWith({
    bool? isValid,
    FormStatus? formStatus,
    StageDropdown? stageDropdown,
    DescriptionField? descriptionField,
    TitleField? titleField,
    DatePickerField? datePickerField,
  }) {
    return MilestoneFormState(
        isValid: isValid ?? this.isValid,
        formStatus: formStatus ?? this.formStatus,
        stageDropdown: stageDropdown ?? this.stageDropdown,
        descriptionField: descriptionField ?? this.descriptionField,
        titleField: titleField ?? this.titleField,
        datePickerField: datePickerField ?? this.datePickerField);
  }

  @override
  String toString() {
    return 'MilestoneFormState{isValid: $isValid, formStatus: $formStatus, stageDropdown: $stageDropdown, descriptionField: $descriptionField, titleField: $titleField, datePickerField: $datePickerField}';
  }

  @override
  List<Object?> get props => [
        isValid,
        formStatus,
        stageDropdown,
        descriptionField,
        titleField,
        datePickerField
      ];
}
