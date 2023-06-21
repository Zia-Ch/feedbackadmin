import 'package:feedbackadmin/helper/extentions/mediaquery_size_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helper/responsive.dart';

class AddDialogueLayout extends ConsumerWidget {
  const AddDialogueLayout(
      {super.key,
      required this.formName,
      required this.child,
      required this.onSubmit});

  final String formName;
  final Widget child;
  final void Function() onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      insetPadding: Responsive.isMobile(context)
          ? const EdgeInsets.symmetric(horizontal: 40, vertical: 24)
          : Responsive.isTablet(context)
              ? const EdgeInsets.symmetric(horizontal: 40, vertical: 60)
              : const EdgeInsets.symmetric(horizontal: 175, vertical: 100),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        color: Colors.blue[50],
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: Responsive.isMobile(context)
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: context.screenSize.width,
              alignment: Responsive.isMobile(context)
                  ? Alignment.center
                  : Alignment.centerLeft,
              child: Text(
                formName,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: child,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 150,
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextButton(
                onPressed: onSubmit,
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue),
                child: const Text(
                  "Save",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
