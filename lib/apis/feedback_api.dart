import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:feedbackadmin/helper/type_defs.dart';
import 'package:feedbackadmin/models/feedback/feedback_model.dart';
import 'package:feedbackadmin/models/feedback/relational_models/user_teacher_feedback_mxn_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/appwrite_constants.dart';
import '../helper/failure.dart';
import '../helper/shared_state/providers.dart';

// ! TODO: Impliment try and  catch for all apis

final feedBackApiProvider = Provider(
  (ref) => FeedBackApi(
    db: ref.watch(appwriteDatabaseProvider),
  ),
);

abstract class IFeedbackApi {
  //Future<List<Document>> getRemainingFeedbackSubjectsData(
  //    List<String> subjects);
  Future<List<Document>> getAllAssignedFeedbacks(String userId);
  Future<List<Document>> getPendingFeedbackSubjectsData(List<String> subjects);
  Future<List<Document>> getPendingFeedbacks(String userId);
  Future<List<Document>> getQuestions();
  FutureEither submitFeedback(
      List<FeedbackModel> feedbacks, UserTeacherFeedbackMxN data);
  FutureEither addFeedbackForStudents(UserTeacherFeedbackMxN data);
  FutureEither deleteAssignedFeedbacks(String id);
}

class FeedBackApi implements IFeedbackApi {
  final Databases _db;

  FeedBackApi({required Databases db}) : _db = db;

  /*Future<List<Document>> getRemainingFeedbackSubjectsData(
      List<String> subjects) async {
    final res = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.subjectsCollectionId,
      queries: [Query.equal("\$id", subjects)],
    );

    return res.documents;
  }*/

  @override
  Future<List<Document>> getPendingFeedbackSubjectsData(
    List<String> subjects,
  ) async {
    final res = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.subjectsCollectionId,
      queries: [Query.equal("\$id", subjects)],
    );
    return res.documents;
  }

  @override
  Future<List<Document>> getPendingFeedbacks(String userId) async {
    /* final res1 = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.feedbackCollectionId,
    );

    for (var element in res1.documents) {
      await _db.deleteDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.feedbackCollectionId,
          documentId: element.$id);
      
    }*/
    final res = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userTeacherFeedbackMNCollectionId,
        queries: [
          Query.equal("userId", userId),
          Query.equal("isFeedbackDone", false),
        ]);

    return res.documents;
  }

  @override
  Future<List<Document>> getAllAssignedFeedbacks(String userId) async {
    final res = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userTeacherFeedbackMNCollectionId,
        queries: [
          Query.equal("userId", userId),
        ]);

    return res.documents;
  }

  @override
  Future<List<Document>> getQuestions() async {
    final res = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.questionsCollectionId,
    );

    return res.documents;
  }

  @override
  FutureEither submitFeedback(
      List<FeedbackModel> feedbacks, UserTeacherFeedbackMxN data) async {
    for (var item in feedbacks) {
      try {
        await _db.createDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.feedbackCollectionId,
            documentId: ID.unique(),
            data: item.toMap());
      } on AppwriteException catch (e, st) {
        return left(
          Failure(
            message: e.message.toString(),
            stackTrace: st,
          ),
        );
      } catch (e, st) {
        return left(
          Failure(
            message: e.toString(),
            stackTrace: st,
          ),
        );
      }
    }
    data = data.copyWith(
      isFeedbackDone: true,
    );
    await _db.updateDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.userTeacherFeedbackMNCollectionId,
      documentId: data.id,
      data: data.toMap(),
    );

    return right(
      "Feedback submitted successfully!",
    );
  }

  @override
  FutureEither addFeedbackForStudents(UserTeacherFeedbackMxN data) async {
    try {
      final res = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userTeacherFeedbackMNCollectionId,
        documentId: ID.unique(),
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
  FutureEither deleteAssignedFeedbacks(String id) async {
    try {
      final res = await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userTeacherFeedbackMNCollectionId,
        documentId: id,
      );
      return right(res);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }
}
