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
  final String title;
  final MediaCropper? mediaCropper;
  final bool navigateFromCamera;
  final bool navigateFromImagePicker;

  const ImagePreviewPage({
    Key? key,
    required this.imagePath,
    required this.title,
    this.mediaCropper,
    this.navigateFromCamera = false,
    this.navigateFromImagePicker = false,
  }) : super(key: key);

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  String imagePath = "";

  @override
  void initState() {
    super.initState();
    imagePath = widget.imagePath;
    print(imagePath);
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
            child: kIsWeb ? Image.network(imagePath):Image.file(File(imagePath)),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: IconButton(
                padding: const EdgeInsets.all(16),
                onPressed: () {
                  Navigator.pop(context);
                },
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        _cropImage();
                      },
                      child: const Icon(
                        Icons.crop,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {
                          onApproveImage(imagePath);
                        },
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

  void onApproveImage(String path) async {
    final navigator = Navigator.of(context);
    String imagePath = path;
    if (widget.navigateFromImagePicker) {
      Navigator.pop(context, imagePath);
    } else {
      if (widget.mediaCropper?.compressPicture ?? false) {
        imagePath = await compressImage(path) ?? "";
      }
      if (widget.navigateFromCamera) {
        navigator.pop();
      }
      navigator
        ..pop()
        ..pop(imagePath);
    }
  }

  Future<void> _cropImage() async {
    ImageCropper().cropImage(
      sourcePath: imagePath,
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
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 520,
            height: 520,
          ),
          viewPort: const CroppieViewPort(
            width: 480,
            height: 480,
          ),
          enableResize: true,
          mouseWheelZoom: true,
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    ).then((croppedFile) {
      if (croppedFile != null) {
        imagePath = croppedFile.path;
        if (widget.mediaCropper?.saveCroppedImage ?? false) {
          saveImageInGallery(imagePath);
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
