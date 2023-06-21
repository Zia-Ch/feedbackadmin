// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:feedbackadmin/models/feedback/course_model.dart';
import 'package:feedbackadmin/models/feedback/subject_model.dart';

class SubjectCourseModel {
  final SubjectModel subject;
  final Course course;

  SubjectCourseModel({
    required this.subject,
    required this.course,
  });

  SubjectCourseModel copyWith({
    SubjectModel? subject,
    Course? course,
  }) {
    return SubjectCourseModel(
      subject: subject ?? this.subject,
      course: course ?? this.course,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subject': subject.toMap(),
      'course': course.toMap(),
    };
  }

  factory SubjectCourseModel.fromMap(Map<String, dynamic> map) {
    return SubjectCourseModel(
      subject: SubjectModel.fromMap(map['subject'] as Map<String, dynamic>),
      course: Course.fromMap(map['course'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectCourseModel.fromJson(String source) =>
      SubjectCourseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SubjectCourseModel(subject: $subject, course: $course)';

  @override
  bool operator ==(covariant SubjectCourseModel other) {
    if (identical(this, other)) return true;

    return other.subject == subject && other.course == course;
  }

  @override
  int get hashCode => subject.hashCode ^ course.hashCode;
}
