import 'package:flutter/material.dart';

class HeaderWidget {
  final TextStyle? dropDownButtonTextStyle;

  final TextStyle? dropDownItemsTextStyle;

  final Color? dropDownSelectedItemBackgroundColor;

  final Color? dropDownBackgroundColor;

  final Color? dropDownButtonBackgroundColor;

  final Color? iconsBorderColor;

  final Color? iconsColor;

  final Widget Function(List<String> pathList,Function(int) onSelectPath)? headerBuilder;

  const HeaderWidget({
    this.iconsBorderColor,
    this.dropDownItemsTextStyle,
    this.dropDownSelectedItemBackgroundColor,
    this.dropDownButtonBackgroundColor,
    this.dropDownButtonTextStyle,
    this.dropDownBackgroundColor,
    this.iconsColor,
    this.headerBuilder,
  });
}
