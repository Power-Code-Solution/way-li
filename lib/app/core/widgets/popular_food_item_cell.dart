import 'package:flutter/material.dart';
import 'package:wayli/app/core/config/constants.dart';


class PopularFoodItemCell extends StatelessWidget {
  final Map FIL;
  final int index;
  const PopularFoodItemCell(
      {super.key, required this.FIL, required this.index});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: media.width * 0.2,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [

          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: secondaryColor
                  .withOpacity(0.6),
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
             
              width: media.width * 0.22,
              height: double.maxFinite,
              child: Image.network(
                FIL["image"].toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
            child:   Text(
             "${FIL["outlets"].toString()}",
              maxLines: 1,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }
}
