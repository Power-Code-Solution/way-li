import 'package:flutter/material.dart';
import 'package:wayli/app/core/config/constants.dart';


class FavoriteFoodItemCell extends StatelessWidget {
  final Map FIL;
  final int index;
  const FavoriteFoodItemCell(
      {super.key, required this.FIL, required this.index});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      width: media.width * 0.4,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              color: secondaryColor,
              width: double.maxFinite,
              height: double.maxFinite,
              child: Image.asset(
                FIL["image"].toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: secondaryColor
                  .withOpacity(0.6),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              FIL["name"].toString().toUpperCase(),
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
