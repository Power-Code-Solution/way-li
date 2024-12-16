import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/collection_food_item_cell.dart';
import 'package:wayli/app/core/widgets/food_item_list.dart';
import 'package:wayli/app/core/widgets/line_textfield.dart';
import 'package:wayli/app/core/widgets/popular_food_item_cell.dart';
import 'package:wayli/app/core/widgets/selection_text_view.dart';
import 'package:wayli/app/modules/favourite_food/outlet_list_view.dart';
import 'package:wayli/app/modules/food_detail/food_detail_view.dart';
import 'package:wayli/app/modules/home/collection_list_view.dart';
import 'package:wayli/app/modules/home/trending_list_view.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    var media = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<HomeController>(
        init: HomeController(),
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
                          color: kWhiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    Obx(() => AutoSizeText(
              authController.userName.value.isNotEmpty
                  ? authController.userName.value
                  : "",
              textAlign: TextAlign.left,
              style: GoogleFonts.montserrat(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            )),
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
                  hitText: "Search for Favourite Food",
                  leftIcon: Icon(Icons.search, color: secondaryColor),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            SelectionTextView(
                              title: "Food of the Day (Monday)",
                              onSeeAllTap: () {},
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.48,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: ctl.legendaryArr.length,
                            itemBuilder: (context, index) {
                              var FIL = ctl.legendaryArr[index] as Map? ?? {};

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FoodDetailView(
                                                FIL: FIL,
                                              )));
                                },
                                child: FoodItemList(
                                  FIL: FIL,
                                ),
                              );
                            }),
                      ),
                      SelectionTextView(
                        title: "Trending this week",
                        onSeeAllTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TrendingListView()));
                        },
                      ),
                      SizedBox(
                        height: media.width * 0.48,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: ctl.trendingArr.length,
                            itemBuilder: (context, index) {
                              var FIL = ctl.trendingArr[index] as Map? ?? {};

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FoodDetailView(
                                                FIL: FIL,
                                              )));
                                },
                                child: FoodItemList(
                                  FIL: FIL,
                                ),
                              );
                            }),
                      ),


 SelectionTextView(
                      title: "Collections by WAY LI",
                      onSeeAllTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CollectionListView()));
                      },
                    ),

SizedBox(
                      height: media.width * 0.6,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: ctl.collectionsArr.length,
                          itemBuilder: (context, index) {
                            var FIL = ctl.collectionsArr[index] as Map? ?? {};

                            return CollectionFoodItemCell(
                              FIL: FIL,
                            );
                          }),
                    ),

 SelectionTextView(
                      title: "Popular brands",
                      onSeeAllTap: () {},
                    ),
SizedBox(
                      height: media.width * 0.42,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: ctl.popularArr.length,
                          itemBuilder: (context, index) {
                            var FIL = ctl.popularArr[index] as Map? ?? {};

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OutletListView(FIL: FIL)),
                                );
                              },
                              child: PopularFoodItemCell(
                                FIL: FIL,
                                index: index,
                              ),
                            );
                          }),
                    ),
                    const Gap(50)
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
