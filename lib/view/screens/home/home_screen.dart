import 'package:feedbackadmin/helper/extentions/widget_padding.dart';
import 'package:feedbackadmin/models/feedback/user_model.dart';
import 'package:feedbackadmin/view/screens/home/home_data_card.dart';
import 'package:feedbackadmin/view/widgets/async_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/feedback_controller.dart';
import '../feedback/feedback_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static route() => MaterialPageRoute(builder: (context) => const HomeScreen());

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider);
    return Scaffold(
      //backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: AsyncValueWidget<UserModel?>(
        value: user,
        data: (user) {
          return Center(
            child: user == null
                ? const Text('No user found')
                // : Consumer(
                //     builder: (_, conRef, __) {
                // final value =
                //     conRef.watch(feedbackSubjectsProvider(user.id));

                // return
                : AsyncValueWidget(
                    value: ref.watch(feedbackSubjectsProvider(user.id)),
                    data: (feedbackHomeModel) {
                      return feedbackHomeModel.isEmpty
                          ? const Center(child: Text("No pending feedbacks"))
                          : ListView.builder(
                              itemCount: feedbackHomeModel.length,
                              itemBuilder: (context, index) {
                                return HomeDataCard(
                                  data: feedbackHomeModel[index],
                                  onTap: () {
                                    ref.invalidate(
                                        feedbackSubjectsProvider(user.id));
                                    Navigator.of(context).pushReplacement(
                                      FeedbackScreen.route(
                                          feedbackHomeModel[index]),
                                    );
                                  },
                                );
                              },
                            );
                    },
                  ),
          ).addPadding(3);
        },
      ),
    );
  }
}
