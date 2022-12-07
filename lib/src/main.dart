import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/models/cropper_model.dart';
import 'package:flutter_media_picker/src/models/modal_header_model.dart';
import 'package:flutter_media_picker/src/widgets/media_picker_bottom_sheet.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaPicker {

  static Future<String?> showMediaPickerModal(
      BuildContext context, {
        final Color? backgroundColor,
        final double? mediaWidgetWidth,
        final double? mediaHorizontalSpacing,
        final double? mediaVerticalSpacing,
        final int? imageQualityPercentage,
        final BorderRadius? mediaBorderRadius,
        final BoxShape? mediaBoxShape,
        final List<BoxShadow>? mediaBoxShadow,
        final BoxFit? mediaFit,
        final Border? mediaBorder,
        final Color? mediaBackgroundColor,
        final Color? mediaSkeletonBaseColor,
        final Color? mediaSkeletonShimmerColor,
        final Widget? mediaLoadingWidget,
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
          imageQualityPercentage: imageQualityPercentage,
          mediaBackgroundColor: mediaBackgroundColor,
          mediaBorderRadius: mediaBorderRadius,
          mediaBoxShadow: mediaBoxShadow,
          mediaBoxShape: mediaBoxShape,
          headerWidget: headerWidget,
        ),
      );
    } else {}

    return null;
  }
}
