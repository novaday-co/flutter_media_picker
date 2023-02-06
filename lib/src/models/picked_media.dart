import 'package:flutter/services.dart';

class PickedMedia {
  String? path;
  Uint8List? bytes;

  PickedMedia({
    this.path,
    this.bytes,
  });
}
