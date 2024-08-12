import 'package:cms_mobile/core/utils/ids.dart';
import 'package:cms_mobile/core/widgets/custom-dropdown.dart';
import 'package:cms_mobile/core/widgets/custom_text_form_field.dart';
import 'package:cms_mobile/core/widgets/status_message.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:cms_mobile/features/progress/domain/entities/milestone.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/create/create_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/edit/edit_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/form/milestone_form_cubit.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/form/milestone_form_state.dart';
import 'package:cms_mobile/features/progress/presentation/cubit/milestone/list/list_cubit.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class MilestoneForm extends StatefulWidget {
  final bool isEdit;
  final MilestoneEntity? milestone;
  const MilestoneForm({super.key, this.isEdit = false, this.milestone});

  @override
  State<MilestoneForm> createState() => _MilestoneFormState();
}

class _MilestoneFormState extends State<MilestoneForm> {
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: widget.milestone?.dueDate != null
          ? DateFormat('MMMM dd, yyyy').format(widget.milestone!.dueDate!)
          : "",
    );
  }

  Future<void> _selectDate(MilestoneFormCubit milestoneFormCubit) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: milestoneFormCubit.state.datePickerField.value ??
          widget.milestone?.dueDate,
    );
    if (picked != null) {
      milestoneFormCubit.dueDateChanged(picked);
      setState(() {
        _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MilestoneFormCubit>(
          create: (context) => MilestoneFormCubit(
            description: widget.milestone?.description,
            dueDate: widget.milestone?.dueDate,
            stage: widget.milestone?.stage,
            title: widget.milestone?.name,
          ),
        ),
        BlocProvider(
          create: (context) => sl<CreateMilestoneCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<EditMilestoneCubit>(),
        ),
      ],
      child: BlocConsumer<EditMilestoneCubit, EditMilestoneState>(
        listener: (context, state) {
          if (state is EditMilestoneSuccess) {
            Navigator.pop(context);
            showStatusMessage(Status.SUCCESS, "Milestone edited successfully");
            context.read<MilestonesCubit>().onGetMilestones(
                getMilestonesParamsEntity: GetMilestonesParamsEntity(
                    filterMilestoneInput: null,
                    orderBy: null,
                    paginationInput: null));
          } else if (state is EditMilestoneFailed) {
            Navigator.pop(context);
            showStatusMessage(Status.FAILED, state.error);
          }
        },
        builder: (editContext, editState) {
          return BlocConsumer<CreateMilestoneCubit, CreateMilestoneState>(
              listener: (context, state) {
                if (state is CreateMilestoneSuccess) {
                  Navigator.pop(context);
                  showStatusMessage(
                      Status.SUCCESS, "Milestone created successfully");
                  context.read<MilestonesCubit>().onGetMilestones(
                      getMilestonesParamsEntity: GetMilestonesParamsEntity(
                          filterMilestoneInput: null,
                          orderBy: null,
                          paginationInput: null));
                } else if (state is CreateMilestoneFailed) {
                  Navigator.pop(context);
                  showStatusMessage(Status.FAILED, state.error);
                }
              },
              builder: (createContext, createState) =>
                  BlocBuilder<MilestoneFormCubit, MilestoneFormState>(
                    builder: (context, state) {
                      final milestoneFormCubit =
                          context.watch<MilestoneFormCubit>();
                      final titleField = state.titleField;
                      final descriptionField = state.descriptionField;
                      final stageDropdown = state.stageDropdown;
                      final datePickerField = state.datePickerField;
               
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CustomDropdown(
                            initialSelection: stageDropdown.value,
                            onSelected: (dynamic value) =>
                                milestoneFormCubit.stageChanged(value),
                            dropdownMenuEntries: UseType.values
                                .map((e) => DropdownMenuEntry<UseType>(
                                    label: useTypeDisplay[e] ?? "", value: e))
                                .toList()
                                .sublist(0, UseType.values.length - 1),
                            enableFilter: false,
                            errorMessage: stageDropdown.errorMessage,
                            label: 'Project Stage',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            initialValue: titleField.value,
                            label: "Milestone Title",
                            onChanged: milestoneFormCubit.titleChanged,
                            errorMessage: titleField.errorMessage,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: _dateController,
                            // initialValue: datePickerField.value != null
                            //     ? datePickerField.value.toString()
                            //     : "",
                            label: "Due Date",
                            // onChanged: milestoneFormCubit.dueDateChanged,
                            errorMessage: datePickerField.errorMessage,
                            readOnly: true,
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                            onTap: () {
                              _selectDate(milestoneFormCubit);
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
                            onChanged: milestoneFormCubit.descriptionChanged,
                            errorMessage: descriptionField.errorMessage,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: (createState is CreateMilestoneLoading ||
                                    editState is EditMilestoneLoading)
                                ? null
                                : () {
                                    milestoneFormCubit.onSubmit();
                                    if (milestoneFormCubit.state.isValid) {
                                      if (widget.isEdit) {
                                        context
                                            .read<EditMilestoneCubit>()
                                            .onEditMilestone(
                                                params: EditMilestoneParamsEntity(
                                                    id: widget.milestone?.id ??
                                                        "",
                                                    createdById: widget
                                                            .milestone
                                                            ?.createdBy
                                                            ?.id ??
                                                        "",
                                                    description:
                                                        descriptionField.value,
                                                    dueDate:
                                                        datePickerField.value!,
                                                    name: titleField.value,
                                                    stage:
                                                        stageDropdown.value));
                                      } else {
                                        context
                                            .read<CreateMilestoneCubit>()
                                            .onCreateMilestone(
                                                params: CreateMilestoneParamsEntity(
                                                    createdById: context.read<AuthBloc>().state.user?.id ??
                                    USER_ID,
                                                    description:
                                                        descriptionField.value,
                                                    dueDate:
                                                        datePickerField.value!,
                                                    name: titleField.value,
                                                    projectId: context
                                                            .read<ProjectBloc>()
                                                            .state
                                                            .selectedProjectId ??
                                                        "",
                                                    stage:
                                                        stageDropdown.value));
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
                                (createState is CreateMilestoneLoading ||
                                        editState is EditMilestoneLoading)
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
                                    : const Text('Create Milestone'),
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

enum StageDropdownError { invalid }

class StageDropdown extends FormzInput<UseType, StageDropdownError> {
  const StageDropdown.pure([UseType value = UseType.DEFAULT_VALUE])
      : super.pure(value);
  const StageDropdown.dirty([UseType value = UseType.DEFAULT_VALUE])
      : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == StageDropdownError.invalid) {
      return 'This field is required';
    }
    return null;
  }

  @override
  StageDropdownError? validator(UseType? value) {
    if (value == UseType.DEFAULT_VALUE) {
      return StageDropdownError.invalid;
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
      return 'Milestone Title cannot be empty';
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
