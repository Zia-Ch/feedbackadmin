import 'package:appwrite/appwrite.dart';
import 'package:feedbackadmin/helper/type_defs.dart';
import 'package:feedbackadmin/models/feedback/subject_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/appwrite_constants.dart';
import '../helper/failure.dart';
import '../helper/shared_state/providers.dart';

final subjectApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return SubjectApi(db: db);
});

abstract class ISubjectApi {
  FutureEither getAllSubjects();
  FutureEither getSubjectById(String id);
  FutureEither getSubjectsByIds(List<String> ids);

  FutureEither addSubject(SubjectModel data);
  FutureEither updateSubjectData(SubjectModel data);
  FutureEither deleteSubjectPermanantly(String id);
  //FutureEither deleteSubjectLogically(String id);
}

class SubjectApi implements ISubjectApi {
  final Databases _db;
  SubjectApi({required db}) : _db = db;

  @override
  FutureEither getSubjectById(String id) async {
    try {
      final res = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.subjectsCollectionId,
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
  FutureEither getAllSubjects() async {
    try {
      final res = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.subjectsCollectionId,
      );
      return right(res.documents);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither getSubjectsByIds(List<String> ids) async {
    try {
      final res = await _db.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.subjectsCollectionId,
          queries: [Query.equal("\$id", ids)]);
      return right(res.documents);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither addSubject(SubjectModel subjectModel) async {
    try {
      final res = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.subjectsCollectionId,
        documentId: ID.unique(),
        data: subjectModel.toMap(),
      );
      return right(res.data);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither updateSubjectData(SubjectModel data) async {
    try {
      final res = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.subjectsCollectionId,
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
  FutureEither deleteSubjectPermanantly(String id) async {
    try {
      final res = await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.subjectsCollectionId,
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

  /* @override
  FutureEither deleteSubjectLogically(String id) async {
    try {
      final res = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.subjectsCollectionId,
        documentId: id,
        data: {
          "status": 'unavailable',
        },
      );

      return right(res.data);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }*/
}
