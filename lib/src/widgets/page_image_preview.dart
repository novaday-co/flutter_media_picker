import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:flutter_media_picker/src/widgets/page_cropper.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewPage extends StatelessWidget {
  final String imagePath;
  final Function() onCropTap;
  final Function() onConfirmTap;

  const ImagePreviewPage({
    Key? key,
    required this.imagePath,
    required this.onCropTap,
    required this.onConfirmTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'cameraHero',
      child: Material(
        child: Stack(
          children: [
            PhotoView(
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained.multiplier,
              imageProvider: FileImage(
                File(
                  imagePath,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: onCropTap,
                      child: const Icon(
                        Icons.crop,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 50),
                    InkWell(
                      onTap: onConfirmTap,
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
