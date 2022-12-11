import 'package:flutter/material.dart';

class MediaCropper {
  final String? title;
  final Color? toolBarColor;
  final Color? toolbarWidgetColor;
  final Color? backgroundColor;
  final Color? cropFrameColor;
  final Color? activeControlsWidgetColor;
  final int? cropFrameStrokeWidth;
  final bool compressPicture;
  final bool saveCroppedImage;
  final int Function(double imageSizeMB)? compressPercentage;

  const MediaCropper({
    this.toolBarColor,
    this.toolbarWidgetColor,
    this.title,
    this.backgroundColor,
    this.cropFrameColor,
    this.activeControlsWidgetColor,
    this.cropFrameStrokeWidth,
    this.compressPicture = false,
    this.compressPercentage,
    this.saveCroppedImage = false,
  });
}
