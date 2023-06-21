import 'package:flutter/widgets.dart';

extension WidgetPadding on Widget {
  addPadding(double val) => Padding(
        padding: EdgeInsets.all(val),
        child: this,
      );
}
