import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/form/milestone_form_state.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/milestone_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class MilestoneFormCubit extends Cubit<MilestoneFormState> {
  MilestoneFormCubit({
    UseType? stage,
    String? title,
    String? description,
    DateTime? dueDate,
  }) : super(MilestoneFormState(
          stageDropdown: StageDropdown.pure(stage ?? UseType.DEFAULT_VALUE),
          titleField: TitleField.pure(description ?? ""),
          descriptionField: DescriptionField.pure(description ?? ""),
          datePickerField: DatePickerField.pure(dueDate ?? DateTime.now()),
        ));

  void stageChanged(UseType value) {
    final StageDropdown stageDropdown = StageDropdown.dirty(value);

    emit(
      state.copyWith(
        stageDropdown: stageDropdown,
        isValid: Formz.validate([
          state.descriptionField,
          state.titleField,
          state.datePickerField,
          state.stageDropdown
        ]),
      ),
    );
  }

  void titleChanged(String value) {
    final TitleField titleField = TitleField.dirty(value);

    emit(
      state.copyWith(
        titleField: titleField,
        isValid: Formz.validate([
          state.descriptionField,
          state.titleField,
          state.datePickerField,
          state.stageDropdown
        ]),
      ),
    );
  }

  void dueDateChanged(DateTime? value) {
    final DatePickerField datePickerField = DatePickerField.dirty(value);

    emit(
      state.copyWith(
        datePickerField: datePickerField,
        isValid: Formz.validate([
          state.descriptionField,
          state.titleField,
          state.datePickerField,
          state.stageDropdown
        ]),
      ),
    );
  }

  void descriptionChanged(String value) {
    final DescriptionField descriptionField = DescriptionField.dirty(value);

    emit(
      state.copyWith(
        descriptionField: descriptionField,
        isValid: Formz.validate([
          state.descriptionField,
          state.titleField,
          state.datePickerField,
          state.stageDropdown
        ]),
      ),
    );
  }

  void onSubmit() {
    print(state);
    emit(
      state.copyWith(
        formStatus: FormStatus.validating,
        stageDropdown: StageDropdown.dirty(state.stageDropdown.value),
        titleField: TitleField.dirty(state.titleField.value),
        descriptionField: DescriptionField.dirty(state.descriptionField.value),
        datePickerField: DatePickerField.dirty(state.datePickerField.value),
        isValid: Formz.validate([
          state.descriptionField,
          state.titleField,
          state.datePickerField,
          state.stageDropdown
        ]),
      ),
    );
  }
}
