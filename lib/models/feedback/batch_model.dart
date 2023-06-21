// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Batch {
  final String id;
  final String batch;
  const Batch({
    required this.id,
    required this.batch,
  });

  Batch copyWith({
    String? id,
    String? batch,
  }) {
    return Batch(
      id: id ?? this.id,
      batch: batch ?? this.batch,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'batch': batch,
    };
  }

  factory Batch.fromMap(Map<String, dynamic> map) {
    return Batch(
      id: map['\$id'] as String,
      batch: map['batch'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Batch.fromJson(String source) =>
      Batch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Batch(id: $id, batch: $batch)';

  @override
  bool operator ==(covariant Batch other) {
    if (identical(this, other)) return true;

    return other.id == id && other.batch == batch;
  }

  @override
  int get hashCode => id.hashCode ^ batch.hashCode;
}
