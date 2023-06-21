import 'package:feedbackadmin/helper/extentions/mediaquery_size_extention.dart';
import 'package:feedbackadmin/models/dl_drop_down_items.dart';
import 'package:feedbackadmin/models/dl_form_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helper/responsive.dart';

class DLDropDown extends ConsumerStatefulWidget {
  const DLDropDown({
    required this.items,
    required this.formData,
    super.key,
  });

  final List<DLDropDownItems> items;

  final DLFormData formData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DLDropDownState();
}

class _DLDropDownState extends ConsumerState<DLDropDown> {
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
      child: DropdownButton(
          onChanged: (value) {
            setState(() {
              widget.formData.dropDownValue = value;
            });
          },
          isExpanded: true,
          iconEnabledColor: Colors.blue[400],
          underline: const SizedBox(),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          value: widget.formData.dropDownValue,
          hint: Text(
            widget.formData.hintText!,
            style: TextStyle(
              color: widget.formData.errorText == null ||
                      widget.formData.errorText!.isEmpty
                  ? Colors.blue[400]
                  : Colors.red[400],
            ),
          ),
          items: widget.items
              .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
              .toList()),
    );
  }
}
