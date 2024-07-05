import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/task/frorm/task_form_state.dart';
import 'package:cms_mobile/features/progress/presentation/widgets/task_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class TaskFormCubit extends Cubit<TaskFormState> {
  TaskFormCubit({
    Priority? priority,
    String? title,
    String? description,
    DateTime? dueDate,
    String? assignedToId,
    CompletionStatus? status,
  }) : super(TaskFormState(
          priorityDropdown: PriorityDropdown.pure(priority ?? Priority.DEFAULT_VALUE),
          titleField: TitleField.pure(title ?? ""),
          completionStatusDropdown: CompletionStatusDropdown.pure(status ?? CompletionStatus.TODO),
          descriptionField: DescriptionField.pure(description ?? ""),
          datePickerField: DatePickerField.pure(dueDate),
          userDropdown: UserDropdown.pure(assignedToId ?? "")
          ),
        );

  void userChanged(UserEntity value) {

    final UserDropdown userDropdown = UserDropdown.dirty(value.id);

    emit(
      state.copyWith(
        userDropdown: userDropdown,
        isValid: Formz.validate([
          state.descriptionField,
          state.titleField,
          state.datePickerField,
          state.priorityDropdown,
          state.userDropdown
        ]),
      ),
    );
  }
    

  void priorityChanged(Priority value) {
    final PriorityDropdown priorityDropdown = PriorityDropdown.dirty(value);

    emit(
      state.copyWith(
        priorityDropdown: priorityDropdown,
        isValid: Formz.validate([
          state.descriptionField,
          state.titleField,
          state.datePickerField,
          state.priorityDropdown,
          state.userDropdown
        ]),
      ),
    );
  }

    void completionStatusChanged(CompletionStatus value) {
    final CompletionStatusDropdown completionStatusDropdown = CompletionStatusDropdown.dirty(value);

    emit(
      state.copyWith(
        completionStatusDropdown: completionStatusDropdown,
        isValid: Formz.validate([
          state.descriptionField,
          state.titleField,
          state.datePickerField,
          state.priorityDropdown,
          state.userDropdown,
          state.completionStatusDropdown
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
          state.priorityDropdown,
          state.userDropdown,
          state.completionStatusDropdown
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
          state.priorityDropdown,
          state.userDropdown,
          state.completionStatusDropdown
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
          state.priorityDropdown,
          state.userDropdown,
          state.completionStatusDropdown
        ]),
      ),
    );
  }

  void onSubmit() {
    print(state);
    emit(
      state.copyWith(
        formStatus: FormStatus.validating,
        priorityDropdown: PriorityDropdown.dirty(state.priorityDropdown.value),
        titleField: TitleField.dirty(state.titleField.value),
        descriptionField: DescriptionField.dirty(state.descriptionField.value),
        datePickerField: DatePickerField.dirty(state.datePickerField.value),
        userDropdown: UserDropdown.dirty(state.userDropdown.value),
        completionStatusDropdown: CompletionStatusDropdown.dirty(state.completionStatusDropdown.value),
        isValid: Formz.validate([
          state.descriptionField,
          state.titleField,
          state.datePickerField,
          state.priorityDropdown,
          state.userDropdown,
          state.completionStatusDropdown
        ]),
      ),
    );
  }
}
