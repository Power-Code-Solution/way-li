import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/food_items.dart';
import 'package:wayli/app/core/model/food_items_dto.dart';

class FoodItemList extends StatelessWidget {
  final FoodItem foodItem;

  const FoodItemList({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    String imageUrl = foodItem.foodItemsImages.isNotEmpty
        ? foodItem.foodItemsImages[0].image
        : '';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      // width: media.width * 0.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            child: Container(
              color: secondaryColor,
              width: media.width * 0.3,
              height: media.width * 0.18,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Center(child: Icon(Icons.image, size: 50)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  foodItem.name ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: secondaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxFontSize: 13,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 12,
                ),
                AutoSizeText(
                  foodItem.menuCategory.name ?? '',

                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: secondaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
 maxFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 11,
                ),
                AutoSizeText(
                  "LE " + foodItem.price.toString() ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: secondaryColor,
                    decoration: TextDecoration.underline,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                   maxFontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 13,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FoodTagsItemList extends StatelessWidget {
  final FoodandTagDto foodandTagDto;
  const FoodTagsItemList({super.key, required this.foodandTagDto});
  @override
  Widget build(BuildContext context) {
    return Container(
      
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  foodandTagDto.tagName ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class FoodandAllergensItemList extends StatelessWidget {
  final FoodandAllergensDto foodandTagDto;
  const FoodandAllergensItemList({super.key, required this.foodandTagDto});
  @override
  Widget build(BuildContext context) {
    return Container(
      
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  foodandTagDto.allergensName ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: secondaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class FoodandIngredIentItemList extends StatelessWidget {
  final FoodandIngredIentNameDto foodandTagDto;
  const FoodandIngredIentItemList({super.key, required this.foodandTagDto});
  @override
  Widget build(BuildContext context) {
    return Container(
      
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  foodandTagDto.ingredientName ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: secondaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
