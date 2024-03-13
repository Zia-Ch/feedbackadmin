import 'package:data_table_2/data_table_2.dart';
import 'package:feedbackadmin/helper/call_custom_dialogues.dart';
import 'package:feedbackadmin/helper/enums/delete_actions.dart';
import 'package:feedbackadmin/helper/extentions/mediaquery_size_extention.dart';
import 'package:feedbackadmin/helper/extentions/widget_padding.dart';
import 'package:feedbackadmin/view/widgets/dialog/simple_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../controllers/subject_controller.dart';
import '../../../helper/enums/data_table_actions.dart';
import '../../../helper/shared_state/updator.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/dialog/add_subject_dialog.dart';

//TODO: add realtime upadte in list of subjects/teachers etc

class SubjectssScreen extends ConsumerStatefulWidget {
  const SubjectssScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SubjectssScreenState();
}

class _SubjectssScreenState extends ConsumerState<SubjectssScreen> {
  final ScrollController horizontalController = ScrollController();

  void delete(DeleteAction action, String id) async {
    bool isSuccess =
        await ref.read(subjectControllerProvider.notifier).delete(action, id);
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
    final value = ref.watch(allSubjectsProvider);

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
                "Subjects",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  showCustomDialogue(
                      context,
                      const AddSubjects(
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
                    "Add Subject",
                  )
                ]),
              )
            ],
          ).addPadding(12),
          Expanded(
            child: AsyncValueWidget(
              value: value,
              data: (data) {
                return DataTable2(
                  dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    return Colors.white;
                  }),
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  smRatio: 0.75,
                  lmRatio: 1.5,
                  dividerThickness: 0.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  columns: const [
                    DataColumn2(
                      label: Text('Subject code'),
                      size: ColumnSize.L,
                    ),
                    DataColumn(
                      label: Text('Subject name'),
                    ),
                    DataColumn(
                      label: Text('Course Name'),
                    ),
                    DataColumn(
                      label: Text('action'),
                    ),
                  ],
                  rows: data
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(Text(
                              e.subject.subjectCode,
                            )),
                            DataCell(Text(e.subject.subjectName)),
                            DataCell(Text(e.course.courseName)),
                            DataCell(
                              Row(
                                children: [
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
                                          AddSubjects(
                                            action: DataTableAction.edit,
                                            subject: e,
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
                                        showCustomDialogue(context,
                                            SimpleDeleteDialog(
                                          onDelete: () {
                                            delete(DeleteAction.permanantly,
                                                e.subject.id);
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
                            )
                          ],
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
