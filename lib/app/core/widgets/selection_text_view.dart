import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';

class SelectionTextView extends StatelessWidget {
  final String title;
  final String actionTitle;
  final VoidCallback onSeeAllTap;
  const SelectionTextView(
      {super.key, required this.title, required this.onSeeAllTap, this.actionTitle = "See all"});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(
            title,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: GoogleFonts.montserrat(
                color: secondaryColor, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 35,
            child: TextButton(
              onPressed: onSeeAllTap,
              child: AutoSizeText(
                actionTitle,
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                    color: secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );
  }
}
