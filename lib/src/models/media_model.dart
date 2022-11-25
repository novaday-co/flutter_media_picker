import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';

enum MediaState { loading, success, failed, empty, loadMore }

class MediaModel {
  AssetEntity? assetEntity;
  String? thumbnailPath;
  String? path;
  ValueNotifier<MediaState> mediaState = ValueNotifier(MediaState.loading);

  MediaModel({
    this.assetEntity,
    this.thumbnailPath,
  }) {
    initialAssetPath();
  }

  Future<void> initialAssetPath() async {
    try {
      mediaState.value = MediaState.loading;
      path = (await assetEntity?.file)?.path;
      mediaState.value = MediaState.success;
    } catch (e) {
      mediaState.value = MediaState.failed;
    }
  }

  String get fullPath {
    return "${assetEntity?.relativePath}${assetEntity?.title}";
  }
}
