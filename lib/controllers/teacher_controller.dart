import 'package:feedbackadmin/apis/teachers_api.dart';
import 'package:feedbackadmin/helper/enums/delete_actions.dart';
import 'package:feedbackadmin/helper/extentions/email_to_roll_no_extention.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helper/enums/data_table_actions.dart';
import '../models/feedback/teacher_model.dart';

// teacher api is ok controller is ok but not tested
// TODO: adjust teacher add and update

final getAllTeachersProvider = FutureProvider((ref) async {
  return await ref.watch(teacherControllerProvider.notifier).getAllTeachers();
});

final teacherControllerProvider =
    StateNotifierProvider<TeacherController, AsyncValue>((ref) {
  return TeacherController(
    teacherApi: ref.watch(teacherApiProvider),
  );
});

class TeacherController extends StateNotifier<AsyncValue> {
  TeacherController({
    required teacherApi,
  })  : _teacherApi = teacherApi,
        super(
          const AsyncData(null),
        );

  final TeacherApi _teacherApi;

  Future<List<Teacher>> getAllTeachers() async {
    final allTeachers = await _teacherApi.getAllTeachers();

    final List<Teacher> teacherDataList = [];
    allTeachers.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      r.map((e) {
        teacherDataList.add(Teacher.fromMap(e.data));
      }).toList();
    });

    return teacherDataList;
  }

  Future<bool> submitAddTeacherForm(
    DataTableAction action,
    String name,
    String email,
    List<String> subjects,
    double? rating,
    bool isTeaching,
    bool isPermanant,
  ) async {
    const AsyncValue.loading();

    final Teacher teacher = Teacher(
      id: email.emailToRollNo(),
      name: name,
      email: email,
      subjects: subjects,
      isTeaching: isTeaching,
      isPermanant: isPermanant,
      rating: rating ?? 0.0,
      isDeleted: false,
    );

    if (action == DataTableAction.edit) {
      _updateTeacherData(teacher);
    } else if (action == DataTableAction.add) {
      await _addTeacher(teacher);
    }

    return state.hasError == false;
  }

  Future<void> _addTeacher(Teacher teacher) async {
    final res = await _teacherApi.addTeacher(teacher);

    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }

  Future<void> _updateTeacherData(Teacher teacher) async {
    final res = await _teacherApi.updateTeacherData(teacher);
    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }

  Future<bool> delete(
    DeleteAction action,
    String id,
  ) async {
    if (action == DeleteAction.logically) {
      await _deleteTeacherLogically(id);
    } else if (action == DeleteAction.permanantly) {
      await _deleteTeacherPermanantly(id);
    }
    return state.hasError == false;
  }

  Future<void> _deleteTeacherLogically(String id) async {
    final res = await _teacherApi.deleteTeacherLogically(id);
    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }

  Future<void> _deleteTeacherPermanantly(String id) async {
    final res = await _teacherApi.deleteTeacherPermanantly(id);
    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }
}
