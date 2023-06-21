import 'package:feedbackadmin/helper/async_value_ui.dart';
import 'package:feedbackadmin/view/screens/auth/sign_in_screen.dart';
import 'package:feedbackadmin/view/widgets/gn_elevated_button.dart';
import 'package:feedbackadmin/view/widgets/gn_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/auth_controller.dart';
import '../../../helper/enums/auth_from_type_enum.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  Future<void> _submit() async {
    final controller = ref.read(authControllerProvider.notifier);
    final success = await controller.submitForm(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
      formType: AuthFormType.signUp,
    );
    if (success) {
      Navigator.pushReplacement(
        context,
        SignInScreen.route(),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    ref.listen<AsyncValue>(
      authControllerProvider,
      (_, state) => state.showAlertOnError(context),
    );
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      //backgroundColor: Colors.blue[50], // ! hard coded value for color
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(14), // ! hard coded value for padding
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Account\nSignup", // ! Hard coded value for text
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 45,
                color: Colors.black
                    .withOpacity(0.2), // ! Hard coded value for color
                letterSpacing: 1, // ! Hard coded value for letter spacing
                fontFamily: GoogleFonts.kumbhSans()
                    .fontFamily, // ! hard coded value for font family
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            GenericTextField(
              hintText: "Departmental email",
              controller: _emailController,

              keyboardType: TextInputType.emailAddress,

              //onEditingComplete: () => _emailEditingComplete(),
            ),

            const SizedBox(height: 20),
            GenericTextField(
              hintText: "Password",
              controller: _passwordController,
              //keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 20),
            GenericTextField(
              hintText: "Confirm Password",
              controller: _confirmPasswordController,
              //keyboardType: TextInputType.visiblePassword,
            ),
            const Spacer(),
            GenericElevatedButton(
                voidCallBack: state.isLoading ? null : _submit,
                isLoading: state.isLoading,
                size: size,
                btnText: "Sign Up"), // ! Hard coded value for text
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    "Already have an account?"), // ! Hard coded value for text
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      SignInScreen.route(),
                    );
                  },
                  child: const Text("Sign In"), // ! Hard coded value for text
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
