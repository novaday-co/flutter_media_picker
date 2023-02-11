import 'package:flutter/services.dart';

class PickedMedia {
  String? path;
  Uint8List? bytes;
  String? extension;

  PickedMedia({
    this.path,
    this.bytes,
    this.extension,
  });
}
