// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Course {
  final String id;
  final String courseName;
  final int noOfSemesters;

  Course({
    required this.id,
    required this.courseName,
    required this.noOfSemesters,
  });

  Course copyWith({
    String? id,
    String? courseName,
    int? noOfSemesters,
  }) {
    return Course(
      id: id ?? this.id,
      courseName: courseName ?? this.courseName,
      noOfSemesters: noOfSemesters ?? this.noOfSemesters,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseName': courseName,
      'noOfSemesters': noOfSemesters,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['\$id'] as String,
      courseName: map['courseName'] as String,
      noOfSemesters: map['noOfSemesters'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) =>
      Course.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Course(id: $id, courseName: $courseName, noOfSemesters: $noOfSemesters)';

  @override
  bool operator ==(covariant Course other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.courseName == courseName &&
        other.noOfSemesters == noOfSemesters;
  }

  @override
  int get hashCode =>
      id.hashCode ^ courseName.hashCode ^ noOfSemesters.hashCode;
}
