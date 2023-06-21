// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:feedbackadmin/models/feedback/subject_model.dart';

class SubjectDropDownCheckList {
  final String id;
  final SubjectModel subjectModel;

  bool isSelected;

  SubjectDropDownCheckList({
    required this.id,
    required this.subjectModel,
    required this.isSelected,
  });

  SubjectDropDownCheckList copyWith(
      {SubjectModel? subjectModel, bool? isSelected, String? id}) {
    return SubjectDropDownCheckList(
      subjectModel: subjectModel ?? this.subjectModel,
      isSelected: isSelected ?? this.isSelected,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subjectModel': subjectModel.toMap(),
      'isSelected': isSelected,
      'id': id,
    };
  }

  factory SubjectDropDownCheckList.fromMap(Map<String, dynamic> map) {
    return SubjectDropDownCheckList(
      subjectModel:
          SubjectModel.fromMap(map['subjectModel'] as Map<String, dynamic>),
      isSelected: map['isSelected'] as bool,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectDropDownCheckList.fromJson(String source) =>
      SubjectDropDownCheckList.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SubjectDropDownCheckList(id: $id, subjectModel: $subjectModel, isSelected: $isSelected)';

  @override
  bool operator ==(covariant SubjectDropDownCheckList other) {
    if (identical(this, other)) return true;

    return other.subjectModel == subjectModel &&
        other.id == id &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode => subjectModel.hashCode ^ id.hashCode ^ isSelected.hashCode;
}
