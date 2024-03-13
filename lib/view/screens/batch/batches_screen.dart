import 'package:feedbackadmin/helper/call_custom_dialogues.dart';
import 'package:feedbackadmin/helper/enums/data_table_actions.dart';
import 'package:feedbackadmin/helper/enums/delete_actions.dart';
import 'package:feedbackadmin/helper/extentions/mediaquery_size_extention.dart';
import 'package:feedbackadmin/helper/extentions/widget_padding.dart';
import 'package:feedbackadmin/view/widgets/dialog/add_batch_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../controllers/batch_controller.dart';
import '../../../helper/shared_state/updator.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/dialog/simple_delete_dialog.dart';

//TODO: add realtime upadte in list of batchControllerProviders/teachers etc

class BatchesScreen extends ConsumerStatefulWidget {
  const BatchesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BatchesScreenState();
}

class _BatchesScreenState extends ConsumerState<BatchesScreen> {
  final ScrollController horizontalController = ScrollController();

  void delete(DeleteAction action, String id) async {
    bool isSuccess =
        await ref.read(batchControllerProvider.notifier).delete(action, id);
    if (isSuccess) {
      ref.read(futureStateUpdator.notifier).update();
      showTopSnackBar(Overlay.of(context),
          const CustomSnackBar.success(message: "deleted successfully"));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(getAllBatchProvider);

    return Container(
      height: context.screenHeight,
      width: context.screenWidth,
      padding: const EdgeInsets.all(8),
      color: Colors.blue[50]!.withOpacity(0.4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Batch",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  showCustomDialogue(
                      context,
                      const AddBatchs(
                        action: DataTableAction.add,
                      ));
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
                child: const Row(children: [
                  Icon(Icons.add),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Add Batch",
                  )
                ]),
              )
            ],
          ).addPadding(12),
          Expanded(
            child: AsyncValueWidget(
              value: value,
              data: (data) {
                return ListView.separated(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 20),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              data[index].batch,
                              style: GoogleFonts.roboto(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                          ),
                          /*Material(
                            child: InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.visibility_outlined,
                                color: Colors.blue[200],
                              ),
                            ),
                          ),*/
                          const SizedBox(
                            width: 5,
                          ),
                          Material(
                            child: InkWell(
                              onTap: () {
                                showCustomDialogue(
                                  context,
                                  AddBatchs(
                                    action: DataTableAction.edit,
                                    batch: data[index],
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.edit_outlined,
                                color: Colors.blue[200],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Material(
                            child: InkWell(
                              onTap: () {
                                showCustomDialogue(context, SimpleDeleteDialog(
                                  onDelete: () {
                                    delete(DeleteAction.permanantly,
                                        data[index].id);
                                    Navigator.pop(context);
                                  },
                                ));
                              },
                              child: Icon(
                                Icons.delete_outlined,
                                color: Colors.red[200],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
