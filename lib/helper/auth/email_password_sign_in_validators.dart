import '../enums/auth_from_type_enum.dart';
import 'string_validators.dart';

//TODO remove hard coded values
/// Mixin class to be used for client-side email & password validation
class EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();

  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  bool canSubmitPassword(String password, AuthFormType formType) {
    if (formType == AuthFormType.signUp) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText = email.isEmpty
        ? 'Email can\'t be empty' //.hardcoded
        : 'Invalid email'; // .hardcoded;
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(String password, AuthFormType formType) {
    final bool showErrorText = !canSubmitPassword(password, formType);
    final String errorText = password.isEmpty
        ? 'Password can\'t be empty' //.hardcoded
        : 'Password is too short'; //.hardcoded;
    return showErrorText ? errorText : null;
  }

  String? passwordmatched(String password, String confirmPassword) {
    final bool showErrorText = password != confirmPassword;
    final String? errorText = showErrorText
        ? 'Password does not match' //.hardcoded
        : null; //.hardcoded;
    return errorText;
  }
}
