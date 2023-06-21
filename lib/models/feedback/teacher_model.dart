// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Teacher {
  final String id;
  final String name;
  final String email;
  final bool isPermanant;
  final List<String> subjects;
  final bool isTeaching;
  final double rating;
  final bool isDeleted;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.isPermanant,
    required this.subjects,
    required this.isTeaching,
    required this.rating,
    required this.isDeleted,
  });

  Teacher copyWith({
    String? id,
    String? name,
    String? email,
    bool? isPermanant,
    List<String>? subjects,
    bool? isTeaching,
    double? rating,
    bool? isDeleted,
  }) {
    return Teacher(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isPermanant: isPermanant ?? this.isPermanant,
      subjects: subjects ?? this.subjects,
      isTeaching: isTeaching ?? this.isTeaching,
      rating: rating ?? this.rating,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'isPermanant': isPermanant,
      'subjects': subjects,
      'isTeaching': isTeaching,
      'rating': rating,
      'isDeleted': isDeleted,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['\$id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      isPermanant: map['isPermanant'] as bool,
      subjects: List<String>.from(map['subjects']),
      isTeaching: map['isTeaching'] as bool,
      rating: (map['rating'].runtimeType == int
          ? (map['rating'] as int) + .0
          : map['rating'] as double), //as double,
      isDeleted: map['isDeleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Teacher.fromJson(String source) =>
      Teacher.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Teacher(id: $id, name: $name, email: $email, isPermanant: $isPermanant, subjects: $subjects, isTeaching: $isTeaching, rating: $rating, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(covariant Teacher other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.isPermanant == isPermanant &&
        listEquals(other.subjects, subjects) &&
        other.isTeaching == isTeaching &&
        other.rating == rating &&
        other.isDeleted == isDeleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        isPermanant.hashCode ^
        subjects.hashCode ^
        isTeaching.hashCode ^
        rating.hashCode ^
        isDeleted.hashCode;
  }
}
