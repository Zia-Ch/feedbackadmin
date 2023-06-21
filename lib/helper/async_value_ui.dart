import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

extension AsyncValueUi on AsyncValue {
  void showAlertOnError(BuildContext context) {
    if (!isLoading && hasError) {
      final String message = error.toString();
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: message,
        ),
      );
    }
  }
}
