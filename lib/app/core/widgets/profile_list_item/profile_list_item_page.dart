import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wayli/app/core/config/constants.dart';

class ProfileListItemPage extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final bool? hasNavigation;
  final VoidCallback? onPressed;

  const ProfileListItemPage({
    super.key,
    this.icon,
    this.text,
    this.onPressed,
    this.hasNavigation = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: kSpacingUnit.w * 5.5,
        margin: EdgeInsets.symmetric(
          horizontal: kSpacingUnit.w * 4,
        ).copyWith(
          bottom: kSpacingUnit.w * 2,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: kSpacingUnit.w * 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kSpacingUnit.w * 2),
          color: kWhiteColor.withOpacity(0.1),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: kSpacingUnit.w * 2.5,
              color: primaryColor,
            ),
            SizedBox(width: kSpacingUnit.w * 1.5),
            AutoSizeText(
              text ?? '',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700, color: primaryColor),
            ),
            Spacer(),
            if (hasNavigation ?? false)
              Icon(
                LineAwesomeIcons.arrow_circle_right_solid,
                size: kSpacingUnit.w * 3.5,
                color: primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
