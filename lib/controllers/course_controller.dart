import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../apis/course_api.dart';
import '../helper/shared_state/updator.dart';
import '../models/feedback/course_model.dart';

final allCourseProvider = FutureProvider((ref) {
  final courseController = ref.watch(courseControllerProvider.notifier);
  ref.watch(futureStateUpdator);
  return courseController.getAllCourses();
});

final courseControllerProvider =
    StateNotifierProvider<CourseController, AsyncValue>((ref) {
  return CourseController(
    courseApi: ref.watch(
      courseApiProvider,
    ),
  );
});

class CourseController extends StateNotifier<AsyncValue> {
  final CourseApi _courseApi;

  CourseController({required CourseApi courseApi})
      : _courseApi = courseApi,
        super(
          const AsyncData(null),
        );

  Future<List<Course>> getAllCourses() async {
    final res = await _courseApi.getAllCourses();
    final List<Course> result = [];

    res.fold((l) {
      throw l.message;
    }, (r) {
      for (var element in r) {
        result.add(Course.fromMap(element.data));
      }

      return result;
    });

    return result;
  }

  /* Future<Course> getCourseById(String id) async {
    final res = await _courseApi.getCourseById(id);
    if (res.isRight()) {
      return Course.fromMap(res.getOrElse(() => {}));
    } else {
      throw res.fold((l) => l, (r) => r);
    }
  }*/
}
