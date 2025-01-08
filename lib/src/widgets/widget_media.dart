import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/models/media_model.dart';

class MediaWidget extends StatefulWidget {
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
  State<MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  final loadingNotifier = ValueNotifier<bool>(true);
  var imageData;

  @override
  void initState() {
    widget.media.assetEntity!.thumbnailData.then((value) {
      imageData = value!;
      loadingNotifier.value = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onSelect,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: widget.mediaBackgroundColor,
          borderRadius: widget.borderRadius,
          shape: widget.boxShape ?? BoxShape.rectangle,
          border: widget.mediaBorder,
          boxShadow: widget.boxShadow,
        ),
        child: ValueListenableBuilder<MediaState>(
          valueListenable: widget.media.mediaState,
          builder: (context, mediaState, child) {
            switch (mediaState) {
              case MediaState.success:
                return ValueListenableBuilder<bool>(
                  valueListenable: loadingNotifier,
                  builder: (context, value, child) {
                    if (value) {
                      return const SizedBox();
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: widget.mediaFit,
                            image: MemoryImage(imageData),
                          ),
                        ),
                      );
                    }
                  },
                );
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
