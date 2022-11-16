import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  double bottomPadding() => MediaQuery.of(this).padding.bottom;

  Size getScreenSize() => MediaQuery.of(this).size;
}

extension GlobalKeyExtensions on GlobalKey {
  Size getWidgetSize() {
    return currentContext?.size ?? const Size(0, 0);
  }
}
