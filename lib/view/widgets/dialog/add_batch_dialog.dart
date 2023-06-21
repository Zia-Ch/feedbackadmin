import 'package:feedbackadmin/helper/async_value_ui.dart';
import 'package:feedbackadmin/models/feedback/batch_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/batch_controller.dart';

import '../../../helper/enums/data_table_actions.dart';
import '../../../helper/responsive.dart';
import '../../../models/dl_form_data.dart';
import 'dl_text_field.dart';

class AddBatchs extends ConsumerStatefulWidget {
  const AddBatchs({
    required this.action,
    this.batch,
    super.key,
  });

  final DataTableAction action;
  final Batch? batch;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddBatchsState();
}

class _AddBatchsState extends ConsumerState<AddBatchs> {
  late final DLFormData batch;

  @override
  void initState() {
    super.initState();
    batch = DLFormData(
      labelText: 'Batch',
      hintText: 'Batch',
      inputTextValue: widget.batch?.batch,
    );
  }

  onFormSubmit() async {
    bool hasError = false;

    if (batch.inputTextValue == null || batch.inputTextValue!.isEmpty) {
      batch.errorText = 'Batch name is required';
      hasError = true;
    }

    setState(() {});
    if (!hasError) {
      bool isSuccess =
          await ref.read(batchControllerProvider.notifier).submitAddBatchForm(
                widget.action,
                widget.batch?.id,
                batch.inputTextValue!,
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
      batchControllerProvider,
      (_, state) => state.showAlertOnError(context),
    );

    return Dialog(
      insetPadding: Responsive.isMobile(context)
          ? const EdgeInsets.symmetric(horizontal: 40, vertical: 24)
          : Responsive.isTablet(context)
              ? const EdgeInsets.symmetric(horizontal: 150, vertical: 80)
              : const EdgeInsets.symmetric(horizontal: 500, vertical: 200),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        color: Colors.blue[50],
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              alignment: Responsive.isMobile(context)
                  ? Alignment.center
                  : Alignment.centerLeft,
              child: Text(
                widget.action == DataTableAction.add
                    ? "Add Batch"
                    : "Edit Batch",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: DLTextField(
                formData: batch,
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
                onPressed: onFormSubmit,
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
