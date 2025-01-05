import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:flutter_media_picker/src/utils/helpers.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewPage extends StatefulWidget {
  final String imagePath;
  final String imageExtension;
  final String title;
  final Uint8List? bytes;
  final MediaCropper? mediaCropper;
  final bool navigateFromCamera;
  final bool navigateFromImagePicker;
  final bool isActiveCrop;

  const ImagePreviewPage({
    super.key,
    required this.imagePath,
    required this.title,
    this.mediaCropper,
    this.bytes,
    this.navigateFromCamera = false,
    this.navigateFromImagePicker = false,
    required this.imageExtension,
    required this.isActiveCrop,
  });

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  PickedMedia pickedMedia = PickedMedia();

  @override
  void initState() {
    super.initState();
    pickedMedia = PickedMedia(
      bytes: widget.bytes,
      path: widget.imagePath,
      extension: widget.imageExtension,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoView.customChild(
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained.multiplier,
            child: kIsWeb
                ? Image.network(pickedMedia.path ?? "")
                : Image.file(File(pickedMedia.path ?? "")),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: IconButton(
                padding: const EdgeInsets.all(16),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.isActiveCrop
                        ? InkWell(
                            onTap: () => _cropImage(),
                            child: const Icon(
                              Icons.crop,
                              size: 30,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox(),
                    const Spacer(),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () => onApproveImage(),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onApproveImage() async {
    final navigator = Navigator.of(context);
    if (widget.navigateFromImagePicker) {
      Navigator.pop(context, pickedMedia);
    } else {
      if (widget.mediaCropper?.compressPicture ?? false) {
        pickedMedia.path = await compressImage(pickedMedia.path ?? "") ?? "";
        pickedMedia.extension = "jpg";
      }
      pickedMedia.bytes = await File(pickedMedia.path!).readAsBytes();
      if (widget.navigateFromCamera) {
        navigator.pop();
      }
      navigator
        ..pop()
        ..pop(pickedMedia);
    }
  }

  Future<void> _cropImage() async {
    ImageCropper().cropImage(
      sourcePath: pickedMedia.path ?? "",
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: widget.mediaCropper?.title,
          toolbarColor: widget.mediaCropper?.toolBarColor ?? Colors.black,
          toolbarWidgetColor:
              widget.mediaCropper?.toolbarWidgetColor ?? Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          activeControlsWidgetColor:
              widget.mediaCropper?.activeControlsWidgetColor ?? Colors.blue,
          lockAspectRatio: false,
          cropFrameColor: widget.mediaCropper?.cropFrameColor ?? Colors.blue,
          backgroundColor: widget.mediaCropper?.backgroundColor ?? Colors.blue,
          cropFrameStrokeWidth: widget.mediaCropper?.cropFrameStrokeWidth ?? 2,
        ),
        IOSUiSettings(
          title: widget.mediaCropper?.title,
        ),
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: CropperSize(
            width: (MediaQuery.of(context).size.width * .7).toInt(),
            height: (MediaQuery.of(context).size.height * .6).toInt(),
          ),
          // boundary: CroppieBoundary(
          //   width: (MediaQuery.of(context).size.width * .7).toInt(),
          //   height: (MediaQuery.of(context).size.height * .6).toInt(),
          // ),
          // viewPort: CroppieViewPort(
          //   width: (MediaQuery.of(context).size.width * .6).toInt(),
          //   height: (MediaQuery.of(context).size.height * .5).toInt(),
          // ),
          cropBoxResizable: true,
          zoomOnWheel: true,
          zoomable: true,
        ),
      ],
    ).then((croppedFile) async {
      if (croppedFile != null) {
        pickedMedia.path = croppedFile.path;
        pickedMedia.bytes = await croppedFile.readAsBytes();
        if (widget.mediaCropper?.saveCroppedImage ?? false) {
          saveImageInGallery(pickedMedia.path ?? "");
        }
        setState(() {});
      }
    });
  }

  Future<String?> compressImage(String imagePath) async {
    int quality = widget.mediaCropper?.compressPercentage
            ?.call(File(imagePath).lengthSync() / (1024 * 1024)) ??
        80;

    final result = await FlutterImageCompress.compressAndGetFile(
      imagePath,
      imagePath.replaceAll(".jpg", "Compressed.jpg"),
      quality: quality,
      rotate: 0,
    );

    return result?.path;
  }
}
