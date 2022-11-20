import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/utils/screen_size.dart';

class WidgetUtils {
  bool isOutFromBottom(BuildContext context, {Size? withSizeOf}) {
    RenderObject? renderObject = context.findRenderObject();
    if (renderObject != null) {
      RenderBox renderBox = renderObject as RenderBox;
      Offset globalOffset = renderBox.localToGlobal(Offset.zero);
      Size screenSize = context.getScreenSize();
      if(renderBox.hasSize == false) return false;
      double width = globalOffset.dx + renderBox.size.width + (withSizeOf?.width ?? 0);
      double height = globalOffset.dy + renderBox.size.height + (withSizeOf?.height ?? 0);
      if (screenSize.width <= width) {
        return true;
      }
      if (screenSize.height <= height) {
        return true;
      }
    }
    return false;
  }
}
