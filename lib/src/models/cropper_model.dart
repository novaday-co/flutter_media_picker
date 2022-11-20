import 'package:flutter/material.dart';

class MediaCropper {
  String? title;
  Color? toolBarColor;
  Color? toolbarWidgetColor;
  Color? backgroundColor;
  Color? cropFrameColor;
  Color? activeControlsWidgetColor;
  int? cropFrameStrokeWidth;

  MediaCropper({
    this.toolBarColor,
    this.toolbarWidgetColor,
    this.title,
    this.backgroundColor,
    this.cropFrameColor,
    this.activeControlsWidgetColor,
    this.cropFrameStrokeWidth,
  });
}
