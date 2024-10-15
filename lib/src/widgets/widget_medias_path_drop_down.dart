import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class MediaPickerDropDown extends StatelessWidget {
  final List items;
  final void Function(int?)? onChanged;
  final int selectedItemIndex;
  final String hintText;
  final double? width;

  final TextStyle? dropDownButtonTextStyle;
  final TextStyle? dropDownItemsTextStyle;
  final Color? selectedItemBackgroundColor;
  final Color? dropDownItemsBackgroundColor;
  final Color? dropDownButtonBackgroundColor;

  const MediaPickerDropDown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.selectedItemIndex,
    required this.hintText,
    this.width,
    this.dropDownButtonTextStyle,
    this.dropDownButtonBackgroundColor,
    this.dropDownItemsTextStyle,
    this.selectedItemBackgroundColor,
    this.dropDownItemsBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2<int>(
        //icon: const SizedBox(),
        iconStyleData: const IconStyleData(icon: SizedBox()),
        customButton: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  items[selectedItemIndex].toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: dropDownButtonTextStyle ??
                      const TextStyle(
                        fontSize: 18,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
                size: 15,
              )
            ],
          ),
        ),
        decoration: InputDecoration(
          fillColor: dropDownButtonBackgroundColor,
          filled: dropDownButtonBackgroundColor != null ? true : false,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          constraints: const BoxConstraints(),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 18),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide.none,
          ),
        ),
        //dropdownOverButton: true, //jansari added: there is no replacement in the new version
        // customItemsHeight: 36,
        items: items.map((item) {
          return DropdownItem(
            value: items.indexOf(item),
            child: Text(
              item.toString(),
              style: dropDownItemsTextStyle ?? const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        isExpanded: false,
        buttonStyleData: const ButtonStyleData(height: 45, width: 250),
        dropdownStyleData: DropdownStyleData(
          width: width ?? 260,
          maxHeight: 350,
          offset: const Offset(0, -30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: dropDownItemsBackgroundColor,
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        // selectedItemHighlightColor: selectedItemBackgroundColor ?? Colors.blue, //jansari added: there is no replacement in the new version
        // value: selectedItemIndex != -1 ? selectedItemIndex : null, //jansari added: there is no replacement in the new version
        // buttonHeight: 45,
        // buttonWidth: 250,
        // itemPadding: const EdgeInsets.symmetric(horizontal: 8),
        // dropdownWidth: width ?? 260,
        // dropdownMaxHeight: 350,
        // offset: const Offset(0, -30),
        // dropdownDecoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10),
        //   color: dropDownItemsBackgroundColor,
        // ),
      ),
    );
  }
}
