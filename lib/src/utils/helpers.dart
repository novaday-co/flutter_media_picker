import 'package:gallery_saver/gallery_saver.dart';

Future<void> saveImageInGallery(String imagePath) async {
  await GallerySaver.saveImage(imagePath);
}