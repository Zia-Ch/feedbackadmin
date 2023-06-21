import 'package:flutter/material.dart';

extension MediaQuerySize on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
  Size get screenSize => MediaQuery.of(this).size;
}
