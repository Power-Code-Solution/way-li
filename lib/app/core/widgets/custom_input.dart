import 'package:flutter/material.dart';
import 'package:wayli/app/core/config/constants.dart';

class CostumFormField extends StatelessWidget {
  const CostumFormField(
      {super.key,
      required this.hintText,
      this.validator,
      this.onChange,
      this.icon,
      this.filled,
      this.labelText,
      this.fillColor,
      this.suffixIcon,
      this.minLines,
      this.maxLines,
      this.textController,
      this.keyboardType,
      this.obscureText,
      this.onTap,
      required this.isPassword});
  final Widget? icon;
  final Widget? suffixIcon;
  final dynamic? keyboardType;
  final bool? obscureText;
  final String? hintText;
  final String? labelText;
  final bool isPassword;
  final int? minLines;
  final int? maxLines;
  final bool? filled;
  final Color? fillColor;
  final TextEditingController? textController;
  final String? Function(String?)? validator;
  final void Function(String?)? onChange;
  final GestureTapCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      controller: textController,
      validator: validator,
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 1,
      onChanged: onChange,
      onTap: onTap,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        prefixIcon: icon,
        filled: filled,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: secondaryColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}
