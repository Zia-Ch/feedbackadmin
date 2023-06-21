// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String sectionId;
  final String courseId;
  final String batchId;
  final List<String> subjects;
  final bool isDeleted;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.name,
    required this.batchId,
    required this.email,
    required this.sectionId,
    required this.subjects,
    required this.courseId,
    required this.isDeleted,
    required this.isAdmin,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? sectionId,
    String? courseId,
    String? batchId,
    bool? isDeleted,
    bool? isAdmin,
    List<String>? subjects,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      sectionId: sectionId ?? this.sectionId,
      courseId: courseId ?? this.courseId,
      batchId: batchId ?? this.batchId,
      isDeleted: isDeleted ?? this.isDeleted,
      isAdmin: isAdmin ?? this.isAdmin,
      subjects: subjects ?? this.subjects,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'sectionId': sectionId,
      'courseId': courseId,
      'batchId': batchId,
      'isDeleted': isDeleted,
      'isAdmin': isAdmin,
      'subjects': subjects,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['\$id'] as String,
      name: map['name'] != null ? map['name'] as String : 'null',
      email: map['email'] as String,
      sectionId: map['sectionId'] as String,
      courseId: map['courseId'] as String,
      batchId: map['batchId'] as String,
      isDeleted: map['isDeleted'] as bool,
      isAdmin: map['isAdmin'] as bool,
      subjects: List<String>.from(map['subjects']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, sectionId: $sectionId, courseId: $courseId, batchId: $batchId, isDeleted: $isDeleted, isAdmin: $isAdmin, subjects: ${subjects.asMap()})';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.name == name &&
        other.sectionId == sectionId &&
        other.courseId == courseId &&
        other.batchId == batchId &&
        other.isDeleted == isDeleted &&
        other.subjects == subjects &&
        other.isAdmin == isAdmin;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        sectionId.hashCode ^
        courseId.hashCode ^
        batchId.hashCode ^
        isDeleted.hashCode ^
        subjects.hashCode ^
        isAdmin.hashCode;
  }
}
