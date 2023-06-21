// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FeedbackModel {
  final String subjectId;
  final String teacherId;
  final String questionId;
  final double rating;
  final String comment;

  FeedbackModel({
    required this.subjectId,
    required this.teacherId,
    required this.questionId,
    required this.rating,
    required this.comment,
  });

  FeedbackModel copyWith({
    String? subjectId,
    String? teacherId,
    String? questionId,
    double? rating,
    String? comment,
  }) {
    return FeedbackModel(
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      questionId: questionId ?? this.questionId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subjectId': subjectId,
      'teacherId': teacherId,
      'questionId': questionId,
      'rating': rating,
      'comment': comment,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      subjectId: map['subjectId'] as String,
      teacherId: map['teacherId'] as String,
      questionId: map['questionId'] as String,
      rating: map['rating'] as double,
      comment: map['comment'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedbackModel.fromJson(String source) =>
      FeedbackModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FeedbackModel(subjectId: $subjectId, teacherId: $teacherId, questionId: $questionId, rating: $rating, comment: $comment)';
  }

  @override
  bool operator ==(covariant FeedbackModel other) {
    if (identical(this, other)) return true;

    return other.subjectId == subjectId &&
        other.teacherId == teacherId &&
        other.questionId == questionId &&
        other.rating == rating &&
        other.comment == comment;
  }

  @override
  int get hashCode {
    return subjectId.hashCode ^
        teacherId.hashCode ^
        questionId.hashCode ^
        rating.hashCode ^
        comment.hashCode;
  }
}

//final String sectionId;
//final String semesterId;
 //final String courseId;
