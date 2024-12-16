import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';



class FoodItemList extends StatelessWidget {
  final Map FIL;
  const FoodItemList({super.key, required this.FIL});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: media.width * 0.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            child: Container(
              color: secondaryColor,
              width: media.width * 0.4,
              height: media.width * 0.25,
              child: Image.asset(
                FIL["image"].toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),


           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                     AutoSizeText(
                FIL["name"].toString(),
                maxLines: 1,
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                    color: secondaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),

              const Gap(4,
              ),
              AutoSizeText(
                FIL["address"].toString(),
                maxLines: 1,
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                    color: secondaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),

              const Gap(4,),

               AutoSizeText(
                FIL["category"].toString(),
                maxLines: 1,
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                    color: secondaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
           
                   ]),
           )


        ],
      ),
    );
  }
}
