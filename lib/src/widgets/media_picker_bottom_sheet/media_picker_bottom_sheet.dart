import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/models/cropper_model.dart';
import 'package:flutter_media_picker/src/models/media_model.dart';
import 'package:flutter_media_picker/src/models/modal_header_model.dart';
import 'package:flutter_media_picker/src/utils/context_extension.dart';
import 'package:flutter_media_picker/src/utils/helpers.dart';
import 'package:flutter_media_picker/src/widgets/gridview_skeleton_loading.dart';
import 'package:flutter_media_picker/src/widgets/media_picker_bottom_sheet/widget_bottom_sheet_header.dart';
import 'package:flutter_media_picker/src/widgets/page_camera.dart';
import 'package:flutter_media_picker/src/widgets/page_image_preview.dart';
import 'package:flutter_media_picker/src/widgets/widget_medias_gridview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaPickerBottomSheet extends StatefulWidget {
  final ScrollController scrollController;

  final double? mediaWidgetWidth;

  final double? mediaHorizontalSpacing;

  final double? mediaVerticalSpacing;

  final BorderRadius? mediaBorderRadius;

  final BoxShape? mediaBoxShape;

  final List<BoxShadow>? mediaBoxShadow;

  final BoxFit? mediaFit;

  final Border? mediaBorder;

  final Color? mediaBackgroundColor;

  final HeaderWidget? headerWidget;

  final Color? backgroundColor;

  final Color? mediaSkeletonBaseColor;

  final Color? mediaSkeletonShimmerColor;

  final MediaCropper? mediaCropper;

  const MediaPickerBottomSheet({
    Key? key,
    required this.scrollController,
    this.mediaWidgetWidth,
    this.mediaHorizontalSpacing,
    this.mediaVerticalSpacing,
    this.mediaBorderRadius,
    this.mediaBoxShape,
    this.mediaBoxShadow,
    this.mediaFit,
    this.mediaBorder,
    this.mediaBackgroundColor,
    this.mediaCropper,
    this.backgroundColor,
    this.headerWidget,
    this.mediaSkeletonBaseColor,
    this.mediaSkeletonShimmerColor,
  }) : super(key: key);

  @override
  _MediaPickerBottomSheetState createState() => _MediaPickerBottomSheetState();
}

class _MediaPickerBottomSheetState extends State<MediaPickerBottomSheet> {
  GlobalKey modalKey = GlobalKey();
  ValueNotifier<MediaState> mediaState = ValueNotifier(MediaState.success);
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  List<AssetPathEntity> paths = [];
  List<MediaModel> medias = [];
  int selectedPathIndex = 0;
  int currentPathIndex = 0;
  int assetPageIndex = 0;
  int pageSize = 20;

  @override
  void initState() {
    fetchAssetsPath();
    initialCamera();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? Colors.white,
      margin: EdgeInsets.only(top: AppBar().preferredSize.height),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Column(
            key: modalKey,
            children: [
              ModalHeader(
                paths: [
                  "all media",
                  ...paths.map((e) => e.name).toList(),
                ],
                selectedDropDownItemIndex: selectedPathIndex,
                onChangePath: _onChangeAssetPath,
                crossFadeState: _crossFadeState,
                onOpenGallery: _onOpenGallery,
                headerWidget: widget.headerWidget,
              ),
              Expanded(
                child: NotificationListener(
                  onNotification: scrollListener,
                  child: ValueListenableBuilder<MediaState>(
                    valueListenable: mediaState,
                    builder: (context, state, child) {
                      switch (state) {
                        case MediaState.loading:
                          return GridViewSkeletonLoading(
                            skeletonBaseColor: widget.mediaSkeletonBaseColor,
                            skeletonShimmerColor:
                                widget.mediaSkeletonShimmerColor,
                          );
                        default:
                          return MediasGridView(
                            cameraController: cameraController,
                            medias: medias,
                            onSelectMedia: _onSelectMedia,
                            onOpenCamera: _onOpenCamera,
                            scrollController: widget.scrollController,
                            mediaBackgroundColor: widget.mediaBackgroundColor,
                            mediaBorder: widget.mediaBorder,
                            mediaFit: widget.mediaFit,
                            boxShape: widget.mediaBoxShape,
                            borderRadius: widget.mediaBorderRadius,
                            boxShadow: widget.mediaBoxShadow,
                            mediaHorizontalSpacing:
                                widget.mediaHorizontalSpacing,
                            mediaVerticalSpacing: widget.mediaVerticalSpacing,
                            mediaWidgetWidth: widget.mediaWidgetWidth,
                          );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  CrossFadeState get _crossFadeState {
    if (modalKey.currentContext != null) {
      final obj = modalKey.currentContext?.findRenderObject() as RenderBox;
      if (obj.size.height >= context.getScreenSize.height * 0.85) {
        return CrossFadeState.showSecond;
      }
      return CrossFadeState.showFirst;
    }
    return CrossFadeState.showFirst;
  }

  void _onOpenGallery() async {
    final ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.gallery).then(
      (image) {
        if (image != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImagePreviewPage(
                imagePath: image.path,
                imageExtension: image.path.split('.').last,
                title: "",
                mediaCropper: widget.mediaCropper,
              ),
            ),
          );
        }
      },
    );
  }

  void _onOpenCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPage(
          cameras: cameras,
          cameraController: cameraController,
          onNavigate: (imageFile) async {
            saveImageInGallery(imageFile.path);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImagePreviewPage(
                  imagePath: imageFile.path,
                  imageExtension: imageFile.path.split('.').last,
                  title: "",
                  navigateFromCamera: true,
                  mediaCropper: widget.mediaCropper,
                ),
              ),
            );
          },
        ),
      ),
    ).then((value) async {
      cameraController = CameraController(cameras!.first, ResolutionPreset.max);
      await cameraController!.initialize();
      setState(() {});
    });
  }

