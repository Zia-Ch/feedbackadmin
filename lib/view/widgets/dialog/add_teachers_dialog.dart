import 'package:feedbackadmin/controllers/subject_controller.dart';
import 'package:feedbackadmin/helper/async_value_ui.dart';
import 'package:feedbackadmin/helper/extentions/bool_to_yes.dart';
import 'package:feedbackadmin/models/dl_drop_down_items.dart';
import 'package:feedbackadmin/models/feedback/subject_model.dart';
import 'package:feedbackadmin/models/feedback/teacher_model.dart';
import 'package:feedbackadmin/models/subject_checklist_model.dart';
import 'package:feedbackadmin/view/widgets/async_value_widget.dart';
import 'package:feedbackadmin/view/widgets/dialog/dialog_layout.dart';
import 'package:feedbackadmin/view/widgets/dialog/dl_responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/teacher_controller.dart';
import '../../../helper/auth/email_password_sign_in_validators.dart';
import '../../../helper/enums/data_table_actions.dart';

import '../../../models/dl_form_data.dart';
import '../../../models/feedback/relational_models/subject_course_model.dart';
import 'check_list_drop_down.dart';
import 'dl_drop_down.dart';
import 'dl_text_field.dart';

class AddTeachers extends ConsumerStatefulWidget {
  const AddTeachers({
    required this.action,
    this.teacher,
    super.key,
  });

  final DataTableAction action;
  final Teacher? teacher;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTeachersState();
}

class _AddTeachersState extends ConsumerState<AddTeachers> {
  late final DLFormData name;
  late final DLFormData email;

  late final DLFormData teaching;
  late final DLFormData permanent;
  late final DLFormData rating;
  final emailPasswordValidator = EmailAndPasswordValidators();
  final List<SubjectModel> selectedSubjects = [];

  @override
  void initState() {
    super.initState();
    name = DLFormData(
      labelText: 'Name',
      hintText: 'Name',
      inputTextValue: widget.teacher?.name,
    );
    email = DLFormData(
      labelText: 'Email',
      hintText: 'Email',
      inputTextValue: widget.teacher?.email,
    );

    permanent = DLFormData(
      hintText: 'permanent Faculty?',
      dropDownValue: widget.action == DataTableAction.edit
          ? DLDropDownItems(
              id: widget.teacher?.isPermanant.boolToYesNO() ?? '',
              name: widget.teacher?.isPermanant.boolToYesNO() ?? '',
            )
          : null,
    );

    teaching = DLFormData(
        hintText: 'Teaching Currently?',
        dropDownValue: widget.action == DataTableAction.edit
            ? DLDropDownItems(
                id: widget.teacher?.isTeaching.boolToYesNO() ?? '',
                name: widget.teacher?.isTeaching.boolToYesNO() ?? '',
              )
            : null);

    rating = DLFormData(
      doubleInputValue: widget.teacher?.rating,
    );
  }

  onFormSubmit() async {
    bool hasError = false;

    if (name.inputTextValue == null || name.inputTextValue!.isEmpty) {
      name.errorText = 'Name is required';
      hasError = true;
      setState(() {});
    }
    if (email.inputTextValue == null || email.inputTextValue!.isEmpty) {
      email.errorText = 'IBIT valid Email is required';
      hasError = true;
      setState(() {});
    } else {
      String? emailErrorText =
          emailPasswordValidator.emailErrorText(email.inputTextValue!);
      if (emailErrorText != null) {
        email.errorText = emailErrorText;
        email.inputTextValue = null;
        hasError = true;
        setState(() {});
      }
    }
    if (teaching.dropDownValue?.name == null ||
        teaching.dropDownValue!.name.isEmpty) {
      teaching.errorText = 'Teaching currently? is required';
      hasError = true;
      setState(() {});
    }
    if (permanent.dropDownValue?.id == null ||
        permanent.dropDownValue!.id.isEmpty) {
      permanent.errorText = 'Permanent Faculty? is required';
      hasError = true;
      setState(() {});
    }

    if (!hasError) {
      bool isSuccess = await ref
          .read(teacherControllerProvider.notifier)
          .submitAddTeacherForm(
            widget.action,
            name.inputTextValue!,
            email.inputTextValue!,
            selectedSubjects.map((e) => e.id).toList(),
            rating.doubleInputValue,
            teaching.dropDownValue!.id.yesNoTobool(),
            permanent.dropDownValue!.id.yesNoTobool(),
          );
      //

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

    if (widget.teacher != null) {
      if (widget.teacher!.subjects.isNotEmpty) {
        for (var item in allSubject) {
          bool isPresent = false;
          isPresent = widget.teacher!.subjects.contains(item.subject.id);

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
    final allSubjects = ref.watch(allSubjectsProvider);

    ref.listen<AsyncValue>(
      teacherControllerProvider,
      (_, state) => state.showAlertOnError(context),
    );

    return AddDialogueLayout(
        formName: 'Add Teachers',
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
            DLDropDown(
              formData: permanent,
              items: [true, false]
                  .map(
                    (e) => DLDropDownItems(
                      id: e.boolToYesNO(),
                      name: e.boolToYesNO(),
                    ),
                  )
                  .toList(),
            ),
            DLDropDown(
              formData: teaching,
              items: [true, false]
                  .map(
                    (e) => DLDropDownItems(
                      id: e.boolToYesNO(),
                      name: e.boolToYesNO(),
                    ),
                  )
                  .toList(),
            ),
          ],
        ));
  }
}
