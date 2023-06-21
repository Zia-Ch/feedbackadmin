import 'package:appwrite/appwrite.dart';
import 'package:feedbackadmin/constants/appwrite_constants.dart';
import 'package:feedbackadmin/helper/type_defs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../helper/failure.dart';
import '../helper/shared_state/providers.dart';

final sectionApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return SectionApi(db: db);
});

abstract class ISectionApi {
  FutureEither getAllSections();
  FutureEither getSectionById(String id);
}

class SectionApi implements ISectionApi {
  final Databases _db;
  SectionApi({required db}) : _db = db;

  @override
  FutureEither getSectionById(String id) async {
    try {
      final res = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.sectionsCollectionId,
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
  FutureEither getAllSections() async {
    try {
      final res = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.sectionsCollectionId,
      );
      return right(res.documents);
    } on AppwriteException catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }
}
