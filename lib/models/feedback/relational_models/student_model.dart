// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:feedbackadmin/models/feedback/batch_model.dart';
import 'package:feedbackadmin/models/feedback/section_model.dart';
import 'package:feedbackadmin/models/feedback/user_model.dart';

import '../course_model.dart';

class StudentModel {
  final UserModel user;
  final Section section;
  final Course course;
  final Batch batch;

  StudentModel({
    required this.user,
    required this.section,
    required this.course,
    required this.batch,
  });

  StudentModel copyWith({
    UserModel? user,
    Section? section,
    Course? course,
    Batch? batch,
  }) {
    return StudentModel(
      user: user ?? this.user,
      section: section ?? this.section,
      course: course ?? this.course,
      batch: batch ?? this.batch,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'section': section.toMap(),
      'course': course.toMap(),
      'batch': batch.toMap(),
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
      section: Section.fromMap(map['section'] as Map<String, dynamic>),
      course: Course.fromMap(map['course'] as Map<String, dynamic>),
      batch: Batch.fromMap(map['batch'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentModel.fromJson(String source) =>
      StudentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StudentModel(user: $user, section: $section, course: $course, batch: $batch)';

  @override
  bool operator ==(covariant StudentModel other) {
    if (identical(this, other)) return true;

    return other.user == user &&
        other.section == section &&
        other.course == course &&
        other.batch == batch;
  }

  @override
  int get hashCode =>
      user.hashCode ^ section.hashCode ^ course.hashCode ^ batch.hashCode;
}
