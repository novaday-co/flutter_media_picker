import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/models/modal_header_model.dart';
import 'package:flutter_media_picker/src/widgets/widget_medias_path_drop_down.dart';

class ModalHeader extends StatelessWidget {
  final List<String> paths;

  final Function(int) onChangePath;

  final VoidCallback onOpenGallery;

  final CrossFadeState crossFadeState;

  final int selectedDropDownItemIndex;

  final HeaderWidget? headerWidget;

  const ModalHeader({
    super.key,
    required this.paths,
    required this.onChangePath,
    required this.selectedDropDownItemIndex,
    required this.onOpenGallery,
    required this.crossFadeState,
    this.headerWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (headerWidget?.headerBuilder != null) {
      return headerWidget!.headerBuilder!.call(paths, onChangePath);
    }

    return AnimatedCrossFade(
      firstChild: SizedBox(
        height: 50,
        child: Center(
          child: Container(
            height: 5,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      secondChild: SizedBox(
        height: 50,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: headerWidget?.iconsBorderColor ?? Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: headerWidget?.iconsColor ?? Colors.grey,
                      size: 12,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MediaPickerDropDown(
                  items: [...paths.map((e) => e).toList()],
                  onChanged: (index) {
                    if (index != null) onChangePath.call(index);
                  },
                  dropDownButtonBackgroundColor:
                      headerWidget?.dropDownButtonBackgroundColor,
                  selectedItemBackgroundColor:
                      headerWidget?.dropDownSelectedItemBackgroundColor,
                  selectedItemIndex: selectedDropDownItemIndex,
                  hintText: "",
                  dropDownItemsBackgroundColor:
                      headerWidget?.dropDownBackgroundColor,
                  dropDownButtonTextStyle:
                      headerWidget?.dropDownButtonTextStyle,
                  dropDownItemsTextStyle: headerWidget?.dropDownItemsTextStyle,
                ),
              ),
              PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      'open gallery',
                      style: headerWidget?.dropDownItemsTextStyle ??
                          const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                offset: const Offset(0, 40),
                color: headerWidget?.dropDownBackgroundColor,
                onSelected: (index) => onOpenGallery.call(),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: headerWidget?.iconsBorderColor ?? Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.more_vert_sharp,
                      color: headerWidget?.iconsColor ?? Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      crossFadeState: crossFadeState,
      duration: const Duration(milliseconds: 100),
    );
  }
}
