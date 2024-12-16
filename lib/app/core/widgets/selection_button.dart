import 'package:flutter/material.dart';
import 'package:wayli/app/core/config/constants.dart';


class SelectionButton extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback onPressed;
  final bool isSelect;
  const SelectionButton(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.isSelect,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: FittedBox(child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: isSelect ? primaryColor : secondaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          Text(
            subTitle,
            style: TextStyle(
                color: isSelect ? primaryColor : secondaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w700),
          )
        ],
      ),
      ),
    );
  }
}
