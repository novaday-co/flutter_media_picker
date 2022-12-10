import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_media_picker/src/models/cropper_model.dart';
import 'package:image_cropper/image_cropper.dart';

class CropperPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final int? imageQualityPercentage;

  final MediaCropper? mediaCropper;

  const CropperPage({
    Key? key,
    required this.title,
    required this.imagePath,
    this.mediaCropper,
    this.imageQualityPercentage,
  }) : super(key: key);

  @override
  CropperPageState createState() => CropperPageState();
}

class CropperPageState extends State<CropperPage> {
  @override
  void initState() {
    super.initState();
    _cropImage();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<int> comparePictureSize(String path) async {
    File imageFile = File(path);
    double imageSizeMB = imageFile.lengthSync() / (1024 * 1024);
    int quality = 100;
    if (imageSizeMB > 10) {
      quality = 50;
    } else if (imageSizeMB > 5) {
      switch ((imageSizeMB % 5).round()) {
        case 0:
          quality = 100;
          break;
        case 1:
          quality = 90;
          break;
        case 2:
          quality = 80;
          break;
        case 3:
          quality = 70;
          break;
        case 4:
          quality = 60;
          break;
      }
    }
    return quality;
  }

  Future<void> _cropImage() async {
    ImageCropper().cropImage(
      sourcePath: widget.imagePath,
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
            type: 'circle',
          ),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    ).then((croppedFile) {
      if (croppedFile != null) {
        compressImage(croppedFile.path).then(
          (compressedImagePath) {
            final navigator = Navigator.of(context);
            navigator
              ..pop()
              ..pop()
              ..pop(compressedImagePath);
          },
        );
      } else {
        Navigator.pop(context);
      }
    });
  }

  Future<String?> compressImage(String imagePath) async {
    int quality = await comparePictureSize(imagePath);

    final result = await FlutterImageCompress.compressAndGetFile(
      imagePath,
      imagePath.replaceAll(".jpg", "Compressed.jpg"),
      quality: widget.imageQualityPercentage ?? quality,
      rotate: 0,
    );

    return result?.path;
  }
}
