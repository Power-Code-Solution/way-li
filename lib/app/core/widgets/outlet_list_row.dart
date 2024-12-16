import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';


class OutletListRow extends StatelessWidget {
  final Map FIL;
  const OutletListRow({super.key, required this.FIL});

  @override
  Widget build(BuildContext context) {
    var rateVal = double.tryParse(FIL["rate"].toString()) ?? 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))
          ]),
      child: Row(
        
        children: [


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      FIL["time"].toString(),
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                          color: secondaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(
                        color: rateVal < 4.0 ? primaryColor : secondaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: AutoSizeText(
                        FIL["rate"].toString(),
                        textAlign: TextAlign.left,
                        style:  GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
                AutoSizeText(
                  FIL["name"].toString(),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(
                      color: secondaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 4,
                ),
                AutoSizeText(
                  FIL["address"].toString(),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(
                      color: secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
                AutoSizeText(
                  FIL["category"].toString(),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(
                      color: secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
