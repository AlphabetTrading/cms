import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/core/widgets/status_message.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/progress/domain/entities/task.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/details/details_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/task/create/create_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/task/edit/edit_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/task/frorm/task_form_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/task/frorm/task_form_state.dart';
import 'package:cms_mobile/features/progress/presentation/utils/progress_enums.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/details/details_cubit.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';


class TaskForm extends StatefulWidget {
  final bool isEdit;
  final TaskEntity? task;
  final String? milestoneId;
  const TaskForm(
      {super.key, this.isEdit = false, this.task, required this.milestoneId});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: widget.task?.dueDate != null
          ? DateFormat('MMMM dd, yyyy').format(widget.task!.dueDate!)
          : "",
    );
  }

  Future<void> _selectDate(TaskFormCubit taskFormCubit) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate:
          taskFormCubit.state.datePickerField.value ?? widget.task?.dueDate,
    );
    if (picked != null) {
      taskFormCubit.dueDateChanged(picked);
      setState(() {
        _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedProjectId =
        context.read<ProjectBloc>().state.selectedProjectId ?? "";

    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskFormCubit>(
          create: (context) => TaskFormCubit(
            description: widget.task?.description,
            dueDate: widget.task?.dueDate,
            priority: widget.task?.priority,
            title: widget.task?.name,
            assignedToId: widget.task?.assignedTo?.id,
            status: widget.task?.status,
          ),
        ),
        BlocProvider(
          create: (context) => sl<CreateTaskCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<EditTaskCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ProjectDetailsCubit>()
            ..onGetProjectDetails(projectId: selectedProjectId),
        ),
      ],
      child: BlocConsumer<EditTaskCubit, EditTaskState>(
        listener: (context, state) {
          if (state is EditTaskSuccess) {
            Navigator.pop(context);
            showStatusMessage(Status.SUCCESS, "Task edited successfully");
            context
                .read<MilestoneDetailsCubit>()
                .onGetMilestoneDetails(milestoneId: widget.milestoneId ?? "");
          } else if (state is EditTaskFailed) {
            Navigator.pop(context);
            showStatusMessage(Status.FAILED, state.error);
          }
        },
        builder: (editContext, editState) {
          return BlocConsumer<CreateTaskCubit, CreateTaskState>(
              listener: (context, state) {
                if (state is CreateTaskSuccess) {
                  Navigator.pop(context);
                  showStatusMessage(
                      Status.SUCCESS, "Task created successfully");
                  context.read<MilestoneDetailsCubit>().onGetMilestoneDetails(
                      milestoneId: widget.milestoneId ?? "");
                } else if (state is CreateTaskFailed) {
                  Navigator.pop(context);
                  showStatusMessage(Status.FAILED, state.error);
                }
              },
              builder: (createContext, createState) =>
                  BlocBuilder<TaskFormCubit, TaskFormState>(
                    builder: (context, state) {
                      final taskFormCubit = context.watch<TaskFormCubit>();
                      final titleField = state.titleField;
                      final descriptionField = state.descriptionField;
                      final priorityDropdown = state.priorityDropdown;
                      final datePickerField = state.datePickerField;
                      final userDropdown = state.userDropdown;
                      final completionStatusDropdown =
                          state.completionStatusDropdown;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            initialValue: titleField.value,
                            label: "Task Title",
                            onChanged: taskFormCubit.titleChanged,
                            errorMessage: titleField.errorMessage,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdown(
                                  initialSelection: priorityDropdown.value,
                                  onSelected: (dynamic value) =>
                                      taskFormCubit.priorityChanged(value),
                                  dropdownMenuEntries: Priority.values
                                      .map((e) => DropdownMenuEntry<Priority>(
                                          label: priorityDisplay[e] ?? "",
                                          value: e))
                                      .toList()
                                      .sublist(0, Priority.values.length - 1),
                                  enableFilter: false,
                                  errorMessage: priorityDropdown.errorMessage,
                                  label: 'Task Priority',
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: CustomDropdown(
                                  initialSelection:
                                      completionStatusDropdown.value,
                                  onSelected: (dynamic value) => taskFormCubit
                                      .completionStatusChanged(value),
                                  dropdownMenuEntries: CompletionStatus.values
                                      .map((e) =>
                                          DropdownMenuEntry<CompletionStatus>(
                                              label:
                                                  completionStatusDisplay[e] ??
                                                      "",
                                              value: e))
                                      .toList()
                                      .sublist(0,
                                          CompletionStatus.values.length - 1),
                                  enableFilter: false,
                                  errorMessage:
                                      completionStatusDropdown.errorMessage,
                                  label: 'Task Status',
                                ),
                              ),
                            ],
                          ),
                          CustomTextFormField(
                            controller: _dateController,
                            // initialValue: datePickerField.value != null
                            //     ? datePickerField.value.toString()
                            //     : "",
                            label: "Due Date",
                            // onChanged: taskFormCubit.dueDateChanged,
                            errorMessage: datePickerField.errorMessage,
                            readOnly: true,
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                            onTap: () {
                              _selectDate(taskFormCubit);
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
                            builder: (context, state) {
                              final users = (state is ProjectDetailsSuccess)
                                  ? state.project.projectUsers!
                                  : [];
                              UserEntity? selectedUser  = users.firstWhereOrNull(
                                        (element) =>
                                            element.id == userDropdown.value);

                              return CustomDropdown(
                                initialSelection: selectedUser,
                                onSelected: (dynamic value) =>
                                    taskFormCubit.userChanged(value),
                                dropdownMenuEntries: users
                                    .map((e) => DropdownMenuEntry<UserEntity>(
                                        label: e.fullName, value: e))
                                    .toList(),
                                enableFilter: false,
                                errorMessage: userDropdown.errorMessage,
                                label: 'Assign to',
                                trailingIcon: state is ProjectDetailsLoading
                                    ? const CircularProgressIndicator()
                                    : null,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            initialValue: descriptionField.value,
                            label: "Description",
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            onChanged: taskFormCubit.descriptionChanged,
                            errorMessage: descriptionField.errorMessage,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: (createState is CreateTaskLoading ||
                                    editState is EditTaskLoading)
                                ? null
                                : () {
                                    taskFormCubit.onSubmit();
                                    if (taskFormCubit.state.isValid) {
                                      if (widget.isEdit) {
                                        context
                                            .read<EditTaskCubit>()
                                            .onEditTask(
                                                params: EditTaskParamsEntity(
                                                    id: widget.task?.id ?? "",
                                                    assignedToId:
                                                        userDropdown.value,
                                                    description:
                                                        descriptionField.value,
                                                    dueDate:
                                                        datePickerField.value!,
                                                    name: titleField.value,
                                                    priority:
                                                        priorityDropdown.value,
                                                    milestoneId:
                                                        widget.milestoneId ??
                                                            "",
                                                    status:
                                                        completionStatusDropdown
                                                            .value));
                                      } else {
                                        context
                                            .read<CreateTaskCubit>()
                                            .onCreateTask(
                                                params: CreateTaskParamsEntity(
                                                    assignedToId: userDropdown
                                                        .value,
                                                    description:
                                                        descriptionField.value,
                                                    dueDate:
                                                        datePickerField.value!,
                                                    name: titleField.value,
                                                    priority:
                                                        priorityDropdown.value,
                                                    milestoneId:
                                                        widget.milestoneId ??
                                                            "",
                                                    status:
                                                        completionStatusDropdown
                                                            .value));
                                      }
                                      // Navigator.pop(context);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (createState is CreateTaskLoading ||
                                        editState is EditTaskLoading)
                                    ? const Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                            )),
                                      )
                                    : const SizedBox(),
                                widget.isEdit
                                    ? const Text('Save Changes')
                                    : const Text('Create Task'),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ));
        },
      ),
    );
  }
}

