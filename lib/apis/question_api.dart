import 'package:appwrite/appwrite.dart';
import 'package:feedbackadmin/constants/appwrite_constants.dart';
import 'package:feedbackadmin/helper/type_defs.dart';
import 'package:feedbackadmin/models/feedback/question_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../helper/failure.dart';
import '../helper/shared_state/providers.dart';

final questionApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return QuestionApi(db: db);
});

abstract class IQuestionApi {
  FutureEither getAllQuestions();
  FutureEither getQuestionById(String id);
  FutureEither addQuestion(QuestionModel data);
  FutureEither updateQuestionData(QuestionModel data);
  FutureEither deleteQuestionPermanantly(String id);
  FutureEither deleteQuestionLogically(String id);
}

class QuestionApi implements IQuestionApi {
  final Databases _db;
  QuestionApi({required db}) : _db = db;

  @override
  FutureEither getQuestionById(String id) async {
    try {
      final res = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.questionsCollectionId,
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
  FutureEither getAllQuestions() async {
    try {
      final res = await _db.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.questionsCollectionId,
          queries: [Query.equal('status', 'available')]);
      return right(res.documents);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither addQuestion(QuestionModel question) async {
    try {
      final res = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.questionsCollectionId,
        documentId: ID.unique(),
        data: question.toMap(),
      );
      return right(res.data);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither updateQuestionData(QuestionModel data) async {
    try {
      final res = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.questionsCollectionId,
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
  FutureEither deleteQuestionPermanantly(String id) async {
    try {
      final res = await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.questionsCollectionId,
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
  FutureEither deleteQuestionLogically(String id) async {
    try {
      final res = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.questionsCollectionId,
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
  }
}