  void _onSelectMedia(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePreviewPage(
          imagePath: medias[index].path!,
          imageExtension: medias[index].path?.split('.').last ?? 'jpg',
          title: "",
          mediaCropper: widget.mediaCropper,
        ),
      ),
    );
  }

  void _onChangeAssetPath(int assetsIndex) {
    if (selectedPathIndex == assetsIndex) return;
    setState(() {});
    medias.clear();
    mediaState.value = MediaState.success;
    selectedPathIndex = assetsIndex;
    currentPathIndex = assetsIndex == 0 ? assetsIndex : assetsIndex - 1;
    assetPageIndex = 0;
    fetchAssetsMedias();
  }

  Future<void> initialCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      cameraController = CameraController(cameras!.first, ResolutionPreset.max);
      await cameraController!.initialize();
    } else {
      if (kDebugMode) {
        print("no  camera found");
      }
    }
    setState(() {});
  }

  Future<void> fetchAssetsPath() async {
    mediaState.value = MediaState.loading;
    paths = await PhotoManager.getAssetPathList(type: RequestType.image);
    fetchAssetsMedias();
  }

  Future<void> fetchAssetsMedias({bool loadMore = false}) async {
    if (mediaState.value == MediaState.empty) return;

    if (selectedPathIndex == 0) {
      int fetchedMediasLength = 0;
      do {
        List<MediaModel> fetchedMedias = await fetchMediasFromStorage(loadMore);
        fetchedMediasLength += fetchedMedias.length;
        if (mediaState.value != MediaState.failed) {
          configureAllMediasPaginationParams(fetchedMedias.length);
          medias.addAll(fetchedMedias);
        }
      } while (
          fetchedMediasLength < 20 && mediaState.value == MediaState.success);
      setState(() {});
    } else {
      List<MediaModel> fetchedMedias = await fetchMediasFromStorage(loadMore);

      if (mediaState.value != MediaState.failed) {
        medias.addAll(fetchedMedias);
        assetPageIndex++;
        if (fetchedMedias.length < pageSize) {
          mediaState.value = MediaState.empty;
        }
        setState(() {});
      }
    }
  }

  Future<List<MediaModel>> fetchMediasFromStorage(bool loadMore) async {
    try {
      if (loadMore) {
        mediaState.value = MediaState.loadMore;
      } else {
        mediaState.value = MediaState.loading;
      }
      List<AssetEntity> entities = await paths[currentPathIndex]
          .getAssetListPaged(size: pageSize, page: assetPageIndex);
      mediaState.value = MediaState.success;
      return entities.map((entity) => MediaModel(assetEntity: entity)).toList();
    } catch (e) {
      mediaState.value = MediaState.failed;
    }
    return [];
  }

  void configureAllMediasPaginationParams(int mediasLength) {
    if (mediaState.value == MediaState.success) {
      if (mediasLength < pageSize) {
        currentPathIndex++;
        assetPageIndex = 0;
        if (currentPathIndex >= paths.length) {
          mediaState.value = MediaState.empty;
        }
      } else {
        assetPageIndex++;
      }
    }
  }

  bool scrollListener(Object notification) {
    if (notification is ScrollNotification) {
      if (widget.scrollController.position.maxScrollExtent - 50 <=
              widget.scrollController.offset &&
          mediaState.value != MediaState.loadMore) {
        fetchAssetsMedias(loadMore: true);
      }
    }
    return false;
  }
}
