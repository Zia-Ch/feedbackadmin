import 'package:flutter/material.dart';

showCustomDialogue(BuildContext context, Widget child) {
  showDialog(
      context: context,
      builder: (context) {
        return child;
      });
}
