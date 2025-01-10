import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayli/app/core/widgets/food_item_list.dart';
import 'package:wayli/app/core/widgets/line_textfield.dart';
import 'package:wayli/app/modules/food_detail/food_detail_view.dart';

import 'sub_menu_food_controller.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/menu.dart';
import 'package:wayli/app/core/model/menu_category.dart';
import 'package:wayli/app/core/widgets/collection_food_item_cell.dart';
import 'package:wayli/app/core/widgets/filter_view.dart';
import 'package:wayli/app/core/widgets/outlet_list_row.dart';
import 'package:wayli/app/core/widgets/popular_food_item_cell.dart';
import 'package:wayli/app/core/widgets/popup_layout.dart';

import 'package:get/get.dart';
import 'package:wayli/app/modules/favourite_food/outlet_controller.dart';

class SubMenuFoodView extends GetView<SubMenuFoodController> {
  const SubMenuFoodView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final SubMenuFoodController controller = Get.put(SubMenuFoodController());

    return Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<SubMenuFoodController>(
            init: SubMenuFoodController(),
            builder: (ctl) {
              return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        elevation: 0,
                        expandedHeight: media.width * 0.660,
                        floating: false,
                        centerTitle: false,
                        pinned: true,
                        automaticallyImplyLeading: false,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Container(
                            width: media.width,
                            height: media.width * 0.667,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  controller.menuItemCategory.coverImage ??
                                      'N/A',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  controller.menuItemCategory.coverImage ??
                                      'N/A',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                              padding: EdgeInsets.only(top: 0),
                              height: media.width * 0.0,
                              alignment: Alignment.center,
                              child: AutoSizeText('')
                            ),
                          ),
                        ),
                        actions: [
                          IconButton(
                            icon: SvgPicture.asset(
                              "assets/svg/back_1.svg",
                              width: 24,
                              height: 30,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ];
                  },
                  body: CustomScrollView(
                    slivers: [
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
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: AutoSizeText(
                                            controller.menuItemCategory.name ??
                                                '',
                                            style: GoogleFonts.montserrat(
                                              color: Colors.blue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: TextButton(
                                            onPressed: () {
                                              Get.to(() => FilterView());
                                            },
                                            child: AutoSizeText(
                                              "Filter",
                                              style: GoogleFonts.montserrat(
                                                color: Colors.blue,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: media.width * 0.35,
                                child: Obx(() {
                                  if (ctl.foodItems.isEmpty) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                      color: primaryColor,
                                      strokeWidth: 5,
                                    ));
                                  }

                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    itemCount: ctl.foodItems.length,
                                    itemBuilder: (context, index) {
                                      var foodItem = ctl.foodItems[index];

                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => FoodDetailView(),
                                            arguments: {'FIL': foodItem},
                                          );
                                        },
                                        child: FoodItemList(
                                          foodItem: foodItem,
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ));
            }));
  }
}
