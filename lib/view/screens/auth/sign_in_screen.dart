import 'package:feedbackadmin/helper/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/auth_controller.dart';
import '../../../helper/enums/auth_from_type_enum.dart';
import '../../widgets/gn_elevated_button.dart';
import '../../widgets/gn_text_form_field.dart';
import '../home/home_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future<void> _submit() async {
    final controller = ref.read(authControllerProvider.notifier);
    final success = await controller.submitForm(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      formType: AuthFormType.signIn,
    );
    if (success) {
      Navigator.pushReplacement(
        context,
        HomeScreen.route(),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

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
              "Account\nSignin", // ! Hard coded value for text
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
              hintText: "Departmental email", // ! Hard coded value for text
              controller: _emailController,
            ),
            const SizedBox(height: 20),
            GenericTextField(
              hintText: "Password", // ! Hard coded value for text
              controller: _passwordController,
            ),
            const Spacer(),
            GenericElevatedButton(
                voidCallBack: state.isLoading ? null : _submit,
                isLoading: state.isLoading, // ! Hard coded value for isLoading
                size: size,
                btnText: "Sign In"), // ! Hard coded value for text

            // ! Create here terms and conditions like reflectly

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    "Don't have an account?"), // ! Hard coded value for text
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      SignUpScreen.route(),
                    );
                  },
                  child: const Text("Sign Up"), // ! Hard coded value for text
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
