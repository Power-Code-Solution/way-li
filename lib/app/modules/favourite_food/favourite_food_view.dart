import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/line_textfield.dart';
import 'package:wayli/app/core/widgets/selection_text_view.dart';
import 'package:wayli/app/modules/favourite_food/favorite_food_item_cell.dart';

import 'favourite_food_controller.dart';

class FavouriteFoodView extends GetView<FavouriteFoodController> {
  const FavouriteFoodView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColor.withOpacity(0.1),
      resizeToAvoidBottomInset: false,
      body: GetBuilder<FavouriteFoodController>(
        init: FavouriteFoodController(),
        builder: (ctl) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: secondaryColor,
                elevation: 0,
                pinned: true,
                floating: false,
                centerTitle: false,
                automaticallyImplyLeading: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "Welcome Back",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AutoSizeText(
                      "Moussa Toure",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/svg/notification.svg",
                      width: 24,
                      height: 30,
                      color: primaryColor,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/svg/cart.svg",
                      width: 24,
                      height: 30,
                      color: primaryColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 1,
                pinned: false,
                floating: true,
                primary: false,
                automaticallyImplyLeading: false,
                title: RoundTextField(
                  controller: ctl.searchController,
                  hitText: "Search for your Favourite Food",
                  leftIcon: Icon(Icons.search, color: secondaryColor),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/piza.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInUp(
                              duration: Duration(milliseconds: 1000),
                              child: AutoSizeText(
                                "My Favourite",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.montserrat(
                                  color: primaryColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            FadeInUp(
                              duration: Duration(milliseconds: 1300),
                              child: AutoSizeText(
                                "Dishes",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.montserrat(
                                  color: primaryColor,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SelectionTextView(
                              title: "My Favourite Dishes",
                              onSeeAllTap: () {},
                            ),
                            SizedBox(
                              height: media.width * 0.47,
                              child: GridView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.55,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                ),
                                itemCount: ctl.favoriteArr.length,
                                itemBuilder: (context, index) {
                                  var FIL =
                                      ctl.favoriteArr[index] as Map? ?? {};
                                  return FavoriteFoodItemCell(
                                    FIL: FIL,
                                    index: index,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
