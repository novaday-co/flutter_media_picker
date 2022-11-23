import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/models/cropper_model.dart';
import 'package:flutter_media_picker/src/models/media_model.dart';
import 'package:flutter_media_picker/src/utils/screen_size.dart';
import 'package:flutter_media_picker/src/widgets/camera_page.dart';
import 'package:flutter_media_picker/src/widgets/edit_image_page.dart';
import 'package:flutter_media_picker/src/widgets/gridview_skeleton_loading.dart';
import 'package:flutter_media_picker/src/widgets/medias_gridview.dart';
import 'package:flutter_media_picker/src/widgets/modal_header.dart';
import 'package:gallery_saver/gallery_saver.dart';
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

  final Color? mediaSkeletonBaseColor;

  final Color? mediaSkeletonShimmerColor;

  final Widget? mediaLoadingWidget;

  final MediaCropper? mediaCropper;

  final TextStyle? dropDownButtonTextStyle;

  final TextStyle? dropDownItemsTextStyle;

  final Color? dropDownSelectedItemBackgroundColor;

  final Color? dropDownBackgroundColor;

  final Color? backgroundColor;

  final Color? headersIconsBorderColor;

  final Color? headersIconsColor;

  final int? imageQualityPercentage;

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
    this.backgroundColor,
    this.mediaBackgroundColor,
    this.mediaSkeletonBaseColor,
    this.mediaSkeletonShimmerColor,
    this.headersIconsBorderColor,
    this.headersIconsColor,
    this.mediaLoadingWidget,
    this.dropDownButtonTextStyle,
    this.dropDownItemsTextStyle,
    this.dropDownSelectedItemBackgroundColor,
    this.dropDownBackgroundColor,
    this.imageQualityPercentage,
    this.mediaCropper,
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
  int currentAssetIndex = 0;
  int assetPageIndex = 0;
  int pageSize = 20;

  @override
  void initState() {
    fetchAssetsPath();
    initialCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Column(
        key: modalKey,
        children: [
          ModalHeader(
            paths: paths.map((e) => e.name).toList(),
            selectedDropDownItemIndex: selectedPathIndex,
            onChangePath: _onChangeAssetPath,
            crossFadeState: _crossFadeState,
            onOpenGallery: _onOpenGallery,
            headersIconsBorderColor: widget.headersIconsBorderColor,
            headersIconsColor: widget.headersIconsColor,
            dropDownButtonBackgroundColor: widget.backgroundColor,
            dropDownItemsTextStyle: widget.dropDownItemsTextStyle,
            dropDownButtonTextStyle: widget.dropDownButtonTextStyle,
            dropDownBackgroundColor: widget.dropDownBackgroundColor,
            dropDownSelectedItemBackgroundColor: widget.dropDownSelectedItemBackgroundColor,
          ),
          Expanded(
            child: NotificationListener(
              onNotification: scrollListener,
              child: ValueListenableBuilder<MediaState>(
                valueListenable: mediaState,
                builder: (context, state, child) {
                  switch (state) {
                    case MediaState.loading:
                      return const GridViewSkeletonLoading();
                    default:
                      return MediasGridView(
                        cameraController: cameraController,
                        medias: medias,
                        onSelectMedia: _onSelectMedia,
                        onOpenCamera: _onOpenCamera,
                        scrollController: widget.scrollController,
                        loadingWidget: widget.mediaLoadingWidget,
                        mediaBackgroundColor: widget.mediaBackgroundColor,
                        mediaBorder: widget.mediaBorder,
                        mediaFit: widget.mediaFit,
                        mediaSkeletonBaseColor: widget.mediaSkeletonBaseColor,
                        mediaSkeletonShimmerColor:
                        widget.mediaSkeletonShimmerColor,
                        boxShape: widget.mediaBoxShape,
                        borderRadius: widget.mediaBorderRadius,
                        boxShadow: widget.mediaBoxShadow,
                        mediaHorizontalSpacing: widget.mediaHorizontalSpacing,
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
    );
  }

  CrossFadeState get _crossFadeState {
    if (modalKey.currentContext != null) {
      final obj = modalKey.currentContext?.findRenderObject() as RenderBox;
      if (obj.size.height >= context.getScreenSize().height * 0.9) {
        return CrossFadeState.showSecond;
      }
      return CrossFadeState.showFirst;
    }
    return CrossFadeState.showFirst;
  }

  void _onOpenGallery() async {
    final ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.gallery).then((image) {
      if(image != null){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditImagePage(
              title: "",
              isFromCamera: false,
              imageQualityPercentage: widget.imageQualityPercentage,
              mediaCropper: widget.mediaCropper,
              imagePath: image.path,
            ),
          ),
        );
      }
    });

  }

  void _onOpenCamera() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPage(
            cameraController: cameraController!,
            onCapture: () {
              cameraController?.takePicture().then((imageFile) {
                saveCameraImageInGallery(imageFile);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditImagePage(
                      title: "",
                      isFromCamera: true,
                      imageQualityPercentage: widget.imageQualityPercentage,
                      mediaCropper: widget.mediaCropper,
                      imagePath: imageFile.path,
                    ),
                  ),
                );
              });
            },
          ),
        ));
  }

  void saveCameraImageInGallery(XFile? image) async {
    GallerySaver.saveImage(image!.path);
  }

  void _onSelectMedia(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditImagePage(
            title: "",
            mediaCropper: widget.mediaCropper,
            imageQualityPercentage: widget.imageQualityPercentage,
            imagePath: medias[index - 1].path!),
      ),
    );
  }

  void _onChangeAssetPath(int assetsIndex) {
    if (selectedPathIndex == assetsIndex) return;
    setState(() {});
    medias.clear();
    mediaState.value = MediaState.success;
    selectedPathIndex = assetsIndex;
    currentAssetIndex = assetsIndex;
    assetPageIndex = 0;
    fetchAssetsMedias();
  }

  Future<void> initialCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
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
    if (selectedPathIndex == 0) {
      if (mediaState.value == MediaState.empty) return;

      List<MediaModel> fetchedMedias = await fetchMediasFromStorage(loadMore);

      if (mediaState.value != MediaState.failed) {
        medias.addAll(fetchedMedias);
        configureAllMediasPaginationParams(fetchedMedias.length);
        setState(() {});
      }
    } else {
      if (mediaState.value == MediaState.empty) return;

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
      List<AssetEntity> entities = await paths[
              currentAssetIndex > 0 ? currentAssetIndex - 1 : currentAssetIndex]
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
        currentAssetIndex++;
        assetPageIndex = 0;
        if (currentAssetIndex >= paths.length) {
          mediaState.value = MediaState.empty;
        }
      } else {
        assetPageIndex++;
      }
    }
  }

  bool scrollListener(Object notification) {
    if (notification is ScrollNotification) {
      if (widget.scrollController.position.maxScrollExtent ==
              widget.scrollController.offset &&
          mediaState.value != MediaState.loadMore) {
        fetchAssetsMedias(loadMore: true);
      }
    }
    return false;
  }
}
