import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatelessWidget {
  final CameraController cameraController;
  final VoidCallback onCapture;
  const CameraPage({Key? key, required this.cameraController, required this.onCapture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "cameraHero",
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            CameraPreview(
              cameraController,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )
                ),
                child: Center(
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: onCapture,
                            child: const Center(
                              child: Icon(
                                Icons.camera,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

