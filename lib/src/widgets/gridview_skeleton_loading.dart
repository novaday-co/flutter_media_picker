import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/utils/context_extension.dart';
import 'package:flutter_media_picker/src/widgets/widget_skeleton.dart';

class GridViewSkeletonLoading extends StatelessWidget {
  final Color? skeletonBaseColor;

  final Color? skeletonShimmerColor;

  const GridViewSkeletonLoading({
    super.key,
    this.skeletonShimmerColor,
    this.skeletonBaseColor,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
      shrinkWrap: true,
      itemBuilder: (context, index) => SkeletonWidget.rectangular(
        width: context.getScreenSize.width,
        height: context.getScreenSize.width,
        shimmerColor: skeletonShimmerColor,
        shimmerBaseColor: skeletonBaseColor,
      ),
      itemCount: 12,
    );
  }
}
