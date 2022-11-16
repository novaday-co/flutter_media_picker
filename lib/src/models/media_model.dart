import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';

enum MediaState { loading, success, failed , empty , loadMore}

class MediaModel {
  AssetEntity? assetEntity;
  Uint8List? image;
  String? path;
  ValueNotifier<MediaState> mediaState = ValueNotifier(MediaState.loading);

  MediaModel({
    this.assetEntity,
    this.image,
  }){
    generateAssetImage();
    initialAssetPath();
  }

  Future<void> generateAssetImage() async {
    try {
      mediaState.value = MediaState.loading;
      image =
      await assetEntity?.thumbnailDataWithSize(const ThumbnailSize(200, 200));
      mediaState.value = MediaState.success;
    } catch (e) {
      mediaState.value = MediaState.failed;
    }
  }

  Future<void> initialAssetPath() async {
    try {
      path = (await assetEntity?.file)?.path;
    } catch (e) {
      mediaState.value = MediaState.failed;
    }
  }

  String get fullPath {
    return "${assetEntity?.relativePath}${assetEntity?.title}";
  }
}
