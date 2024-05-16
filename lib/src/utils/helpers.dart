import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

Future<void> saveImageInGallery(String imagePath) async {
  Uint8List myUint8List = Uint8List.fromList(utf8.encode(imagePath));
  await ImageGallerySaver.saveImage(myUint8List);
}
