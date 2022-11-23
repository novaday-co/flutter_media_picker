import 'package:flutter/material.dart';
import 'package:flutter_media_picker/src/widgets/medias_path_drop_down.dart';

class ModalHeader extends StatelessWidget {
  final List<String> paths;
  final Function(int) onChangePath;
  final VoidCallback onOpenGallery;
  final CrossFadeState crossFadeState;
  final int selectedDropDownItemIndex;

  final TextStyle? dropDownButtonTextStyle;

  final TextStyle? dropDownItemsTextStyle;

  final Color? dropDownSelectedItemBackgroundColor;

  final Color? dropDownBackgroundColor;

  final Color? dropDownButtonBackgroundColor;

  final Color? headersIconsBorderColor;

  final Color? headersIconsColor;

  const ModalHeader({
    Key? key,
    required this.paths,
    required this.onChangePath,
    required this.selectedDropDownItemIndex,
    required this.onOpenGallery,
    required this.crossFadeState,
    this.dropDownButtonTextStyle,
    this.dropDownItemsTextStyle,
    this.dropDownSelectedItemBackgroundColor,
    this.dropDownBackgroundColor,
    this.dropDownButtonBackgroundColor,
    this.headersIconsBorderColor,
    this.headersIconsColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      color: headersIconsBorderColor ?? Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Center(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: headersIconsColor ?? Colors.grey,
                      size: 12,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MediaPickerDropDown(
                  items: [
                    "all media",
                    ...paths.map((e) => e).toList(),
                  ],
                  onChanged: (index) {
                    if (index != null) onChangePath.call(index);
                  },
                  dropDownButtonBackgroundColor: dropDownButtonBackgroundColor,
                  selectedItemBackgroundColor:
                  dropDownSelectedItemBackgroundColor,
                  selectedItemIndex: selectedDropDownItemIndex,
                  hintText: "choose media",
                  dropDownItemsBackgroundColor: dropDownBackgroundColor,
                  dropDownButtonTextStyle: dropDownButtonTextStyle,
                  dropDownItemsTextStyle: dropDownItemsTextStyle,
                ),
              ),
              PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      'open gallery',
                      style: dropDownItemsTextStyle ??
                          const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                offset: const Offset(0,40),
                color: dropDownBackgroundColor,
                onSelected: (index) {
                  onOpenGallery.call();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: headersIconsBorderColor ?? Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Center(
                    child: Icon(
                      Icons.more_vert_sharp,
                      color: headersIconsColor ?? Colors.grey,
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
