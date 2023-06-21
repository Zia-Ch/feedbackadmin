import 'package:feedbackadmin/helper/async_value_ui.dart';
import 'package:feedbackadmin/models/dl_drop_down_items.dart';
import 'package:feedbackadmin/models/feedback/relational_models/student_model.dart';
import 'package:feedbackadmin/view/widgets/async_value_widget.dart';
import 'package:feedbackadmin/view/widgets/dialog/dialog_layout.dart';
import 'package:feedbackadmin/view/widgets/dialog/dl_drop_down.dart';
import 'package:feedbackadmin/view/widgets/dialog/dl_responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/batch_controller.dart';
import '../../../controllers/course_controller.dart';
import '../../../controllers/section_controller.dart';

import '../../../controllers/students_controller.dart';
import '../../../controllers/subject_controller.dart';
import '../../../helper/auth/email_password_sign_in_validators.dart';
import '../../../helper/enums/data_table_actions.dart';
import '../../../models/dl_form_data.dart';
import '../../../models/feedback/relational_models/subject_course_model.dart';
import '../../../models/feedback/subject_model.dart';
import '../../../models/subject_checklist_model.dart';
import 'check_list_drop_down.dart';
import 'dl_text_field.dart';

class AddStudents extends ConsumerStatefulWidget {
  const AddStudents({
    required this.action,
    this.student,
    super.key,
  });

  final DataTableAction action;
  final StudentModel? student;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddStudentsState();
}

class _AddStudentsState extends ConsumerState<AddStudents> {
  late final DLFormData name;
  late final DLFormData email;
  late final DLFormData course;
  late final DLFormData batch;
  late final DLFormData section;
  final emailPasswordValidator = EmailAndPasswordValidators();
  final List<SubjectModel> selectedSubjects = [];

  @override
  void initState() {
    super.initState();
    name = DLFormData(
      labelText: 'Name',
      hintText: 'Name',
      inputTextValue: widget.student?.user.name,
    );
    email = DLFormData(
      labelText: 'Email',
      hintText: 'Email',
      inputTextValue: widget.student?.user.email,
    );
    course = DLFormData(
        hintText: 'Seelct Course',
        dropDownValue: widget.action == DataTableAction.edit
            ? DLDropDownItems(
                id: widget.student?.course.id ?? '',
                name: widget.student?.course.courseName ?? '',
              )
            : null);
    batch = DLFormData(
        hintText: 'Seelct Batch',
        dropDownValue: widget.action == DataTableAction.edit
            ? DLDropDownItems(
                id: widget.student?.batch.id ?? '',
                name: widget.student?.batch.batch ?? '',
              )
            : null);
    section = DLFormData(
        hintText: 'Seelct Section',
        dropDownValue: widget.action == DataTableAction.edit
            ? DLDropDownItems(
                id: widget.student?.section.id ?? '',
                name: widget.student?.section.sectionName ?? '',
              )
            : null);
  }

  onFormSubmit() async {
    bool hasError = false;

    if (name.inputTextValue == null || name.inputTextValue!.isEmpty) {
      name.errorText = 'Name is required';
      hasError = true;
    }
    if (email.inputTextValue == null || email.inputTextValue!.isEmpty) {
      email.errorText = 'IBIT valid Email is required';
      hasError = true;
    } else {
      String? emailErrorText =
          emailPasswordValidator.emailErrorText(email.inputTextValue!);
      if (emailErrorText != null) {
        email.errorText = emailErrorText;
        email.inputTextValue = null;
        hasError = true;
      }
    }
    if (course.dropDownValue?.id == null || course.dropDownValue!.id.isEmpty) {
      course.errorText = 'Course is required';
      hasError = true;
    }
    if (batch.dropDownValue?.id == null || batch.dropDownValue!.id.isEmpty) {
      batch.errorText = 'Batch is required';
      hasError = true;
    }
    if (section.dropDownValue?.id == null ||
        section.dropDownValue!.id.isEmpty) {
      section.errorText = 'Section is required';
      hasError = true;
    }

    setState(() {});
    if (!hasError) {
      bool isSuccess = await ref
          .read(studentControllerProvider.notifier)
          .submitAddStudentForm(
            widget.action,
            name.inputTextValue!,
            email.inputTextValue!,
            selectedSubjects.map((e) => e.id).toList(),
            course.dropDownValue!.id,
            batch.dropDownValue!.id,
            section.dropDownValue!.id,
          );

      if (isSuccess) {
        Navigator.pop(context);
      }
    }
  }

  setSubjects(List<SubjectDropDownCheckList> itemList) {
    selectedSubjects.clear();
    for (var item in itemList) {
      if (item.isSelected) {
        selectedSubjects.add(item.subjectModel);
      }
    }
  }

  List<SubjectDropDownCheckList> getItemList(
      List<SubjectCourseModel> allSubject) {
    List<SubjectDropDownCheckList> itemList = [];

    if (widget.student != null) {
      if (widget.student!.user.subjects.isNotEmpty) {
        for (var item in allSubject) {
          bool isPresent = false;
          isPresent = widget.student!.user.subjects.contains(item.subject.id);

          itemList.add(
            SubjectDropDownCheckList(
              id: (UniqueKey).toString(),
              subjectModel: item.subject,
              isSelected: isPresent,
            ),
          );

          if (isPresent) {
            selectedSubjects.add(item.subject);
          }
        }
      }
    } else {
      for (var item in allSubject) {
        itemList.add(
          SubjectDropDownCheckList(
              id: (UniqueKey).toString(),
              subjectModel: item.subject,
              isSelected: false),
        );
      }
    }

    return itemList;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = ref.watch(allCourseProvider);
    final batch = ref.watch(getAllBatchProvider);
    final section = ref.watch(allSectionProvider);
    final allSubjects = ref.watch(allSubjectsProvider);

    ref.listen<AsyncValue>(
      studentControllerProvider,
      (_, state) => state.showAlertOnError(context),
    );

    return AddDialogueLayout(
        formName: 'Add Students',
        onSubmit: onFormSubmit,
        child: DLResponsiveLayout(
          children: [
            DLTextField(
              formData: name,
            ),
            DLTextField(
              formData: email,
            ),
            AsyncValueWidget(
              value: course,
              data: (courses) {
                return DLDropDown(
                  formData: this.course,
                  items: courses
                      .map(
                        (e) => DLDropDownItems(
                          id: e.id,
                          name: e.courseName,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            AsyncValueWidget(
              value: batch,
              data: (batches) {
                return DLDropDown(
                  formData: this.batch,
                  items: batches
                      .map(
                        (e) => DLDropDownItems(
                          id: e.id,
                          name: e.batch,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            AsyncValueWidget(
              value: section,
              data: (sections) {
                return DLDropDown(
                  formData: this.section,
                  items: sections
                      .map(
                        (e) => DLDropDownItems(
                          id: e.id,
                          name: e.sectionName,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            AsyncValueWidget(
              value: allSubjects,
              data: (allSubjects) {
                return CLDropDown(
                  hintText: "Select Subjects",
                  items: getItemList(allSubjects),
                  onSubmit: (items) {
                    setSubjects(items);
                  },
                );
              },
            ),
          ],
        ));
  }
}
