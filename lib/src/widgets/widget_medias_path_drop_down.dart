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
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2(
        icon: const SizedBox(),
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
                  style: dropDownButtonTextStyle ?? const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
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
          filled: dropDownButtonBackgroundColor != null ? true:false,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
        dropdownOverButton: true,
        // customItemsHeight: 36,
        items: items
            .map((item) => DropdownMenuItem(
                  value: items.indexOf(item),
                  child: Text(
                    item.toString(),
                    style:
                        dropDownItemsTextStyle ?? const TextStyle(fontSize: 16),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        isExpanded: false,
        selectedItemHighlightColor: selectedItemBackgroundColor ?? Colors.blue,
        buttonHeight: 45,
        buttonWidth: 250,
        value: selectedItemIndex != -1 ? selectedItemIndex : null,
        itemPadding: const EdgeInsets.symmetric(horizontal: 8),
        dropdownWidth: width ?? 260,
        dropdownMaxHeight: 350,
        offset: const Offset(0, -30),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: dropDownItemsBackgroundColor,
        ),
      ),
    );
  }
}
