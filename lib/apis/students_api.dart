import 'package:appwrite/appwrite.dart';
import 'package:feedbackadmin/constants/appwrite_constants.dart';
import 'package:feedbackadmin/helper/failure.dart';
import 'package:feedbackadmin/helper/type_defs.dart';
import 'package:feedbackadmin/models/feedback/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../helper/shared_state/providers.dart';

// TODO: apply check in feedback app to
// check if user data already present in database
// then don't save it again

final studentApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return StudentApi(db: db);
});

abstract class IStudentApi {
  FutureEither getStudentById(String id);
  FutureEither getAllStudents();
  FutureEither addStudent(UserModel data);
  FutureEither updateStudentData(UserModel data);
  FutureEither deleteStudentPermanantly(String id);
  FutureEither deleteStudentLogically(String id);
}

class StudentApi implements IStudentApi {
  final Databases _db;
  StudentApi({required db}) : _db = db;

  @override
  FutureEither getStudentById(String id) async {
    try {
      final res = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
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
  FutureEither getAllStudents() async {
    try {
      final res = await _db.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.userCollectionId,
          queries: [Query.notEqual("isDeleted", true)]);
      return right(res.documents);
    } on AppwriteConstants catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither addStudent(UserModel data) async {
    try {
      final res = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
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
  FutureEither updateStudentData(UserModel data) async {
    try {
      final res = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
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
  FutureEither deleteStudentPermanantly(String id) async {
    try {
      final res = await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
        documentId: id,
        // TODO: also delete from feedbacks and from everywhere where this id is used
      );
      return right(res);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither deleteStudentLogically(String id) async {
    try {
      final res = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
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
}
