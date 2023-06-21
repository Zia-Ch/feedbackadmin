import 'package:feedbackadmin/apis/batch_api.dart';
import 'package:feedbackadmin/apis/course_api.dart';
import 'package:feedbackadmin/apis/section_api.dart';
import 'package:feedbackadmin/apis/students_api.dart';
import 'package:feedbackadmin/apis/teachers_api.dart';
import 'package:feedbackadmin/helper/enums/delete_actions.dart';
import 'package:feedbackadmin/helper/extentions/email_to_roll_no_extention.dart';
import 'package:feedbackadmin/models/feedback/course_model.dart';
import 'package:feedbackadmin/models/feedback/relational_models/student_model.dart';
import 'package:feedbackadmin/models/feedback/relational_models/user_teacher_feedback_mxn_model.dart';
import 'package:feedbackadmin/models/feedback/section_model.dart';
import 'package:feedbackadmin/models/feedback/teacher_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../apis/feedback_api.dart';
import '../helper/enums/data_table_actions.dart';
import '../models/feedback/batch_model.dart';
import '../models/feedback/user_model.dart';

final getAllStudentsProvider = FutureProvider((ref) async {
  return await ref.watch(studentControllerProvider.notifier).getAllStudents();
});

final studentControllerProvider =
    StateNotifierProvider<StudentController, AsyncValue>((ref) {
  return StudentController(
    studentApi: ref.watch(studentApiProvider),
    courseApi: ref.watch(courseApiProvider),
    sectionApi: ref.watch(sectionApiProvider),
    batchApi: ref.watch(batchApiProvider),
    feedbackApi: ref.watch(feedBackApiProvider),
    teacherApi: ref.watch(teacherApiProvider),
  );
});

class StudentController extends StateNotifier<AsyncValue> {
  StudentController(
      {required studentApi,
      required sectionApi,
      required courseApi,
      required feedbackApi,
      required batchApi,
      required teacherApi})
      : _studentApi = studentApi,
        _sectionApi = sectionApi,
        _courseApi = courseApi,
        _batchApi = batchApi,
        _feedbackApi = feedbackApi,
        _teacherApi = teacherApi,
        super(
          const AsyncData(null),
        );

  final StudentApi _studentApi;
  final SectionApi _sectionApi;
  final CourseApi _courseApi;
  final BatchApi _batchApi;
  final FeedBackApi _feedbackApi;
  final TeacherApi _teacherApi;

  Future<List<StudentModel>> getAllStudents() async {
    final allStudents = await _studentApi.getAllStudents();
    final List<UserModel> rawDataList = [];
    final List<StudentModel> studentDataList = [];
    allStudents.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      r.map((e) {
        rawDataList.add(UserModel.fromMap(e.data));
      }).toList();
    });

    for (var user in rawDataList) {
      final Section section = await _getSectionById(user.sectionId);
      final Course course = await _getCourseById(user.courseId);
      final Batch batch = await _getBatchById(user.batchId);
      studentDataList.add(StudentModel(
        user: user,
        section: section,
        course: course,
        batch: batch,
      ));
    }

    return studentDataList;
  }

  Future<Section> _getSectionById(String id) async {
    Section section = Section(id: id, sectionName: "");
    final res = await _sectionApi.getSectionById(id);
    res.fold((l) {}, (r) {
      section = Section.fromMap(r);
    });

    return section;
  }

  Future<Course> _getCourseById(String id) async {
    Course course = Course(id: id, courseName: "", noOfSemesters: 1);
    final res = await _courseApi.getCourseById(id);
    res.fold((l) {}, (r) {
      course = Course.fromMap(r);
    });

    return course;
  }

  Future<Batch> _getBatchById(String id) async {
    Batch batch = Batch(id: id, batch: '');
    final res = await _batchApi.getBatchById(id);
    res.fold((l) {}, (r) {
      batch = Batch.fromMap(r);
    });

    return batch;
  }

  Future<bool> submitAddStudentForm(
    DataTableAction action,
    String name,
    String email,
    List<String> subjects,
    String courseId,
    String batchId,
    String sectionId,
  ) async {
    const AsyncValue.loading();
    final UserModel student = UserModel(
      id: email.emailToRollNo(),
      name: name,
      email: email,
      subjects: subjects,
      sectionId: sectionId,
      courseId: courseId,
      batchId: batchId,
      isDeleted: false,
      isAdmin: false,
    );

    if (action == DataTableAction.edit) {
      await _updateStudentData(student);
    } else if (action == DataTableAction.add) {
      await _addStudent(student);
    }
    await _formulateDataForassigningFeedbacks(student);

    return state.hasError == false;
  }

  Future<void> _addStudent(UserModel student) async {
    final res = await _studentApi.addStudent(student);

    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }

  Future<void> _updateStudentData(UserModel student) async {
    final res = await _studentApi.updateStudentData(student);
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
      await _deleteStudentLogically(id);
    } else if (action == DeleteAction.permanantly) {
      await _deleteStudentPermanantly(id);
    }
    return state.hasError == false;
  }

  Future<void> _deleteStudentLogically(String id) async {
    final res = await _studentApi.deleteStudentLogically(id);
    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }

  Future<void> _deleteStudentPermanantly(String id) async {
    final res = await _studentApi.deleteStudentPermanantly(id);
    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }

  Future<void> _formulateDataForassigningFeedbacks(UserModel student) async {
    final List<UserTeacherFeedbackMxN> previousData =
        await _getAllAssignedFeedbacks(student.id);
    await _deleteAssignedFeedbacks(previousData);

    final List<UserTeacherFeedbackMxN> data = [];
    final List<Teacher> teachers = [];
    for (var subject in student.subjects) {
      final res = await _teacherApi.getTeacherSubjectId(subject);
      res.fold((l) {
        state = AsyncError(l.message, l.stackTrace);
      }, (r) {
        r.map((e) {
          teachers.add(Teacher.fromMap(e.data));
        }).toList();

        if (teachers.isEmpty) return;

        data.add(UserTeacherFeedbackMxN(
          id: '', //"${student.id}  ${teachers.first.id}  $subject",
          userId: student.id,
          teacherId: teachers.first.id,
          subjectId: subject,
          isFeedbackDone: false,
        ));
      });
    }

    await _assignFeedbacks(data);
  }

  Future<List<UserTeacherFeedbackMxN>> _getAllAssignedFeedbacks(
      String id) async {
    final res = await _feedbackApi.getAllAssignedFeedbacks(id);
    final List<UserTeacherFeedbackMxN> result = [];

    for (var element in res) {
      result.add(UserTeacherFeedbackMxN.fromMap(element.data));
    }

    return result;
  }

  Future<void> _assignFeedbacks(List<UserTeacherFeedbackMxN> data) async {
    for (var item in data) {
      final res = await _feedbackApi.addFeedbackForStudents(item);

      res.fold((l) {
        state = AsyncError(l.message, l.stackTrace);
      }, (r) {
        state = AsyncData(r);
      });
    }
  }

  _deleteAssignedFeedbacks(List<UserTeacherFeedbackMxN> data) async {
    for (var item in data) {
      final res = await _feedbackApi.deleteAssignedFeedbacks(item.id);

      res.fold((l) {
        state = AsyncError(l.message, l.stackTrace);
      }, (r) {
        state = AsyncData(r);
      });
    }
  }
}
