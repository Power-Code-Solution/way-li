import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class DropdownSelect extends StatelessWidget {
  const DropdownSelect(
      {super.key,
      required this.hintText,
      required this.list,
      required this.onChange,
      this.hintColor,
      this.initialIndex});
  final String hintText;
  final List<dynamic> list;
  final Function onChange;
  final int? initialIndex;
  final Color? hintColor;
  @override
  Widget build(BuildContext context) {
    return CustomDropdown.search(
      initialItem: initialIndex != null && initialIndex != -1 ? list[initialIndex!] : null,
      decoration: CustomDropdownDecoration(
          hintStyle: GoogleFonts.poppins(color: hintColor, fontSize: 15, ),
          closedBorder: const Border(
            left: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
            right: BorderSide(

              color: Colors.black,
              width: 1.0,
            ),
            bottom: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
            top: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          prefixIcon: const Icon(Icons.help_outline)),
      hintText: hintText,
      items: list,
      onChanged: (value) {
        onChange(value);
      },
    );
  }
}