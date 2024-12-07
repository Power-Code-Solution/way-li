import 'package:animate_do/animate_do.dart';
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







//  FadeInUp(duration: Duration(milliseconds: 1600), child: MaterialButton(
//                           onPressed: () {},
//                           height: 50,
//                           // margin: EdgeInsets.symmetric(horizontal: 50),
//                           color: Colors.orange[900],
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(50),

//                           ),
//                           // decoration: BoxDecoration(
//                           // ),
//                           child: Center(
//                             child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
//                           ),
//                         )),