import '../enums/question_type.dart';

extension ConvertQuestion on String {
  QuestionType toQuestionTypeEnum() {
    switch (this) {
      case 'comment':
        return QuestionType.comment;
      case 'rating':
        return QuestionType.rating;
      default:
        return QuestionType.rating;
    }
  }
}
