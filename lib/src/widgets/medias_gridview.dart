import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/models/media_model.dart';
import 'package:flutter_media_picker/src/widgets/media_widget.dart';


class MediasGridView extends StatelessWidget {
  final List<MediaModel> medias;

  final Function(int) onSelectMedia;

  final ScrollController scrollController;

  final double? mediaWidgetWidth;
  final double? mediaHorizontalSpacing;
  final double? mediaVerticalSpacing;

  final BorderRadius? borderRadius;

  final BoxShape? boxShape;

  final List<BoxShadow>? boxShadow;

  final BoxFit? mediaFit;

  final Border? mediaBorder;

  final Color? mediaBackgroundColor;

  final Color? mediaSkeletonBaseColor;

  final Color? mediaSkeletonShimmerColor;

  final Widget? loadingWidget;

  const MediasGridView({
    Key? key,
    required this.medias,
    required this.onSelectMedia,
    required this.scrollController,
    this.mediaWidgetWidth,
    this.mediaHorizontalSpacing,
    this.mediaVerticalSpacing,
    this.borderRadius,
    this.boxShape,
    this.boxShadow,
    this.mediaFit,
    this.mediaBorder,
    this.mediaBackgroundColor,
    this.mediaSkeletonBaseColor,
    this.mediaSkeletonShimmerColor,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: mediaWidgetWidth ?? 140,
        mainAxisSpacing: mediaHorizontalSpacing ?? 8,
        crossAxisSpacing: mediaVerticalSpacing ?? 8,
        childAspectRatio: 1,
      ),
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      controller: scrollController,
      shrinkWrap: true,
      itemBuilder: (context, index) => MediaWidget(
        onSelect: () => onSelectMedia(index),
        media: medias[index],
        borderRadius: BorderRadius.circular(10),
        boxShape: BoxShape.rectangle,
        mediaSkeletonShimmerColor: mediaSkeletonShimmerColor,
        mediaSkeletonBaseColor: mediaSkeletonBaseColor,
        mediaFit: mediaFit,
        mediaBorder: mediaBorder,
        mediaBackgroundColor: mediaBackgroundColor,
        loadingWidget: loadingWidget,
        boxShadow: boxShadow,
      ),
      itemCount: medias.length,
    );
  }
}
