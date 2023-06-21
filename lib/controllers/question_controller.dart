import 'package:feedbackadmin/helper/enums/question_type.dart';
import 'package:feedbackadmin/models/feedback/question_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../apis/question_api.dart';
import '../helper/enums/data_table_actions.dart';
import '../helper/enums/delete_actions.dart';

final getAllQuestionsProvider = FutureProvider((ref) {
  final questionController = ref.watch(questionControllerProvider.notifier);
  return questionController.getAllQuestions();
});

final questionControllerProvider =
    StateNotifierProvider<QuestionController, AsyncValue>((ref) {
  return QuestionController(
    questionApi: ref.watch(
      questionApiProvider,
    ),
  );
});

class QuestionController extends StateNotifier<AsyncValue> {
  final QuestionApi _questionApi;

  QuestionController({required QuestionApi questionApi})
      : _questionApi = questionApi,
        super(
          const AsyncData(null),
        );

  Future<List<QuestionModel>> getAllQuestions() async {
    final res = await _questionApi.getAllQuestions();
    final List<QuestionModel> result = [];

    res.fold((l) {
      throw l.message;
    }, (r) {
      for (var element in r) {
        result.add(QuestionModel.fromMap(element.data));
      }

      return result;
    });

    return result;
  }

  Future<QuestionModel> getQuestionById(String id) async {
    final res = await _questionApi.getQuestionById(id);
    res.fold((l) => l, (r) => QuestionModel.fromMap(r));
    return QuestionModel(
      id: id,
      question: '',
      status: '',
      type: QuestionType.rating,
    );
  }

  Future<bool> submitAddQuestionForm(
    DataTableAction action,
    String? id,
    String question,
    QuestionType type,
    String status,
  ) async {
    const AsyncValue.loading();
    final QuestionModel questionModel = QuestionModel(
      question: question,
      type: type,
      status: status,
      id: id ?? '',
    );

    if (action == DataTableAction.edit) {
      _updateQuestionData(questionModel);
    } else if (action == DataTableAction.add) {
      await _addQuestion(questionModel);
    }

    return state.hasError == false;
  }

  Future<void> _addQuestion(QuestionModel question) async {
    final res = await _questionApi.addQuestion(question);

    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }

  Future<bool> delete(
    DeleteAction action,
    String id,
  ) async {
    if (action == DeleteAction.logically) {
      await _deleteQuestionLogically(id);
    } else if (action == DeleteAction.permanantly) {
      await _deleteQuestionPermanantly(id);
    }
    return state.hasError == false;
  }

  Future<void> _updateQuestionData(QuestionModel question) async {
    final res = await _questionApi.updateQuestionData(question);
    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }

  Future<void> _deleteQuestionLogically(String id) async {
    final res = await _questionApi.deleteQuestionLogically(id);
    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }

  Future<void> _deleteQuestionPermanantly(String id) async {
    final res = await _questionApi.deleteQuestionPermanantly(id);
    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }
}
