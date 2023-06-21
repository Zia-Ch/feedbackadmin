import 'package:feedbackadmin/helper/call_custom_dialogues.dart';
import 'package:feedbackadmin/helper/extentions/mediaquery_size_extention.dart';
import 'package:feedbackadmin/models/subject_checklist_model.dart';
import 'package:feedbackadmin/view/widgets/dialog/check_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helper/responsive.dart';

class CLDropDown extends ConsumerStatefulWidget {
  const CLDropDown({
    required this.items,
    required this.hintText,
    required this.onSubmit,
    super.key,
  });

  final List<SubjectDropDownCheckList> items;
  final String hintText;
  final void Function(List<SubjectDropDownCheckList>) onSubmit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CLDropDownState();
}

class _CLDropDownState extends ConsumerState<CLDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: Responsive.isMobile(context)
            ? (context.screenSize.width > 360
                ? 340
                : context.screenSize.width * 0.80)
            : 340,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.hintText,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w400,
              ),
            ),
            IconButton(
              onPressed: () {
                showCustomDialogue(
                    context,
                    CheckBoxDialog(
                      onSubmit: widget.onSubmit,
                      items: widget.items,
                    ));
              },
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.blue,
              ),
            ),
          ],
        ));
  }
}
