import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:flutter_media_picker/src/widgets/media_picker_bottom_sheet/media_picker_bottom_sheet.dart';
import 'package:flutter_media_picker/src/widgets/page_image_preview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

Future<String?> showMediaPickerBottomSheet(
    BuildContext context, {
      final Color? backgroundColor,
      final double? mediaWidgetWidth,
      final double? mediaHorizontalSpacing,
      final double? mediaVerticalSpacing,
      final BorderRadius? mediaBorderRadius,
      final BoxShape? mediaBoxShape,
      final List<BoxShadow>? mediaBoxShadow,
      final BoxFit? mediaFit,
      final Border? mediaBorder,
      final Color? mediaBackgroundColor,
      final Color? mediaSkeletonShimmerColor,
      final Color? mediaSkeletonBaseColor,
      final HeaderWidget? headerWidget,
      final MediaCropper? mediaCropper,
      final bool? safeArea,
    }) async {
  final PermissionState ps = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
          iosAccessLevel: IosAccessLevel.addOnly));
  if (ps.hasAccess) {
    return await showFlexibleBottomSheet(
      context: context,
      minHeight: 0,
      initHeight: 0.45,
      maxHeight: 1,
      useRootNavigator: true,
      isSafeArea: safeArea ?? false,
      bottomSheetColor: Colors.transparent,
      builder: (context, scrollController, offset) => MediaPickerBottomSheet(
        scrollController: scrollController,
        mediaCropper: mediaCropper,
        backgroundColor: backgroundColor,
        mediaWidgetWidth: mediaWidgetWidth,
        mediaVerticalSpacing: mediaVerticalSpacing,
        mediaHorizontalSpacing: mediaHorizontalSpacing,
        mediaFit: mediaFit,
        mediaBorder: mediaBorder,
        mediaBackgroundColor: mediaBackgroundColor,
        mediaBorderRadius: mediaBorderRadius,
        mediaBoxShadow: mediaBoxShadow,
        mediaBoxShape: mediaBoxShape,
        headerWidget: headerWidget,
        mediaSkeletonShimmerColor: mediaSkeletonShimmerColor,
        mediaSkeletonBaseColor: mediaSkeletonBaseColor,
      ),
    );
  } else {
    final ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.gallery).then(
          (image) {
        if (image != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImagePreviewPage(
                imagePath: image.path,
                title: "",
                mediaCropper: mediaCropper,
              ),
            ),
          );
        }
      },
    );
  }

  return null;
}