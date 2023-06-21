import 'package:data_table_2/data_table_2.dart';
import 'package:feedbackadmin/helper/extentions/mediaquery_size_extention.dart';
import 'package:feedbackadmin/helper/extentions/widget_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../controllers/teacher_controller.dart';
import '../../../helper/call_custom_dialogues.dart';
import '../../../helper/enums/data_table_actions.dart';
import '../../../helper/enums/delete_actions.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/dialog/add_teachers_dialog.dart';
import '../../widgets/dialog/delete_dialogue.dart';

class TeachersScreen extends ConsumerStatefulWidget {
  const TeachersScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends ConsumerState<TeachersScreen> {
  final ScrollController horizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    horizontalController.dispose();
    super.dispose();
  }

  void delete(DeleteAction action, String id) async {
    bool isSuccess =
        await ref.read(teacherControllerProvider.notifier).delete(action, id);
    if (isSuccess) {
      showTopSnackBar(Overlay.of(context),
          const CustomSnackBar.success(message: "deleted successfully"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(getAllTeachersProvider);

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
                "Teachers",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  showCustomDialogue(
                      context,
                      const AddTeachers(
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
                    "Add Teacher",
                  )
                ]),
              )
            ],
          ).addPadding(12),
          Expanded(
            child: AsyncValueWidget(
              value: value,
              data: (data) {
                print(data.length);
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
                      label: Text('Ratings'),
                    ),
                    DataColumn(
                      label: Text('Permanent faculty'),
                    ),
                    DataColumn(
                      label: Text('Teaching curently'),
                    ),
                    DataColumn(
                      label: Text('Actions'),
                    ),
                  ],
                  rows: data
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(Text(
                              e.name,
                            )),
                            DataCell(Text(e.email)),
                            DataCell(Text(e.rating.toString())),
                            DataCell(Text(e.isPermanant ? "Yes" : "No")),
                            DataCell(Text(e.isTeaching ? "Yes" : "No")),
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
                                          AddTeachers(
                                            action: DataTableAction.edit,
                                            teacher: e,
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
                                              delete(
                                                  DeleteAction.logically, e.id);
                                              Navigator.pop(context);
                                            },
                                            onPermanantlyDelete: () {
                                              delete(DeleteAction.permanantly,
                                                  e.id);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
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
