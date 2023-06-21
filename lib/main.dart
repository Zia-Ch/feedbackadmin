import 'package:feedbackadmin/controllers/course_controller.dart';
import 'package:feedbackadmin/view/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'apis/auth_api.dart';
import 'view/screens/auth/sign_in_screen.dart';
import 'view/widgets/async_value_widget.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Feedback Admin',
      theme: ThemeMode.system == ThemeMode.dark
          ? ThemeData.dark()
          : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: AsyncValueWidget(
        value: ref.watch(currentUserAccountProvider),
        data: (user) {
          if (user != null) {
            ref.watch(allCourseProvider);
            return const DashBoard();
          }
          return const SignInScreen();
        },
      ),
    );
  }
}
