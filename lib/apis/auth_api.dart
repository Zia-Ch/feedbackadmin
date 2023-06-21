import 'package:feedbackadmin/helper/extentions/email_to_roll_no_extention.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;

import '../helper/failure.dart';
import '../helper/shared_state/providers.dart';
import '../helper/type_defs.dart';

final currentUserAccountProvider = FutureProvider<model.User?>((ref) {
  final authApi = ref.watch(authApiProvider);
  return authApi.currentUserAccount();
});

final authApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthApi(account: account);
});

abstract class IAuthApi {
  FutureEither<model.User> signup({
    required String email,
    required String password,
  });

  FutureEither<model.Session> signin({
    required String email,
    required String password,
  });

  FutureEitherVoid signout();
  Future<model.User?> currentUserAccount();
}

class AuthApi implements IAuthApi {
  final Account _account;
  AuthApi({required Account account}) : _account = account;
  @override
  Future<model.User?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<model.Session> signin(
      {required String email, required String password}) async {
    try {
      final model.Session account = await _account.createEmailSession(
        email: email,
        password: password,
      );

      return right(account);
    } on AppwriteException catch (e, st) {
      return left(Failure(
          message: e.message ?? "Some unexpected error occuered",
          stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEitherVoid signout() async {
    try {
      await _account.deleteSession(
        sessionId: 'current',
      );

      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(
          message: e.message ?? "Some unexpected error occuered",
          stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  FutureEither<model.User> signup(
      {required String email, required String password}) async {
    try {
      final model.User account = await _account.create(
        userId: email.emailToRollNo(),
        email: email,
        password: password,
      );

      return right(account);
    } on AppwriteException catch (e, st) {
      return left(Failure(
          message: e.message ?? "Some unexpected error occuered",
          stackTrace: st));
    } catch (e, st) {
      return left(Failure(message: e.toString(), stackTrace: st));
    }
  }
}
