import 'package:data_table_2/data_table_2.dart';
import 'package:feedbackadmin/helper/call_custom_dialogues.dart';
import 'package:feedbackadmin/helper/enums/data_table_actions.dart';
import 'package:feedbackadmin/helper/enums/delete_actions.dart';
import 'package:feedbackadmin/helper/extentions/mediaquery_size_extention.dart';
import 'package:feedbackadmin/helper/extentions/widget_padding.dart';
import 'package:feedbackadmin/view/widgets/dialog/delete_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../controllers/students_controller.dart';
import '../../../helper/shared_state/updator.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/dialog/add_students_dialog.dart';

//TODO: add realtime upadte in list of students/teachers etc

class StudentsScreen extends ConsumerStatefulWidget {
  const StudentsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends ConsumerState<StudentsScreen> {
  final ScrollController horizontalController = ScrollController();

  void delete(DeleteAction action, String id) async {
    bool isSuccess =
        await ref.read(studentControllerProvider.notifier).delete(action, id);
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
    final value = ref.watch(getAllStudentsProvider);

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
                "Students",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  showCustomDialogue(
                      context,
                      const AddStudents(
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
                    "Add Student",
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
                      label: Text('Name'),
                      size: ColumnSize.L,
                    ),
                    DataColumn(
                      label: Text('Email'),
                    ),
                    DataColumn(
                      label: Text('course'),
                    ),
                    DataColumn(
                      label: Text('Batch'),
                    ),
                    DataColumn(
                      label: Text('section'),
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
                              e.user.name, //== '' ? e.user.name : e.user.id,
                            )),
                            DataCell(Text(e.user.email)),
                            DataCell(Text(e.course.courseName)),
                            DataCell(Text(e.batch.batch)),
                            DataCell(Text(e.section.sectionName)),
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
                                          AddStudents(
                                            action: DataTableAction.edit,
                                            student: e,
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
                                        showCustomDialogue(
                                            context,
                                            DeleteDialogue(
                                              onLogicallyDelete: () {
                                                delete(DeleteAction.logically,
                                                    e.user.id);
                                                Navigator.pop(context);
                                              },
                                              onPermanantlyDelete: () {
                                                delete(DeleteAction.permanantly,
                                                    e.user.id);
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
