import 'package:feedbackadmin/apis/auth_api.dart';
import 'package:feedbackadmin/apis/user_api.dart';
import 'package:feedbackadmin/helper/auth/email_password_sign_in_validators.dart';
import 'package:feedbackadmin/helper/enums/auth_from_type_enum.dart';
import 'package:feedbackadmin/helper/extentions/email_to_roll_no_extention.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart' as model;

import '../helper/shared_state/updator.dart';
import '../models/feedback/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue>((ref) {
  ref.watch(futureStateUpdator);
  return AuthController(
    authApi: ref.watch(authApiProvider),
    userApi: ref.watch(userApiProvider),
  );
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<AsyncValue> {
  final AuthApi _authApi;
  final UserApi _userApi;
  final emailPasswordValidator = EmailAndPasswordValidators();

  AuthController({
    required AuthApi authApi,
    required UserApi userApi,
  })  : _authApi = authApi,
        _userApi = userApi,
        super(
          const AsyncData(null),
        );

  Future<bool> submitForm({
    required String email,
    required String password,
    required AuthFormType formType,
    String confirmPassword = '',
  }) async {
    state = const AsyncValue.loading();
    String? emailErrorText = emailPasswordValidator.emailErrorText(email);
    String? passwordErrorText =
        emailPasswordValidator.passwordErrorText(password, formType);
    String? passwordMatchedErrorText = emailPasswordValidator.passwordmatched(
      password,
      confirmPassword,
    );
    if (emailErrorText != null) {
      state = AsyncValue.error(emailErrorText, StackTrace.current);
    } else if (passwordErrorText != null) {
      state = AsyncValue.error(passwordErrorText, StackTrace.current);
    } else if (formType == AuthFormType.signUp &&
        passwordMatchedErrorText != null) {
      state = AsyncValue.error(passwordMatchedErrorText, StackTrace.current);
    } else {
      await _authenticate(
        email: email,
        password: password,
        formType: formType,
        confirmPassword: confirmPassword,
      );
    }

    return state.hasError == false;
  }

  Future<void> _authenticate({
    required String email,
    required String password,
    required AuthFormType formType,
    String? confirmPassword,
  }) async {
    switch (formType) {
      case AuthFormType.signUp:
        final res = await _authApi.signup(
          email: email,
          password: password,
        );
        res.fold(
          (l) => state = AsyncValue.error(
            l.message,
            l.stackTrace,
          ),
          (r) async {
            await _saveUserDetials(email: email);
            state = AsyncValue.data(r);
          },
        );
        break;

      case AuthFormType.signIn:
        final res = await _authApi.signin(email: email, password: password);
        res.fold(
          (l) => state = AsyncValue.error(
            l.message,
            l.stackTrace,
          ),
          (r) => state = AsyncValue.data(r),
        );
        break;

      // ! case AuthFormType.signOut:
    }
  }

  Future<model.User?> get currentUser => _authApi.currentUserAccount();

  Future<void> _saveUserDetials({required String email}) async {
    final res = await _userApi.saveUserDetails(
      userModel: UserModel(
        id: email.emailToRollNo(),
        name: '',
        email: email,
        courseId:
            '', //TODO: impliment method to get course id and batch id an section id from email
        batchId: '',
        isAdmin: false,
        subjects: [],
        isDeleted: false,
        sectionId: '',
      ),
    );

    res.fold(
        (l) => state = AsyncValue.error(
              l.message,
              l.stackTrace,
            ),
        (r) {});
  }

  Future<UserModel> getUserData(String userId) async {
    final res = await _userApi.getUserData(userId);
    return UserModel.fromMap(res.data);
  }
}
