import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonWidget extends StatelessWidget {
  final double height;
  final double width;
  final BoxShape shape;
  final Color? shimmerColor;
  final Color? shimmerBaseColor;

  const SkeletonWidget.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.shimmerColor,
    this.shimmerBaseColor,
  }) : shape = BoxShape.rectangle;

  const SkeletonWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.shimmerColor,
    this.shimmerBaseColor,
  }) : shape = BoxShape.circle;

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      shimmerColor: shimmerColor ?? Colors.grey[200]!,
      shimmerDuration: 1200,
      borderRadius: shape == BoxShape.circle
          ? const BorderRadius.all(Radius.circular(1000))
          : const BorderRadius.all(Radius.circular(10)),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: shape == BoxShape.circle
              ? null
              : const BorderRadius.all(Radius.circular(10)),
          color: shimmerBaseColor ?? const Color(0xFFE9E9E9),
        ),
      ),
    );
  }
}
