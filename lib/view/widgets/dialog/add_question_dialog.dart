import 'package:feedbackadmin/helper/async_value_ui.dart';
import 'package:feedbackadmin/helper/extentions/question_enum_to_text.dart';
import 'package:feedbackadmin/models/dl_drop_down_items.dart';
import 'package:feedbackadmin/models/feedback/question_model.dart';
import 'package:feedbackadmin/view/widgets/dialog/dialog_layout.dart';
import 'package:feedbackadmin/view/widgets/dialog/dl_drop_down.dart';
import 'package:feedbackadmin/view/widgets/dialog/dl_responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/question_controller.dart';

import '../../../helper/enums/data_table_actions.dart';
import '../../../models/dl_form_data.dart';
import 'dl_text_field.dart';

class AddQuestions extends ConsumerStatefulWidget {
  const AddQuestions({
    required this.action,
    this.question,
    super.key,
  });

  final DataTableAction action;
  final QuestionModel? question;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddQuestionsState();
}

class _AddQuestionsState extends ConsumerState<AddQuestions> {
  late final DLFormData question;

  late final DLFormData type;
  late final DLFormData status;

  @override
  void initState() {
    super.initState();
    question = DLFormData(
      labelText: 'Question',
      hintText: 'Question',
      inputTextValue: widget.question?.question,
    );

    status = DLFormData(
        hintText: 'Seelct Status',
        dropDownValue: widget.action == DataTableAction.edit
            ? DLDropDownItems(
                id: widget.question?.status ?? '',
                name: widget.question?.status ?? '',
              )
            : null);
    type = DLFormData(
        hintText: 'Seelct Question Type',
        dropDownValue: widget.action == DataTableAction.edit
            ? DLDropDownItems(
                id: widget.question?.type.name ?? '',
                name: widget.question?.type.name ?? '',
              )
            : null);
  }

  onFormSubmit() async {
    bool hasError = false;

    if (question.inputTextValue == null || question.inputTextValue!.isEmpty) {
      question.errorText = 'Question is required';
      hasError = true;
    }

    if (status.dropDownValue?.id == null || status.dropDownValue!.id.isEmpty) {
      status.errorText = 'Question status is required';
      hasError = true;
    }
    if (type.dropDownValue?.id == null || type.dropDownValue!.id.isEmpty) {
      type.errorText = 'Question type is required';
      hasError = true;
    }

    setState(() {});
    if (!hasError) {
      bool isSuccess = await ref
          .read(questionControllerProvider.notifier)
          .submitAddQuestionForm(
            widget.action,
            widget.question?.id,
            question.inputTextValue!,
            type.dropDownValue!.id.toQuestionTypeEnum(),
            status.dropDownValue!.id,
          );

      if (isSuccess) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      questionControllerProvider,
      (_, state) => state.showAlertOnError(context),
    );

    return AddDialogueLayout(
        formName: 'Add Questions',
        onSubmit: onFormSubmit,
        child: DLResponsiveLayout(
          children: [
            DLTextField(
              formData: question,
            ),
            DLDropDown(
              formData: status,
              items: ['available', 'unavailable']
                  .map(
                    (e) => DLDropDownItems(
                      id: e,
                      name: e,
                    ),
                  )
                  .toList(),
            ),
            DLDropDown(
              formData: type,
              items: ['rating', 'comment']
                  .map(
                    (e) => DLDropDownItems(
                      id: e,
                      name: e,
                    ),
                  )
                  .toList(),
            ),
          ],
        ));
  }
}
