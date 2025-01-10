import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/collection_food_item_cell.dart';
import 'package:wayli/app/core/widgets/food_item_list.dart';
import 'package:wayli/app/core/widgets/icon_text_button.dart';
import 'package:wayli/app/core/widgets/img_text_button.dart';
import 'package:wayli/app/core/widgets/photo_list_view.dart';
import 'package:wayli/app/core/widgets/round_icon_button/round_icon_button_page.dart';
import 'package:wayli/app/core/widgets/selection_text_view.dart';
import 'package:wayli/app/core/widgets/user_review_row.dart';
import 'package:wayli/app/modules/history/history_view.dart';

import 'food_detail_controller.dart';

import 'package:wayli/app/core/model/food_items.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:food_delivery/common_widget/round_icon_button.dart';

// import '../../common/color_extension.dart';
// import '../more/my_order_view.dart';

class FoodDetailView extends StatelessWidget {
  const FoodDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    FoodItem FIL = Get.arguments['FIL'];
    String imageUrl =
        FIL.foodItemsImages.isNotEmpty ? FIL.foodItemsImages[0].image : '';

    var media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kWhiteColor,
        body: GetBuilder<FoodDetailController>(
            init: FoodDetailController(),
            builder: (ctl) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.network(
                    imageUrl,
                    width: media.width,
                    height: media.width,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: media.width,
                    height: media.width,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.transparent,
                            Colors.black
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: media.width - 60,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: kWhiteColor,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: AutoSizeText(
                                          FIL.name.toString(),
                                          style: GoogleFonts.montserrat(
                                              color: secondaryColor,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                IgnorePointer(
                                                  ignoring: true,
                                                  child: RatingBar.builder(
                                                    initialRating: 4,
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemSize: 20,
                                                    itemPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 1.0),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: secondaryColor,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                AutoSizeText(
                                                  " 4 Star Ratings",
                                                  style: GoogleFonts.montserrat(
                                                      color: secondaryColor,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                AutoSizeText(
                                                  "\LE ${FIL.price.toStringAsFixed(2)}",
                                                  style: GoogleFonts.montserrat(
                                                      color: secondaryColor,
                                                      fontSize: 31,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                const Gap(4),
                                                AutoSizeText(
                                                  "/per Portion",
                                                  style: GoogleFonts.montserrat(
                                                      color: secondaryColor,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Gap(
                                        15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: AutoSizeText(
                                          "Description",
                                          style: GoogleFonts.montserrat(
                                              color: secondaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: AutoSizeText(
                                          FIL.description.toString(),
                                          style: GoogleFonts.montserrat(
                                              color: secondaryColor,
                                              fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: Divider(
                                            color:
                                                secondaryColor.withOpacity(0.4),
                                            height: 1,
                                          )),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: AutoSizeText(
                                          "#TAGS",
                                          style: GoogleFonts.montserrat(
                                              color: secondaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: SizedBox(
                                        height: media.width * 0.11,
                                        child: Obx(() {
                                          if (ctl.foodandTagDto.isEmpty) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }

                                          return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0),
                                            itemCount: ctl.foodandTagDto.length,
                                            itemBuilder: (context, index) {
                                              var foodItem =
                                                  ctl.foodandTagDto[index];

                                              return GestureDetector(
                                                onTap: () {},
                                                child: FoodTagsItemList(
                                                  foodandTagDto: foodItem,
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                      ),
                                      ),
                                     Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: Divider(
                                            color:
                                                secondaryColor.withOpacity(0.4),
                                            height: 1,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: AutoSizeText(
                                          "Allergens",
                                          style: GoogleFonts.montserrat(
                                              color: secondaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: SizedBox(
                                        height: media.width * 0.11,
                                        child: Obx(() {
                                          if (ctl.foodandAllergensDto.isEmpty) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }

                                          return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0),
                                            itemCount: ctl.foodandAllergensDto.length,
                                            itemBuilder: (context, index) {
                                              var foodItem =
                                                  ctl.foodandAllergensDto[index];

                                              return GestureDetector(
                                                onTap: () {},
                                                child: FoodandAllergensItemList(
                                                  foodandTagDto: foodItem,
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                      ),
                                      ),
                                    Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: Divider(
                                            color:
                                                secondaryColor.withOpacity(0.4),
                                            height: 1,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: AutoSizeText(
                                          "Ingredents",
                                          style: GoogleFonts.montserrat(
                                              color: secondaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: SizedBox(
                                        height: media.width * 0.11,
                                        child: Obx(() {
                                          if (ctl.foodandIngredientDto.isEmpty) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }

                                          return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0),
                                            itemCount: ctl.foodandIngredientDto.length,
                                            itemBuilder: (context, index) {
                                              var foodItem =
                                                  ctl.foodandIngredientDto[index];

                                              return GestureDetector(
                                                onTap: () {},
                                                child: FoodandIngredIentItemList(
                                                  foodandTagDto: foodItem,
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                      ),
                                      ),
                                       Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: Divider(
                                            color:
                                                secondaryColor.withOpacity(0.4),
                                            height: 1,
                                          )),
                                     
                                      const Gap(25
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Row(
                                          children: [
                                            AutoSizeText(
                                              "Number of Portions",
                                              style: GoogleFonts.montserrat(
                                                  color: secondaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const Spacer(),
                                            InkWell(
                                              onTap: () {
                                                ctl.decrementQty();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                height: 25,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: kRedColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.5)),
                                                child: AutoSizeText(
                                                  "-",
                                                  style: GoogleFonts.montserrat(
                                                      color: kWhiteColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              height: 25,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: primaryColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.5)),
                                              child: Obx(() {
                                                return AutoSizeText(
                                                  ctl.qty.toString(),
                                                  style: GoogleFonts.montserrat(
                                                      color: secondaryColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                );
                                              }),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                ctl.incrementQty();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                height: 25,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.5)),
                                                child: AutoSizeText(
                                                  "+",
                                                  style: GoogleFonts.montserrat(
                                                      color: kWhiteColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 220,
                                        child: Stack(
                                          alignment: Alignment.centerLeft,
                                          children: [
                                            Container(
                                              width: media.width * 0.25,
                                              height: 160,
                                              decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(35),
                                                        bottomRight:
                                                            Radius.circular(
                                                                35)),
                                              ),
                                            ),
                                            Center(
                                              child: Stack(
                                                alignment:
                                                    Alignment.centerRight,
                                                children: [
                                                  Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 8,
                                                              bottom: 8,
                                                              left: 10,
                                                              right: 20),
                                                      width: media.width - 80,
                                                      height: 120,
                                                      decoration: const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(35),
                                                                  bottomLeft: Radius.circular(35),
                                                                  topRight: Radius.circular(10),
                                                                  bottomRight: Radius.circular(10)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black12,
                                                                blurRadius: 12,
                                                                offset: Offset(
                                                                    0, 4))
                                                          ]),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          AutoSizeText(
                                                            "Total Price",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    color:
                                                                        secondaryColor,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                          Obx(() {
                                                            return AutoSizeText(
                                                              "\LE ${(FIL.price * ctl.qty.value).toString()}",
                                                              style: GoogleFonts.montserrat(
                                                                  color:
                                                                      secondaryColor,
                                                                  fontSize: 21,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            );
                                                          }),
                                                          SizedBox(
                                                            width: 180,
                                                            height: 40,
                                                            child: RoundIconButton(
                                                                title:
                                                                    "Add to Cart",
                                                                icon:
                                                                    "assets/images/shopping_add.png",
                                                                color:
                                                                    secondaryColor,
                                                                onPressed:
                                                                    () {}),
                                                          )
                                                        ],
                                                      )),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const HistoryView()
                                                              // const MyOrderView()
                                                              ));
                                                    },
                                                    child: Container(
                                                      width: 45,
                                                      height: 45,
                                                      decoration: BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      22.5),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black12,
                                                                blurRadius: 4,
                                                                offset: Offset(
                                                                    0, 2))
                                                          ]),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Image.asset(
                                                          "assets/images/shopping_cart.png",
                                                          width: 20,
                                                          height: 20,
                                                          color:
                                                              secondaryColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ]),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          Container(
                            height: media.width - 20,
                            alignment: Alignment.bottomRight,
                            margin: const EdgeInsets.only(right: 4),
                            child: InkWell(
                              onTap: () {
                                ctl.toggleFavorite();
                              },
                              child: Obx(() {
                                return Image.asset(
                                  ctl.isFav.value
                                      ? "assets/images/favorites_btn.png"
                                      : "assets/images/favorites_btn_2.png",
                                  width: 70,
                                  height: 70,
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 35,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Image.asset(
                                  "assets/images/btn_back.png",
                                  width: 20,
                                  height: 20,
                                  color: kWhiteColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HistoryView()
                                          // const MyOrderView()
                                          ));
                                },
                                icon: Image.asset(
                                  "assets/images/shopping_cart.png",
                                  width: 25,
                                  height: 25,
                                  color: kWhiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }));
  }
}

class FoodDetailViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    FoodItem FIL = Get.arguments['FIL'];

    String imageUrl =
        FIL.foodItemsImages.isNotEmpty ? FIL.foodItemsImages[0].image : '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<FoodDetailController>(
          init: FoodDetailController(),
          builder: (ctl) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    expandedHeight: media.width * 0.667,
                    floating: false,
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Container(
                        width: media.width,
                        height: media.width * 0.667,
                        color: secondaryColor,
                        child: Image.network(
                          imageUrl.toString(),
                          width: media.width,
                          height: media.width * 0.8,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            FIL.name.toString(),
                            textAlign: TextAlign.left,
                            style: GoogleFonts.montserrat(
                                color: secondaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: AutoSizeText(
                              "NLE " + FIL.price.toString(),
                              textAlign: TextAlign.left,
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: AutoSizeText(
                              "NLE " + FIL.priceDouble.toString(),
                              textAlign: TextAlign.left,
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconTextButton(
                            title: "Share",
                            subTitle: "603",
                            icon: "assets/images/share.png",
                            onPressed: () {},
                          ),
                          IconTextButton(
                            title: "Likes",
                            subTitle: "953",
                            icon: "assets/images/review.png",
                            onPressed: () {},
                          ),
                          IconTextButton(
                            title: "Comment",
                            subTitle: "115",
                            icon: "assets/images/photo.png",
                            onPressed: () {},
                          ),
                          IconTextButton(
                            title: "Photos",
                            subTitle: "1478",
                            icon: "assets/images/photo.png",
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MapDetailView() ) );
                      },
                      child: Container(
                        color: Colors.white,
                        height: media.width * 0.4,
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(25),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          FIL.tags.toString(),
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                              color: secondaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        AutoSizeText(
                                          FIL.type.toString(),
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                              color: secondaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        AutoSizeText(
                                          "11:30AM to 11PM",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                              color: secondaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: media.width * 0.15),
                                    child: Image.asset(
                                        "assets/images/map_pin.png",
                                        width: 25),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ])),
            );
          }),
    );
  }
}























// class FoodDetailView extends GetView<FoodDetailController> {
//   final Map FIL;
//   const FoodDetailView({super.key, required this.FIL});

//   @override
//   Widget build(BuildContext context) {
//     var media = MediaQuery.of(context).size;

//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: GetBuilder<FoodDetailController>(
//             init: FoodDetailController(),
//             builder: (ctl) {
//               return NestedScrollView(
//                   headerSliverBuilder: (context, innerBoxIsScrolled) {
//                     return [
//                       SliverAppBar(
//                         backgroundColor: Colors.transparent,
//                         elevation: 0,
//                         expandedHeight: media.width * 0.667,
//                         floating: false,
//                         centerTitle: false,
//                         automaticallyImplyLeading: false,
//                         flexibleSpace: FlexibleSpaceBar(
//                           title: Container(
//                             width: media.width,
//                             height: media.width * 0.667,
//                             color: secondaryColor,
//                             child: Image.asset(
//                               FIL["image"].toString(),
//                               width: media.width,
//                               height: media.width * 0.8,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ];
//                   },
//                   body: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           color: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 8, horizontal: 15),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               AutoSizeText(
//                                 FIL["name"].toString(),
//                                 textAlign: TextAlign.left,
//                                 style: GoogleFonts.montserrat(
//                                     color: secondaryColor,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w700),
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 4, horizontal: 8),
//                                 decoration: BoxDecoration(
//                                     color: primaryColor,
//                                     borderRadius: BorderRadius.circular(10)),
//                                 child: const AutoSizeText(
//                                   "4.8",
//                                   textAlign: TextAlign.left,
//                                   style: GoogleFonts.montserrat(
//                                       color: Colors.white,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),

//                         Container(
//                           color: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 8, horizontal: 15),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               IconTextButton(
//                                 title: "Share",
//                                 subTitle: "603",
//                                 icon: "assets/images/share.png",
//                                 onPressed: () {},
//                               ),
//                               IconTextButton(
//                                 title: "Review",
//                                 subTitle: "953",
//                                 icon: "assets/images/review.png",
//                                 onPressed: () {},
//                               ),
//                               IconTextButton(
//                                 title: "Photo",
//                                 subTitle: "115",
//                                 icon: "assets/images/photo.png",
//                                 onPressed: () {},
//                               ),
//                               IconTextButton(
//                                 title: "Bookmark",
//                                 subTitle: "1478",
//                                 icon: "assets/images/bookmark_detail.png",
//                                 onPressed: () {},
//                               ),
//                             ],
//                           ),
//                         ),

//                         GestureDetector(
//                           onTap: () {
//                             // Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MapDetailView() ) );
//                           },
//                           child: Container(
//                             color: Colors.white,
//                             height: media.width * 0.4,
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(25),
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             AutoSizeText(
//                                               FIL["address"].toString(),
//                                               textAlign: TextAlign.left,
//                                               style: GoogleFonts.montserrat(
//                                                   color: secondaryColor,
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w700),
//                                             ),
//                                             const SizedBox(
//                                               height: 8,
//                                             ),
//                                             AutoSizeText(
//                                               FIL["category"].toString(),
//                                               textAlign: TextAlign.left,
//                                               style: GoogleFonts.montserrat(
//                                                   color: secondaryColor,
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w700),
//                                             ),
//                                             const SizedBox(
//                                               height: 8,
//                                             ),
//                                             AutoSizeText(
//                                               "11:30AM to 11PM",
//                                               textAlign: TextAlign.left,
//                                               style: GoogleFonts.montserrat(
//                                                   color: secondaryColor,
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w700),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                             right: media.width * 0.15),
//                                         child: Image.asset(
//                                             "assets/images/map_pin.png",
//                                             width: 25),
//                                       )
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.symmetric(
//                               vertical: 15, horizontal: 15),
//                           child: Stack(
//                             alignment: Alignment.centerLeft,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(5),
//                                 child: Image.asset(
//                                   FIL["image"].toString(),
//                                   width: media.width,
//                                   height: media.width * 0.2,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               Container(
//                                 width: media.width,
//                                 height: media.width * 0.2,
//                                 decoration: BoxDecoration(
//                                   gradient: const LinearGradient(colors: [
//                                     Colors.black54,
//                                     Colors.transparent
//                                   ]),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                               ),
//                               const Padding(
//                                 padding: EdgeInsets.all(15.0),
//                                 child: AutoSizeText(
//                                   "Order food Online",
//                                   textAlign: TextAlign.left,
//                                   style: GoogleFonts.montserrat(
//                                       color: Colors.white,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         SelectionTextView(
//                           title: "Photos",
//                           actionTitle: "+ Add New photo",
//                           onSeeAllTap: () {},
//                         ),

//                         SingleChildScrollView(
//                           scrollDirection:
//                               Axis.horizontal, // Enable horizontal scrolling
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               ImgTextButton(
//                                 title: "Food",
//                                 subTitle: "(80)",
//                                 image: "assets/images/c1.png",
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           const PhotoListView(),
//                                     ),
//                                   );
//                                 },
//                               ),
//                               SizedBox(
//                                   width: 8), // Add some spacing between buttons
//                               ImgTextButton(
//                                 title: "Ambience",
//                                 subTitle: "(25)",
//                                 image: "assets/images/c2.png",
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           const PhotoListView(),
//                                     ),
//                                   );
//                                 },
//                               ),
//                               SizedBox(width: 8),
//                               ImgTextButton(
//                                 title: "Menu",
//                                 subTitle: "(10)",
//                                 image: "assets/images/c3.png",
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           const PhotoListView(),
//                                     ),
//                                   );
//                                 },
//                               ),
//                               SizedBox(width: 8),
//                               ImgTextButton(
//                                 title: "All Photos",
//                                 subTitle: "(115)",
//                                 image: "assets/images/l1.png",
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           const PhotoListView(),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),

//                         Divider(
//                           height: 4,
//                           color: secondaryColor,
//                         ),

//                         SelectionTextView(
//                           title: "Details",
//                           actionTitle: "Read All",
//                           onSeeAllTap: () {},
//                         ),

//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           child: Column(
//                             children: [
//                               const SizedBox(
//                                 height: 8,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   AutoSizeText(
//                                     "Call",
//                                     textAlign: TextAlign.left,
//                                     style: GoogleFonts.montserrat(
//                                         color: secondaryColor,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w700),
//                                   ),
//                                   AutoSizeText(
//                                     "(212 789-7898)",
//                                     textAlign: TextAlign.left,
//                                     style: GoogleFonts.montserrat(
//                                         color: secondaryColor,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w700),
//                                   )
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 8,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   AutoSizeText(
//                                     "Cuisines",
//                                     textAlign: TextAlign.left,
//                                     style: GoogleFonts.montserrat(
//                                         color: secondaryColor,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w700),
//                                   ),
//                                   AutoSizeText(
//                                     "Pizza Italian",
//                                     textAlign: TextAlign.left,
//                                     style: GoogleFonts.montserrat(
//                                         color: secondaryColor,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w700),
//                                   )
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 8,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   AutoSizeText(
//                                     "Average Cost",
//                                     textAlign: TextAlign.left,
//                                     style: GoogleFonts.montserrat(
//                                         color: secondaryColor,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w700),
//                                   ),
//                                   AutoSizeText(
//                                     "\$20 - \$40",
//                                     textAlign: TextAlign.left,
//                                     style: GoogleFonts.montserrat(
//                                         color: secondaryColor,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w700),
//                                   )
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 8,
//                               ),
//                             ],
//                           ),
//                         ),

//                         Divider(
//                           height: 4,
//                           color: secondaryColor,
//                         ),

//                         SelectionTextView(
//                           title: "Reviews",
//                           actionTitle: "Read All (953)",
//                           onSeeAllTap: () {},
//                         ),

//                         ListView.builder(
//                             padding: EdgeInsets.zero,
//                             physics: const NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: 3,
//                             itemBuilder: ((context, index) {
//                               return UserReviewRow();
//                             })),

//                         Divider(
//                           height: 4,
//                           color: primaryColor,
//                         ),

//                         //TODO: Trending this week
//                         SelectionTextView(
//                           title: "Same Restaurants",
//                           onSeeAllTap: () {},
//                         ),

//                         SizedBox(
//                           height: media.width * 0.48,
//                           child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               itemCount: ctl.trendingArr.length,
//                               itemBuilder: (context, index) {
//                                 var FIL = ctl.trendingArr[index] as Map? ?? {};

//                                 return GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 FoodDetailView(
//                                                   FIL: FIL,
//                                                 )));
//                                   },
//                                   child: FoodItemList(
//                                     FIL: FIL,
//                                   ),
//                                 );
//                               }),
//                         ),

//                         //TODO: Collections by Capi
//                         SelectionTextView(
//                           title: "Collections by Capi",
//                           onSeeAllTap: () {},
//                         ),

//                         SizedBox(
//                           height: media.width * 0.6,
//                           child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               itemCount: ctl.collectionsArr.length,
//                               itemBuilder: (context, index) {
//                                 var FLI =
//                                     ctl.collectionsArr[index] as Map? ?? {};

//                                 return CollectionFoodItemCell(
//                                   FIL: FIL,
//                                 );
//                               }),
//                         ),

//                         const SizedBox(
//                           height: 15,
//                         )
//                       ],
//                     ),
//                   ));
//             }));
//   }
// }
