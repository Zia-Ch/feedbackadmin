import 'package:appwrite/appwrite.dart';
import 'package:feedbackadmin/helper/type_defs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/appwrite_constants.dart';
import '../helper/failure.dart';
import '../helper/shared_state/providers.dart';

final courseApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return CourseApi(db: db);
});

abstract class ICourseApi {
  FutureEither getAllCourses();
  FutureEither getCourseById(String id);
}

class CourseApi implements ICourseApi {
  final Databases _db;
  CourseApi({required db}) : _db = db;

  @override
  FutureEither getCourseById(String id) async {
    try {
      final res = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.coursesCollectionId,
        documentId: id,
      );
      return right(res.data);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither getAllCourses() async {
    try {
      final res = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.coursesCollectionId,
      );
      return right(res.documents);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }
}
