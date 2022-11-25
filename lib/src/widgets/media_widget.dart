import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/models/media_model.dart';

class MediaWidget extends StatelessWidget {
  /// Required params which will be handled in package
  final MediaModel media;
  final Function() onSelect;

  /// Ui customization props
  final BorderRadius? borderRadius;

  final BoxShape? boxShape;

  final List<BoxShadow>? boxShadow;

  final BoxFit? mediaFit;

  final Border? mediaBorder;

  final Color? mediaBackgroundColor;

  final Color? mediaSkeletonBaseColor;

  final Color? mediaSkeletonShimmerColor;

  final Widget? loadingWidget;

  const MediaWidget({
    Key? key,
    required this.onSelect,
    required this.media,
    this.borderRadius,
    this.boxShadow,
    this.boxShape,
    this.mediaFit,
    this.mediaBorder,
    this.mediaBackgroundColor,
    this.mediaSkeletonBaseColor,
    this.mediaSkeletonShimmerColor,
    this.loadingWidget,
  })  : assert(borderRadius != null && boxShape != BoxShape.circle),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: mediaBackgroundColor,
          borderRadius: borderRadius,
          shape: boxShape ?? BoxShape.rectangle,
          border: mediaBorder,
          boxShadow: boxShadow,
        ),
        child: ValueListenableBuilder<MediaState>(
          valueListenable: media.mediaState,
          builder: (context, mediaState, child) {
            switch (mediaState) {
              case MediaState.success:
                return Image.memory(
                  media.image!,
                  fit: mediaFit ?? BoxFit.cover,
                );
              default:
                return loadingWidget ?? const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
