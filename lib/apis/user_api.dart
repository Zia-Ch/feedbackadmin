import 'package:appwrite/appwrite.dart';
import 'package:feedbackadmin/constants/appwrite_constants.dart';
import 'package:feedbackadmin/helper/extentions/email_to_roll_no_extention.dart';
import 'package:feedbackadmin/helper/failure.dart';
import 'package:feedbackadmin/models/feedback/user_model.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../helper/shared_state/providers.dart';
import '../helper/type_defs.dart';

final userApiProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return UserApi(db: db);
});

abstract class IUserApi {
  FutureEitherVoid saveUserDetails({required UserModel userModel});
  Future<models.Document> getUserData(String userId);
}

class UserApi implements IUserApi {
  UserApi({required Databases db}) : _db = db;

  final Databases _db;

  @override
  Future<models.Document> getUserData(String userId) async {
    return await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.userCollectionId,
      documentId: userId,
    );
  }

  @override
  FutureEitherVoid saveUserDetails({required UserModel userModel}) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
        documentId: userModel.email.emailToRollNo(),
        data: userModel.toMap(),
      );

      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(
        message: e.message.toString(),
        stackTrace: st,
      ));
    } catch (e, st) {
      return left(
        Failure(
          message: e.toString(),
          stackTrace: st,
        ),
      );
    }
  }
}
