// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:feedbackadmin/models/dl_drop_down_items.dart';

class DLFormData {
  String? hintText;
  String? labelText;
  String? inputTextValue;
  DLDropDownItems? dropDownValue;

  bool? booleanInputValue;
  double? doubleInputValue;
  String? errorText;

  DLFormData({
    this.hintText,
    this.labelText,
    this.inputTextValue,
    this.dropDownValue,
    this.errorText,
    this.booleanInputValue,
    this.doubleInputValue,
  });

  DLFormData copyWith({
    String? hintText,
    String? labelText,
    String? inputTextValue,
    DLDropDownItems? dropDownValue,
    String? errorText,
    bool? booleanInputValue,
    double? doubleInputValue,
  }) {
    return DLFormData(
      hintText: hintText ?? this.hintText,
      labelText: labelText ?? this.labelText,
      inputTextValue: inputTextValue ?? this.inputTextValue,
      dropDownValue: dropDownValue ?? this.dropDownValue,
      errorText: errorText ?? this.errorText,
      booleanInputValue: booleanInputValue ?? this.booleanInputValue,
      doubleInputValue: doubleInputValue ?? this.doubleInputValue,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hintText': hintText,
      'labelText': labelText,
      'inputTextValue': inputTextValue,
      'dropDownValue': dropDownValue?.toMap(),
      'errorText': errorText,
      'booleanInputValue': booleanInputValue,
      'doubleInputValue': doubleInputValue,
    };
  }

  factory DLFormData.fromMap(Map<String, dynamic> map) {
    return DLFormData(
      hintText: map['hintText'] != null ? map['hintText'] as String : null,
      labelText: map['labelText'] != null ? map['labelText'] as String : null,
      inputTextValue: map['inputTextValue'] != null
          ? map['inputTextValue'] as String
          : null,
      dropDownValue: map['dropDownValue'] != null
          ? DLDropDownItems.fromMap(
              map['dropDownValue'] as Map<String, dynamic>)
          : null,
      errorText: map['errorText'] != null ? map['errorText'] as String : null,
      booleanInputValue: map['booleanInputValue'] != null
          ? map['booleanInputValue'] as bool
          : null,
      doubleInputValue: map['doubleInputValue'] != null
          ? map['doubleInputValue'] as double
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DLFormData.fromJson(String source) =>
      DLFormData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DLFormData(hintText: $hintText, labelText: $labelText, inputTextValue: $inputTextValue, dropDownValue: $dropDownValue, errorText: $errorText, boolenaInputValue: $booleanInputValue, doubleInputValue: $doubleInputValue)';
  }

  @override
  bool operator ==(covariant DLFormData other) {
    if (identical(this, other)) return true;

    return other.hintText == hintText &&
        other.labelText == labelText &&
        other.inputTextValue == inputTextValue &&
        other.dropDownValue == dropDownValue &&
        other.errorText == errorText &&
        other.booleanInputValue == booleanInputValue &&
        other.doubleInputValue == doubleInputValue;
  }

  @override
  int get hashCode {
    return hintText.hashCode ^
        labelText.hashCode ^
        inputTextValue.hashCode ^
        dropDownValue.hashCode ^
        errorText.hashCode ^
        booleanInputValue.hashCode ^
        doubleInputValue.hashCode;
  }
}
