import 'package:feedbackadmin/helper/async_value_ui.dart';
import 'package:feedbackadmin/models/dl_drop_down_items.dart';
import 'package:feedbackadmin/models/feedback/relational_models/subject_course_model.dart';
import 'package:feedbackadmin/view/widgets/async_value_widget.dart';
import 'package:feedbackadmin/view/widgets/dialog/dialog_layout.dart';
import 'package:feedbackadmin/view/widgets/dialog/dl_drop_down.dart';
import 'package:feedbackadmin/view/widgets/dialog/dl_responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../controllers/course_controller.dart';

import '../../../controllers/subject_controller.dart';
import '../../../helper/enums/data_table_actions.dart';
import '../../../helper/shared_state/updator.dart';
import '../../../models/dl_form_data.dart';
import 'dl_text_field.dart';

class AddSubjects extends ConsumerStatefulWidget {
  const AddSubjects({
    required this.action,
    this.subject,
    super.key,
  });

  final DataTableAction action;
  final SubjectCourseModel? subject;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddSubjectsState();
}

class _AddSubjectsState extends ConsumerState<AddSubjects> {
  late final DLFormData code;
  late final DLFormData name;
  late final DLFormData course;

  @override
  void initState() {
    super.initState();
    code = DLFormData(
      labelText: 'Subject Code',
      hintText: 'Subject Code',
      inputTextValue: widget.subject?.subject.subjectCode,
    );
    name = DLFormData(
      labelText: 'Subject Name',
      hintText: 'Subject Name',
      inputTextValue: widget.subject?.subject.subjectName,
    );
    course = DLFormData(
        hintText: 'Seelct Course',
        dropDownValue: widget.action == DataTableAction.edit
            ? DLDropDownItems(
                id: widget.subject?.course.id ?? '',
                name: widget.subject?.course.courseName ?? '',
              )
            : null);
  }

  onFormSubmit() async {
    bool hasError = false;

    if (code.inputTextValue == null || code.inputTextValue!.isEmpty) {
      code.errorText = 'Subject code is required';
      hasError = true;
    }
    if (name.inputTextValue == null || name.inputTextValue!.isEmpty) {
      name.errorText = 'Subject Name is required';
      hasError = true;
    }
    if (course.dropDownValue?.id == null || course.dropDownValue!.id.isEmpty) {
      course.errorText = 'Course is required';
      hasError = true;
    }

    setState(() {});
    if (!hasError) {
      bool isSuccess = await ref
          .read(subjectControllerProvider.notifier)
          .submitAddSubjectForm(
            widget.action,
            widget.subject?.subject.id,
            code.inputTextValue!,
            name.inputTextValue!,
            course.dropDownValue!.id,
          );

      if (isSuccess) {
        showTopSnackBar(
            Overlay.of(context),
            widget.action == DataTableAction.add
                ? const CustomSnackBar.success(message: "Added successfully")
                : const CustomSnackBar.success(
                    message: "Updated successfully"));
        Navigator.pop(context);
        ref.read(futureStateUpdator.notifier).update();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = ref.watch(allCourseProvider);

    ref.listen<AsyncValue>(
      subjectControllerProvider,
      (_, state) => state.showAlertOnError(context),
    );

    return AddDialogueLayout(
        formName: 'Add Subjects',
        onSubmit: onFormSubmit,
        child: DLResponsiveLayout(
          children: [
            DLTextField(
              formData: code,
            ),
            DLTextField(
              formData: name,
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
          ],
        ));
  }
}
