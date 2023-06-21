extension ConvertBoolToYesNO on bool {
  String boolToYesNO() {
    switch (this) {
      case true:
        return 'Yes';
      case false:
        return 'No';
      default:
        return 'Yes';
    }
  }
}

extension ConvertYesNoToBool on String {
  bool yesNoTobool() {
    switch (this) {
      case 'Yes':
        return true;
      case 'No':
        return false;
      default:
        return true;
    }
  }
}
