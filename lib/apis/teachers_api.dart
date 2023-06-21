import 'package:appwrite/appwrite.dart';
import 'package:feedbackadmin/constants/appwrite_constants.dart';
import 'package:feedbackadmin/helper/failure.dart';
import 'package:feedbackadmin/helper/type_defs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../helper/shared_state/providers.dart';
import '../models/feedback/teacher_model.dart';

// TODO: apply check in feedback app to
// check if user data already present in database
// then don't save it again

final teacherApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return TeacherApi(db: db);
});

abstract class ITeacherApi {
  FutureEither getTeacherById(String id);
  FutureEither getAllTeachers();
  FutureEither addTeacher(Teacher data);
  FutureEither updateTeacherData(Teacher data);
  FutureEither deleteTeacherPermanantly(String id);
  FutureEither deleteTeacherLogically(String id);
  FutureEither getTeacherSubjectId(String id);
}

class TeacherApi implements ITeacherApi {
  final Databases _db;
  TeacherApi({required db}) : _db = db;

  @override
  FutureEither getTeacherById(String id) async {
    try {
      final res = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teachersCollectionId,
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
  FutureEither getAllTeachers() async {
    try {
      final res = await _db.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.teachersCollectionId,
          queries: [Query.notEqual("isDeleted", true)]);

      return right(res.documents);
    } on AppwriteConstants catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither addTeacher(Teacher data) async {
    try {
      final res = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teachersCollectionId,
        documentId: data.id,
        data: data.toMap(),
      );

      return right(res.data);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither updateTeacherData(Teacher data) async {
    try {
      final res = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teachersCollectionId,
        documentId: data.id,
        data: data.toMap(),
      );
      return right(res.data);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither deleteTeacherPermanantly(String id) async {
    try {
      final res = await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teachersCollectionId,
        documentId: id,
        // TODO: also delete from anywhere  where this id is used
      );
      return right(res);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither deleteTeacherLogically(String id) async {
    try {
      final res = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teachersCollectionId,
        documentId: id,
        data: {
          "isDeleted": true,
        },
      );

      return right(res.data);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither getTeacherSubjectId(String id) async {
    try {
      final res = await _db.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.teachersCollectionId,
          queries: [Query.search("subjects", id)]);

      return right(res.documents);
    } on AppwriteConstants catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }
}
