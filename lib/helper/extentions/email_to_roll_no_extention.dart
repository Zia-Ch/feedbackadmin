extension EmailToRollNo on String {
  String emailToRollNo() {
    final String email = this;
    final String rollNo = email.split('@')[0];
    return rollNo;
  }
}
