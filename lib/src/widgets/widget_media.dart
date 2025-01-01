import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/models/media_model.dart';
import 'dart:typed_data' as type;

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

  const MediaWidget({
    super.key,
    required this.onSelect,
    required this.media,
    this.borderRadius,
    this.boxShadow,
    this.boxShape,
    this.mediaFit,
    this.mediaBorder,
    this.mediaBackgroundColor,
  }) : assert(borderRadius != null && boxShape != BoxShape.circle);

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
                return FutureBuilder<type.Uint8List?>(
                  future: media.assetEntity!.thumbnailData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: mediaFit,
                            image: MemoryImage(snapshot.data!),
                          ),
                        ),
                      );
                    }
                  },
                );
              // return AssetEntityImage(
              //   media.assetEntity!,
              //   isOriginal: false,
              //   fit: BoxFit.cover,
              //   thumbnailSize: const ThumbnailSize.square(200),
              //   thumbnailFormat: ThumbnailFormat.jpeg,
              // );
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
