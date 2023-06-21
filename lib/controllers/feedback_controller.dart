import 'package:feedbackadmin/apis/feedback_api.dart';
import 'package:feedbackadmin/helper/enums/question_type.dart';
import 'package:feedbackadmin/models/feedback/feedback_home_data_model.dart';
import 'package:feedbackadmin/models/feedback/indexd_feedbacks.dart';
import 'package:feedbackadmin/models/feedback/question_model.dart';
import 'package:feedbackadmin/models/feedback/subject_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/feedback/relational_models/user_teacher_feedback_mxn_model.dart';

final feedbackControllerProvider =
    StateNotifierProvider<FeedbackController, AsyncValue>((ref) {
  return FeedbackController(
    feedbackApi: ref.watch(feedBackApiProvider),
  );
});

final feedbackSubjectsProvider =
    FutureProvider.family.autoDispose((ref, String userId) {
  final feedbackController = ref.watch(feedbackControllerProvider.notifier);
  return feedbackController.getPendingFeedbacksData(userId);
});

final feedbackQuestionProvider = FutureProvider.autoDispose((ref) {
  final feedbackController = ref.watch(feedbackControllerProvider.notifier);

  return feedbackController.getQuestions();
});

class FeedbackController extends StateNotifier<AsyncValue> {
  final FeedBackApi _feedbackApi;

  FeedbackController({required FeedBackApi feedbackApi})
      : _feedbackApi = feedbackApi,
        super(
          const AsyncData(null),
        );

  Future<List<FeedbackHomeDataModel>> getPendingFeedbacksData(
      String userId) async {
    final List<FeedbackHomeDataModel> result = [];
    final List<UserTeacherFeedbackMxN> pendingfeedbacks =
        await getPendingFeedbacks(userId);
    if (pendingfeedbacks.isNotEmpty) {
      final res = await _feedbackApi.getPendingFeedbackSubjectsData(
          pendingfeedbacks.map((e) => e.subjectId).toList());

      for (var element in res) {
        final subjectModel = SubjectModel.fromMap(element.data);
        result.add(
          FeedbackHomeDataModel(
            subjectModel: subjectModel,
            userTeacherFeedbackMxN: pendingfeedbacks.firstWhere(
              (e) => e.subjectId == subjectModel.id,
            ),
          ),
        );
      }
    }
    return result;
  }

  Future<List<UserTeacherFeedbackMxN>> getPendingFeedbacks(
      String userId) async {
    final res = await _feedbackApi.getPendingFeedbacks(userId);

    final List<UserTeacherFeedbackMxN> result = [];
    for (var element in res) {
      result.add(UserTeacherFeedbackMxN.fromMap(element.data));
    }
    return result;
  }

  Future<List<QuestionModel>> getQuestions() async {
    final res = await _feedbackApi.getQuestions();

    final List<QuestionModel> result = [];
    for (var element in res) {
      result.add(QuestionModel.fromMap(element.data));
    }
    return result;
  }

  Future<bool> submitFeedback(List<IndexdFeedBacks> feedbacks,
      int questionsLength, UserTeacherFeedbackMxN data) async {
    state = const AsyncData(null);
    state = const AsyncValue.loading();
    bool hasError = false;

    if (questionsLength != feedbacks.length) {
      state =
          AsyncValue.error("Please fill all the questions", StackTrace.current);
      return false;
    }

    for (var item in feedbacks) {
      if (item.questionType == QuestionType.rating) {
        if (item.feedback.rating == 0) {
          hasError = true;
          state = AsyncValue.error(
              "Please fill all the questions", StackTrace.current);
          return false;
        }
      } else if (item.questionType == QuestionType.comment) {
        if (item.feedback.comment.isEmpty) {
          hasError = true;
          state = AsyncValue.error(
              "Please fill all the questions", StackTrace.current);
          return false;
        }
      }
    }

    if (hasError != true) {
      final res = await _feedbackApi.submitFeedback(
        feedbacks.map((e) => e.feedback).toList(),
        data,
      );
      res.fold(
        (l) => state = AsyncValue.error(l, StackTrace.current),
        (r) => state = AsyncValue.data(r),
      );
    }
    return state.hasError == false;
  }
}
