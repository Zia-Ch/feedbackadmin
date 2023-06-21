// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:feedbackadmin/helper/enums/question_type.dart';
import 'package:feedbackadmin/helper/extentions/question_enum_to_text.dart';

class QuestionModel {
  final String id;
  final String question;
  final String status;
  final QuestionType type;

  QuestionModel(
      {required this.id,
      required this.question,
      required this.status,
      required this.type});

  QuestionModel copyWith({
    String? id,
    String? question,
    String? status,
    QuestionType? type,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      question: question ?? this.question,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'question': question,
      'status': status,
      'type': type.name,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['\$id'] as String,
      question: map['question'] as String,
      status: map['status'] as String,
      type: (map['type'] as String).toQuestionTypeEnum(),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromJson(String source) =>
      QuestionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QuestionModel(id: $id, question: $question, status: $status, type: $type)';
  }

  @override
  bool operator ==(covariant QuestionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.question == question &&
        other.status == status &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^ question.hashCode ^ status.hashCode ^ type.hashCode;
  }
}
