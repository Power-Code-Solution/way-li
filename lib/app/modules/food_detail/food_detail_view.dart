import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/collection_food_item_cell.dart';
import 'package:wayli/app/core/widgets/food_item_list.dart';
import 'package:wayli/app/core/widgets/icon_text_button.dart';
import 'package:wayli/app/core/widgets/img_text_button.dart';
import 'package:wayli/app/core/widgets/photo_list_view.dart';
import 'package:wayli/app/core/widgets/selection_text_view.dart';
import 'package:wayli/app/core/widgets/user_review_row.dart';

import 'food_detail_controller.dart';

class FoodDetailView extends GetView<FoodDetailController> {
  final Map FIL;
  const FoodDetailView({super.key, required this.FIL});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

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
                            child: Image.asset(
                              FIL["image"].toString(),
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
                              Text(
                                FIL["name"].toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  "4.8",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
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
                                title: "Review",
                                subTitle: "953",
                                icon: "assets/images/review.png",
                                onPressed: () {},
                              ),
                              IconTextButton(
                                title: "Photo",
                                subTitle: "115",
                                icon: "assets/images/photo.png",
                                onPressed: () {},
                              ),
                              IconTextButton(
                                title: "Bookmark",
                                subTitle: "1478",
                                icon: "assets/images/bookmark_detail.png",
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
                                            Text(
                                              FIL["address"].toString(),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: secondaryColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              FIL["category"].toString(),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: secondaryColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "11:30AM to 11PM",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
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
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  FIL["image"].toString(),
                                  width: media.width,
                                  height: media.width * 0.2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: media.width,
                                height: media.width * 0.2,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Colors.black54,
                                    Colors.transparent
                                  ]),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  "Order food Online",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SelectionTextView(
                          title: "Photos",
                          actionTitle: "+ Add New photo",
                          onSeeAllTap: () {},
                        ),

                        SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal, // Enable horizontal scrolling
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ImgTextButton(
                                title: "Food",
                                subTitle: "(80)",
                                image: "assets/images/c1.png",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PhotoListView(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                  width: 8), // Add some spacing between buttons
                              ImgTextButton(
                                title: "Ambience",
                                subTitle: "(25)",
                                image: "assets/images/c2.png",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PhotoListView(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 8),
                              ImgTextButton(
                                title: "Menu",
                                subTitle: "(10)",
                                image: "assets/images/c3.png",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PhotoListView(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 8),
                              ImgTextButton(
                                title: "All Photos",
                                subTitle: "(115)",
                                image: "assets/images/l1.png",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PhotoListView(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          height: 4,
                          color: secondaryColor,
                        ),

                        SelectionTextView(
                          title: "Details",
                          actionTitle: "Read All",
                          onSeeAllTap: () {},
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Call",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "(212 789-7898)",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cuisines",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "Pizza Italian",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Average Cost",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "\$20 - \$40",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          height: 4,
                          color: secondaryColor,
                        ),

                        SelectionTextView(
                          title: "Reviews",
                          actionTitle: "Read All (953)",
                          onSeeAllTap: () {},
                        ),

                        ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: ((context, index) {
                              return UserReviewRow();
                            })),

                        Divider(
                          height: 4,
                          color: primaryColor,
                        ),

                        //TODO: Trending this week
                        SelectionTextView(
                          title: "Same Restaurants",
                          onSeeAllTap: () {},
                        ),

                        SizedBox(
                          height: media.width * 0.48,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              itemCount: ctl.trendingArr.length,
                              itemBuilder: (context, index) {
                                var FIL = ctl.trendingArr[index] as Map? ?? {};

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FoodDetailView(
                                                  FIL: FIL,
                                                )));
                                  },
                                  child: FoodItemList(
                                    FIL: FIL,
                                  ),
                                );
                              }),
                        ),

                        //TODO: Collections by Capi
                        SelectionTextView(
                          title: "Collections by Capi",
                          onSeeAllTap: () {},
                        ),

                        SizedBox(
                          height: media.width * 0.6,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              itemCount: ctl.collectionsArr.length,
                              itemBuilder: (context, index) {
                                var FLI =
                                    ctl.collectionsArr[index] as Map? ?? {};

                                return CollectionFoodItemCell(
                                  FIL: FIL,
                                );
                              }),
                        ),

                        const SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  ));
            }));
  }
}
