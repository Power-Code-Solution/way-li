
import 'package:flutter/material.dart';
import 'package:wayli/app/core/config/constants.dart';


class IconTextButton extends StatelessWidget {
  final String title;
  final String subTitle;
  final String icon;
  final VoidCallback onPressed;
  const IconTextButton({super.key, required this.title, required this.subTitle, required this.icon, required this.onPressed });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 25,
            height: 25,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: TextStyle(
                color: secondaryColor, fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            subTitle,
            style: TextStyle(
                color: secondaryColor, fontSize: 12, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}