import 'package:gallery_saver_plus/gallery_saver.dart';

Future<void> saveImageInGallery(String imagePath) async {
  await GallerySaver.saveImage(imagePath);
}