enum PriorityDropdownError { invalid }

class PriorityDropdown extends FormzInput<Priority, PriorityDropdownError> {
  const PriorityDropdown.pure([Priority value = Priority.DEFAULT_VALUE])
      : super.pure(value);
  const PriorityDropdown.dirty([Priority value = Priority.DEFAULT_VALUE])
      : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PriorityDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  PriorityDropdownError? validator(Priority? value) {
    if (value == Priority.DEFAULT_VALUE) {
      return PriorityDropdownError.invalid;
    }
    return null;
  }
}

enum CompletionStatusDropdownError { invalid }

class CompletionStatusDropdown
    extends FormzInput<CompletionStatus, CompletionStatusDropdownError> {
  const CompletionStatusDropdown.pure(
      [CompletionStatus value = CompletionStatus.TODO])
      : super.pure(value);
  const CompletionStatusDropdown.dirty(
      [CompletionStatus value = CompletionStatus.TODO])
      : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == CompletionStatusDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  CompletionStatusDropdownError? validator(CompletionStatus? value) {
    if (value == CompletionStatus.DEFAULT_VALUE) {
      return CompletionStatusDropdownError.invalid;
    }
    return null;
  }
}

enum UserDropdownError { invalid }

class UserDropdown extends FormzInput<String, UserDropdownError> {
  const UserDropdown.pure([String value = ""]) : super.pure(value);
  const UserDropdown.dirty([String value = ""]) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == UserDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  UserDropdownError? validator(String? value) {
    if (value?.isEmpty ?? true) {
      return UserDropdownError.invalid;
    }
    return null;
  }
}

enum TitleValidationError { empty }

class TitleField extends FormzInput<String, TitleValidationError> {
  const TitleField.pure([String value = '']) : super.pure(value);
  const TitleField.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == TitleValidationError.empty) {
      return 'Task Title cannot be empty';
    }

    return null;
  }

  @override
  TitleValidationError? validator(String value) {
    if (value.isEmpty) {
      return TitleValidationError.empty;
    }
    return null;
  }
}

enum DatePickerError { empty }

class DatePickerField extends FormzInput<DateTime?, DatePickerError> {
  const DatePickerField.pure([DateTime? value = null]) : super.pure(value);
  const DatePickerField.dirty([DateTime? value]) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DatePickerError.empty) {
      return 'Due date cannot be empty';
    }

    return null;
  }

  @override
  DatePickerError? validator(DateTime? value) {
    if (value == null) {
      return DatePickerError.empty;
    }
    return null;
  }
}

enum DescriptionValidationError { invalid }

class DescriptionField extends FormzInput<String, DescriptionValidationError> {
  const DescriptionField.pure([String value = '']) : super.pure(value);
  const DescriptionField.dirty([String value = '']) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DescriptionValidationError.invalid) {
      return 'Characters cannot exceed 100';
    }

    return null;
  }

  @override
  DescriptionValidationError? validator(String value) {
    if (value.length > 100) {
      return DescriptionValidationError.invalid;
    }
    return null;
  }
}
