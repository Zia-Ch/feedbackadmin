import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/subject_checklist_model.dart';

class CheckBoxDialog extends ConsumerStatefulWidget {
  const CheckBoxDialog(
      {required this.items, required this.onSubmit, super.key});
  final List<SubjectDropDownCheckList> items;
  final void Function(List<SubjectDropDownCheckList>) onSubmit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CheckBoxDialogState();
}

class _CheckBoxDialogState extends ConsumerState<CheckBoxDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 300,
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              "Select Subjects",
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 300,
            width: 200,
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return CheckboxListTile(
                  title: Text(item.subjectModel.subjectName),
                  value: item.isSelected,
                  onChanged: (value) {
                    setState(() {
                      widget.items[index].isSelected = value!;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 300,
            height: 50,
            child: TextButton(
              onPressed: () {
                widget.onSubmit(widget.items);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("Done"),
            ),
          )
        ],
      ),
    );
  }
}
