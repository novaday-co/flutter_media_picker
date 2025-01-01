import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/models/media_model.dart';
import 'package:flutter_media_picker/src/widgets/widget_camera.dart';
import 'package:flutter_media_picker/src/widgets/widget_media.dart';

class MediasGridView extends StatelessWidget {
  final CameraController? cameraController;
  final List<MediaModel> medias;
  final Function(int) onSelectMedia;
  final VoidCallback onOpenCamera;
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

  const MediasGridView({
    super.key,
    required this.cameraController,
    required this.medias,
    required this.onSelectMedia,
    required this.onOpenCamera,
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
  });

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
      itemBuilder: (context, index) {
        if (index == 0 && cameraController != null) {
          return Hero(
            tag: "cameraHero",
            child: GestureDetector(
              onTap: onOpenCamera,
              child: CameraWidget(cameraController: cameraController!),
            ),
          );
        }
        return MediaWidget(
          onSelect: () => onSelectMedia(index - _cameraIndexDifference),
          media: medias[index - _cameraIndexDifference],
          borderRadius: BorderRadius.circular(10),
          boxShape: BoxShape.rectangle,
          mediaFit: mediaFit,
          mediaBorder: mediaBorder,
          mediaBackgroundColor: mediaBackgroundColor,
          boxShadow: boxShadow,
        );
      },
      itemCount: medias.length + _cameraIndexDifference,
    );
  }

  int get _cameraIndexDifference{
    if(cameraController != null){
      return 1;
    }
    return 0;
  }
}
