import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraWidget extends StatelessWidget {
  final CameraController cameraController;

  const CameraWidget({
    Key? key,
    required this.cameraController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CameraPreview(
          cameraController,
          child: const Icon(
            Icons.camera,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
