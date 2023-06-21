// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserTeacherFeedbackMxN {
  final String id;
  final String userId;
  final String subjectId;
  final String teacherId;
  final bool isFeedbackDone;

  UserTeacherFeedbackMxN({
    required this.id,
    required this.userId,
    required this.subjectId,
    required this.teacherId,
    required this.isFeedbackDone,
  });

  UserTeacherFeedbackMxN copyWith({
    String? id,
    String? userId,
    String? subjectId,
    String? teacherId,
    bool? isFeedbackDone,
  }) {
    return UserTeacherFeedbackMxN(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      isFeedbackDone: isFeedbackDone ?? this.isFeedbackDone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'subjectId': subjectId,
      'teacherId': teacherId,
      'isFeedbackDone': isFeedbackDone,
    };
  }

  factory UserTeacherFeedbackMxN.fromMap(Map<String, dynamic> map) {
    return UserTeacherFeedbackMxN(
      id: map['\$id'] as String,
      userId: map['userId'] as String,
      subjectId: map['subjectId'] as String,
      teacherId: map['teacherId'] as String,
      isFeedbackDone: map['isFeedbackDone'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserTeacherFeedbackMxN.fromJson(String source) =>
      UserTeacherFeedbackMxN.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserTeacherFeedbackMxN(id: $id, userId: $userId, subjectId: $subjectId, teacherId: $teacherId, isFeedbackDone: $isFeedbackDone)';
  }

  @override
  bool operator ==(covariant UserTeacherFeedbackMxN other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.subjectId == subjectId &&
        other.teacherId == teacherId &&
        other.isFeedbackDone == isFeedbackDone;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        subjectId.hashCode ^
        teacherId.hashCode ^
        isFeedbackDone.hashCode;
  }
}
