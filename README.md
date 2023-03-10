# Flutter Media Picker Package

This Flutter package provides a media picker widget that allows users to select images from their device's camera roll or gallery, as well as capture new photos using their device's camera.

The media picker widget is designed to resemble the media picker in Telegram, with a preview of the camera viewfinder, a list of recently captured media, and a folder selector. Once the user selects a media item, a crop tool will appear to allow them to crop the image before submitting it.

## Getting Started

To use this package, add `flutter_media_picker` as a dependency in your `pubspec.yaml` file:
```
dependencies:
  flutter_media_picker: $latest_version
```
The latest stable version is: <img src="https://img.shields.io/pub/v/flutter_media_picker.svg" alt="Pub">

add this lines to `AdroidManifest.xml` file :
```
<manifest>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.CAMERA" />
</manifest>

```

Android 13 (Api 33) extra configs
```
<manifest>
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" /> 
</manifest>
```


## Customizing the Media Picker


Import the package in your Dart code:
```
import 'package:flutter_media_picker/flutter_media_picker.dart';
```

## Basic Usage :

You can show media picker bottom sheet .

```dart
    PickedMedia? pickedMedia;

  void _showMediaPickerModal() async {
    pickedMedia = await showMediaPickerBottomSheet(context);
  }
```

## Options :

| Option       	               | Type                         	 | Description                         |
|------------------------------|--------------------------------|-------------------------------------|
| backgroundColor 	            | Color	                         | The background Color of Modal       |
| headerWidget 	               | HeaderWidget	                  | customize all items in modal header |
| mediaBorder	 	               | Border 	                       | Border of media item                |
| mediaBorderRadius	 	         | BorderRadius 	                 | BorderRadius of media item          |
| mediaBoxShadow	 	            | List BoxShadow 	               | The shadow  of media item           |
| mediaBoxShape	 	             | BoxShape                       | The shape  of media item            |
| mediaCropper	 	              | MediaCropper                   | customize media cropper             |
| mediaFit	 	                  | Boxfit                         | BoxFit of media                     |
| mediaHorizontalSpacing	 	    | double                         | Horizontal spacing between medias   |
| mediaVerticalSpacing	 	      | double                         | Vertical spacing between medias     |
| mediaWidgetWidth	 	          | double                         | width of media item                 |
| mediaSkeletonBaseColor	 	    | Color                          | Base skeleton media color           |
| mediaSkeletonShimmerColor	 	 | Color                          | Skeleton Shimmer color media        |

## HeaderWidget :
| Option       	                        | Type                         	 | Description                                 |
|---------------------------------------|--------------------------------|---------------------------------------------|
| iconsColor 	                          | Color	                         | the header icons color                      |
| dropDownBackgroundColor 	             | Color	                         | the dropdown background color               |
| dropDownButtonBackgroundColor 	       | Color	                         | the dropdown button background color        |
| iconsBorderColor 	                    | Color	                         | the dropdown icons border color             |
| dropDownSelectedItemBackgroundColor 	 | Color	                         | the dropdown selected item background color |
| dropDownButtonTextStyle 	             | TextStyle	                     | the dropdown button text style              |
| dropDownItemsTextStyle 	              | TextStyle	                     | the dropdown items text style               |
| dropDownItemsTextStyle 	              | TextStyle	                     | the dropdown items text style               |

## Media Cropper :
| Option       	              | Type                         	 | Description                                                                        |
|-----------------------------|--------------------------------|------------------------------------------------------------------------------------|
| backgroundColor 	           | Color	                         | the background color of the media cropper page (default is the primary app color)  |
| activeControlsWidgetColor 	 | Color	                         | the  color of the active bottom navigation icon (default is the primary app color) |
| toolBarColor 	              | Color	                         | the  color of toolbar cropper page (default is the black)                          |
| toolbarWidgetColor 	        | Color	                         | the  color of all items in toolbar cropper page (default is the white)             |
| cropFrameColor 	            | Color	                         | the  color of frame cropper                                                        |
| cropFrameStrokeWidth 	      | int	                           | the width of frame cropper                                                         |
| compressPercentage 	        | Function(double)	              |                                                                                    |
| compressPicture 	           | bool	                          | compress image                                                                     |
| saveCroppedImage 	          | bool	                          | save cropped image or no?                                                          |


## Contributing
Contributions are welcome! Please feel free to open an issue or submit a pull request if you find a bug or have a feature request.

## License
This package is licensed under the MIT License. See the LICENSE file for details.
