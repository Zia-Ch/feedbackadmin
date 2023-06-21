import 'package:appwrite/appwrite.dart';
import 'package:feedbackadmin/helper/type_defs.dart';
import 'package:feedbackadmin/models/feedback/batch_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/appwrite_constants.dart';
import '../helper/failure.dart';
import '../helper/shared_state/providers.dart';

final batchApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return BatchApi(db: db);
});

abstract class IBatchApi {
  FutureEither getAllBatchs();
  FutureEither getBatchById(String id);
  FutureEither addBatch(Batch data);
  FutureEither updateBatchData(Batch data);
  FutureEither deleteBatchPermanantly(String id);
  //FutureEither deleteBatchLogically(String id);
}

class BatchApi implements IBatchApi {
  final Databases _db;
  BatchApi({required db}) : _db = db;

  @override
  FutureEither getBatchById(String id) async {
    try {
      final res = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.batchesCollectionId,
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
  FutureEither getAllBatchs() async {
    try {
      final res = await _db.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.batchesCollectionId,
          queries: [Query.orderDesc('batch')]);
      return right(res.documents);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither addBatch(Batch question) async {
    try {
      final res = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.batchesCollectionId,
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
  FutureEither updateBatchData(Batch data) async {
    try {
      final res = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.batchesCollectionId,
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
  FutureEither deleteBatchPermanantly(String id) async {
    try {
      final res = await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.batchesCollectionId,
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
  FutureEither deleteBatchLogically(String id) async {
    try {
      final res = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.batchesCollectionId,
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
