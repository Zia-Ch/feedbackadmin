import 'package:feedbackadmin/apis/course_api.dart';
import 'package:feedbackadmin/models/feedback/course_model.dart';
import 'package:feedbackadmin/models/feedback/relational_models/subject_course_model.dart';
import 'package:feedbackadmin/models/feedback/subject_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../apis/subjects_api.dart';
import '../helper/enums/data_table_actions.dart';
import '../helper/enums/delete_actions.dart';
import '../helper/shared_state/updator.dart';

final allSubjectsByIdsProvider = FutureProvider.family((ref, List<String> ids) {
  final subjectController = ref.watch(subjectControllerProvider.notifier);

  return subjectController.getSubjectsByIds(ids);
});

final allSubjectsProvider = FutureProvider((ref) {
  final subjectController = ref.watch(subjectControllerProvider.notifier);
  ref.watch(futureStateUpdator);

  return subjectController.getAllSubjects();
});

final subjectControllerProvider =
    StateNotifierProvider<SubjectController, AsyncValue>((ref) {
  return SubjectController(
      subjectApi: ref.watch(subjectApiProvider),
      courseApi: ref.watch(courseApiProvider));
});

class SubjectController extends StateNotifier<AsyncValue> {
  final SubjectApi _subjectApi;
  final CourseApi _courseApi;

  SubjectController(
      {required SubjectApi subjectApi, required CourseApi courseApi})
      : _subjectApi = subjectApi,
        _courseApi = courseApi,
        super(
          const AsyncData(null),
        );

  Future<List<SubjectCourseModel>> getAllSubjects() async {
    final res = await _subjectApi.getAllSubjects();
    final List<SubjectModel> subjcetList = [];
    final List<SubjectCourseModel> result = [];

    res.fold((l) {
      throw l.message;
    }, (r) {
      for (var element in r) {
        subjcetList.add(SubjectModel.fromMap(element.data));
      }
    });

    final courses = await _getCourses(subjcetList);

    for (var item in subjcetList) {
      result.add(
        SubjectCourseModel(
          subject: item,
          course: courses.firstWhere((element) => element.id == item.courseId),
        ),
      );
    }

    return result;
  }

  Future<List<Course>> _getCourses(List<SubjectModel> subjects) async {
    final List<Course> courses = [];
    for (var item in subjects) {
      final res = await _courseApi.getCourseById(item.courseId);
      res.fold((l) {
        throw l.message;
      }, (r) {
        courses.add(Course.fromMap(r));
        return courses;
      });
    }
    return courses;
  }

  Future<List<SubjectModel>> getSubjectsByIds(List<String> ids) async {
    final List<SubjectModel> result = [];
    if (ids.isNotEmpty) {
      for (var id in ids) {
        final res = await _subjectApi.getSubjectById(id);
        res.fold((l) {
          throw l.message;
        }, (r) {
          result.add(SubjectModel.fromMap(r.data));
        });
      }
    }

    return result;
  }

  Future<SubjectModel> getSubjectModelById(String id) async {
    final res = await _subjectApi.getSubjectById(id);
    res.fold((l) => l, (r) => SubjectModel.fromMap(r));
    return SubjectModel(
      id: id,
      subjectCode: '',
      subjectName: '',
      courseId: '',
    );
  }

  Future<bool> submitAddSubjectForm(
    DataTableAction action,
    String? id,
    subjectCode,
    subjectName,
    courseId,
  ) async {
    const AsyncValue.loading();
    final SubjectModel subjectModel = SubjectModel(
      subjectCode: subjectCode,
      subjectName: subjectName,
      courseId: courseId,
      id: id ?? '',
    );

    if (action == DataTableAction.edit) {
      _updateSubjectData(subjectModel);
    } else if (action == DataTableAction.add) {
      await _addSubject(subjectModel);
    }

    return state.hasError == false;
  }

  Future<void> _addSubject(SubjectModel subjectModel) async {
    final res = await _subjectApi.addSubject(subjectModel);

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
    // if (action == DeleteAction.logically) {
    //   await _deleteSubjectLogically(id);
    // } else if (action == DeleteAction.permanantly) {
    await _deleteSubjectPermanantly(id);
    // }
    return state.hasError == false;
  }

  Future<void> _updateSubjectData(SubjectModel subject) async {
    final res = await _subjectApi.updateSubjectData(subject);
    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }

  Future<void> _deleteSubjectPermanantly(String id) async {
    final res = await _subjectApi.deleteSubjectPermanantly(id);
    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }
}
