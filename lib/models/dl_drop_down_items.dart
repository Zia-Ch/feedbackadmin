// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DLDropDownItems {
  final String id;
  final String name;

  DLDropDownItems({
    required this.id,
    required this.name,
  });

  DLDropDownItems copyWith({
    String? id,
    String? name,
  }) {
    return DLDropDownItems(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory DLDropDownItems.fromMap(Map<String, dynamic> map) {
    return DLDropDownItems(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DLDropDownItems.fromJson(String source) =>
      DLDropDownItems.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DLDropDownItems(id: $id, name: $name)';

  @override
  bool operator ==(covariant DLDropDownItems other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
