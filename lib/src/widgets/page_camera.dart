import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final Future Function(XFile) onNavigate;
  CameraController? cameraController;

  CameraPage({
    Key? key,
    required this.onNavigate,
    this.cameras,
    this.cameraController,
  }) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraDescription? frontCamera;
  CameraDescription? backCamera;
  FlashMode flashMode = FlashMode.auto;
  CameraLensDirection cameraLensDirection = CameraLensDirection.back;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: widget.cameraController != null
          ? Stack(
              children: [
                Center(
                  child: CameraPreview(
                    widget.cameraController!,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: IconButton(
                              onPressed: changeFlashMode,
                              splashRadius: 25,
                              icon: Center(
                                child: Icon(
                                  flashIcon,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: () async {
                                HapticFeedback.heavyImpact();
                                final imageFile =
                                    await widget.cameraController?.takePicture();
                                if (imageFile != null) {
                                  await widget.onNavigate(imageFile);
                                }
                                widget.cameraController?.resumePreview();
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.camera,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: hasSecondCamera
                                ? IconButton(
                                    onPressed: () => flipCamera(),
                                    splashRadius: 25,
                                    icon: const Center(
                                      child: Icon(
                                        Icons.flip_camera_android_outlined,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }


  @override
  void initState() {
    super.initState();
    initialCamerasDescription();
  }

  void initialCamerasDescription() {
    if (widget.cameras != null && widget.cameras!.isNotEmpty) {
      frontCamera = widget.cameras!.firstWhere(
            (element) => element.lensDirection == CameraLensDirection.front,
      );
      backCamera = widget.cameras!.firstWhere(
            (element) => element.lensDirection == CameraLensDirection.back,
      );

      initialCameraController(backCamera ?? frontCamera);
    }
  }

  void initialCameraController(CameraDescription? cameraDescription) async {
    widget.cameraController =
        CameraController(cameraDescription!, ResolutionPreset.max);
    cameraLensDirection = cameraDescription.lensDirection;
    await widget.cameraController!.initialize();
    setState(() {});
  }

  void flipCamera() async {
    if (cameraLensDirection == CameraLensDirection.back &&
        frontCamera != null) {
      initialCameraController(frontCamera);
    } else if (cameraLensDirection == CameraLensDirection.front &&
        backCamera != null) {
      initialCameraController(backCamera);
    }
  }

  bool get hasSecondCamera {
    if (frontCamera != null && backCamera != null) {
      return true;
    }
    return false;
  }

  void changeFlashMode() {
    switch (flashMode) {
      case FlashMode.auto:
        flashMode = FlashMode.always;
        widget.cameraController!.setFlashMode(flashMode);
        break;
      case FlashMode.always:
        flashMode = FlashMode.off;
        widget.cameraController!.setFlashMode(flashMode);
        break;
      default:
        flashMode = FlashMode.auto;
        widget.cameraController!.setFlashMode(flashMode);
        break;
    }
    setState(() {});
  }

  IconData get flashIcon {
    switch (flashMode) {
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on_outlined;
      default:
        return Icons.flash_off_sharp;
    }
  }
}
