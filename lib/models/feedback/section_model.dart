// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Section {
  final String id;
  final String sectionName;

  Section({
    required this.id,
    required this.sectionName,
  });

  Section copyWith({
    String? id,
    String? sectionName,
  }) {
    return Section(
      id: id ?? this.id,
      sectionName: sectionName ?? this.sectionName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sectionName': sectionName,
    };
  }

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      id: map['\$id'] as String,
      sectionName: map['sectionName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Section.fromJson(String source) =>
      Section.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Section(id: $id, sectionName: $sectionName)';

  @override
  bool operator ==(covariant Section other) {
    if (identical(this, other)) return true;

    return other.id == id && other.sectionName == sectionName;
  }

  @override
  int get hashCode => id.hashCode ^ sectionName.hashCode;
}
