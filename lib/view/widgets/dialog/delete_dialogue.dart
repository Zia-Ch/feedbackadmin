import 'package:feedbackadmin/helper/extentions/widget_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helper/responsive.dart';

class DeleteDialogue extends ConsumerWidget {
  const DeleteDialogue({
    required this.onLogicallyDelete,
    required this.onPermanantlyDelete,
    super.key,
  });
  final void Function()? onLogicallyDelete;
  final void Function()? onPermanantlyDelete;

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
      child: Stack(
        children: [
          Container(
            color: Colors.blue[50],
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Icon(
                    Icons.error_rounded,
                    color: Colors.red[200],
                    size: 60,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Do you want to delete this?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 150,
                        child: TextButton(
                          onPressed: onLogicallyDelete,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                          ),
                          child: const Text("Logically"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 150,
                        child: TextButton(
                          onPressed: onPermanantlyDelete,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                          ),
                          child: const Text("Permanantly"),
                        ),
                      ),
                    ],
                  ),
                ).addPadding(10),
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            top: 0.0,
            child: Material(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.blue[100],
                  child: Icon(
                    Icons.close,
                    color: Colors.red[300],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
