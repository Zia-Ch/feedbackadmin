import 'package:feedbackadmin/helper/extentions/mediaquery_size_extention.dart';
import 'package:feedbackadmin/helper/responsive.dart';
import 'package:feedbackadmin/models/dl_form_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DLTextField extends ConsumerWidget {
  const DLTextField({super.key, required this.formData});
  final DLFormData formData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: Responsive.isMobile(context)
          ? (context.screenSize.width > 360
              ? 340
              : context.screenSize.width * 0.80)
          : 340,
      height: 60,
      child: TextFormField(
        initialValue: formData.inputTextValue,
        onChanged: (String? text) {
          formData.inputTextValue = text;
          formData.errorText = null;
        },
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          labelText: formData.labelText,
          labelStyle: TextStyle(
            color: formData.errorText == null || formData.errorText!.isEmpty
                ? Colors.blue[400]
                : Colors.red[400],
          ),
          hintStyle: TextStyle(
            color: formData.errorText == null || formData.errorText!.isEmpty
                ? Colors.grey
                : Colors.red[400],
          ),
          hintText: formData.errorText == null || formData.errorText!.isEmpty
              ? formData.hintText
              : formData.errorText,
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.blue[400]!),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.blue[400]!),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.blue[400]!),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
