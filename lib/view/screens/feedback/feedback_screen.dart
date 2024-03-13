import 'package:feedbackadmin/controllers/feedback_controller.dart';
import 'package:feedbackadmin/helper/async_value_ui.dart';
import 'package:feedbackadmin/helper/enums/question_type.dart';
import 'package:feedbackadmin/helper/extentions/mediaquery_size_extention.dart';
import 'package:feedbackadmin/models/feedback/feedback_home_data_model.dart';
import 'package:feedbackadmin/models/feedback/feedback_model.dart';
import 'package:feedbackadmin/models/feedback/indexd_feedbacks.dart';
import 'package:feedbackadmin/view/screens/feedback/components/feedback_card.dart';
import 'package:feedbackadmin/view/screens/feedback/components/feedback_card_header.dart';
import 'package:feedbackadmin/view/widgets/async_value_widget.dart';
import 'package:feedbackadmin/view/widgets/gn_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/feedback_ratings.dart';
import 'components/feedback_textfield.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({required this.data, super.key});
  static route(FeedbackHomeDataModel data) => MaterialPageRoute(
      builder: (context) => FeedbackScreen(
            data: data,
          ));
  final FeedbackHomeDataModel data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final List<IndexdFeedBacks> feedbackList = [];

  addToFeedbackList(IndexdFeedBacks item) {
    for (var element in feedbackList) {
      if (element.index == item.index) {
        feedbackList.remove(element);

        break;
      }
    }
    feedbackList.add(item);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(feedbackQuestionProvider);
    ref.listen<AsyncValue>(
      feedbackQuestionProvider,
      (_, state) => state.showAlertOnError(context),
    );

    ref.listen<AsyncValue>(
      feedbackControllerProvider,
      (_, state) => state.showAlertOnError(context),
    );

    return Scaffold(
      //backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(" Feedback screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: AsyncValueWidget(
                value: questions,
                data: (questions) {
                  return ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FeedbackCard(
                        header: FeedbackCardHeader(
                          qnumber: index + 1,
                          question: questions[index].question,
                        ),
                        body: questions[index].type == QuestionType.comment
                            ? FeedbackTextField(
                                onTextChange: (text) {
                                  final item = IndexdFeedBacks(
                                    index: index,
                                    questionType: QuestionType.comment,
                                    feedback: FeedbackModel(
                                      comment: text,
                                      questionId: questions[index].id,
                                      rating: 0.0,
                                      subjectId: widget.data.subjectModel.id,
                                      teacherId: widget.data
                                          .userTeacherFeedbackMxN.teacherId,
                                    ),
                                  );

                                  addToFeedbackList(item);
                                },
                              )
                            : FeedbackRatings(
                                onSubmitRating: (double value) {
                                  final item = IndexdFeedBacks(
                                    index: index,
                                    questionType: QuestionType.rating,
                                    feedback: FeedbackModel(
                                      comment: '',
                                      questionId: questions[index].id,
                                      rating: value,
                                      subjectId: widget.data.subjectModel.id,
                                      teacherId: widget.data
                                          .userTeacherFeedbackMxN.teacherId,
                                    ),
                                  );

                                  addToFeedbackList(item);
                                },
                              ),
                      );
                    },
                  );
                },
              ),
            ),
            Consumer(
              builder: (_, ref, __) {
                final feedbackController =
                    ref.watch(feedbackControllerProvider);
                return GenericElevatedButton(
                  isLoading: feedbackController.isLoading,
                  size: context.screenSize,
                  btnText: "Submit",
                  voidCallBack: questions.isLoading ||
                          feedbackController.isLoading
                      ? null
                      : () async {
                          final submit =
                              ref.read(feedbackControllerProvider.notifier);

                          final bool submitted = await submit.submitFeedback(
                              feedbackList,
                              questions.value!.length,
                              widget.data.userTeacherFeedbackMxN);
                          if (submitted) {
                            Navigator.of(context).pop();
                          }
                        },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
