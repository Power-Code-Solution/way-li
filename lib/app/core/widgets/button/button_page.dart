import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';

class SubmitButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;

  const SubmitButton(this.title, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
            primaryColor,
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.6)
          ])),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, 
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: kWhiteColor
          ),
        ),
      ),
    );
  }
}


enum RoundButtonType { bgPrimary, textPrimary }

class RoundButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final RoundButtonType type;
  final double fontSize;
  const RoundButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.fontSize = 16,
      this.type = RoundButtonType.bgPrimary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: type == RoundButtonType.bgPrimary ? null : Border.all(color: primaryColor, width: 1),
          color: type == RoundButtonType.bgPrimary ? primaryColor : kWhiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AutoSizeText(
          title,
          style: GoogleFonts.montserrat(
              color: type == RoundButtonType.bgPrimary ? secondaryColor :  primaryColor, fontSize: fontSize, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}




enum RoundedButtonType { white, primary }

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final RoundedButtonType type;
  const RoundedButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.type = RoundedButtonType.white});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        minWidth: double.maxFinite,
        color:
            type == RoundedButtonType.white ? Colors.white : primaryColor,
        textColor: type == RoundedButtonType.white ? primaryColor : Colors.white ,
        height: 55,
        child: AutoSizeText(
          title,
          style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}