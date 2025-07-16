import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/menu.dart';
import 'package:wayli/app/core/widgets/collection_food_item_cell.dart';
import 'package:wayli/app/core/widgets/food_item_list.dart';
import 'package:wayli/app/core/widgets/line_textfield.dart';
import 'package:wayli/app/core/widgets/popular_food_item_cell.dart';
import 'package:wayli/app/core/widgets/selection_text_view.dart';
import 'package:wayli/app/modules/favourite_food/outlet_list_view.dart';
import 'package:wayli/app/modules/food_detail/food_detail_view.dart';
import 'package:wayli/app/modules/home/collection_list_view.dart';
import 'package:wayli/app/modules/sub_menu/sub_menu_view.dart';
import 'package:wayli/app/modules/sub_menu_food/sub_menu_food_view.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    var media = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
          onRefresh: () => controller.refreshButton(),
          color: kPrimaryColor,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          displacement: 200.0,
          strokeWidth: 3,
          child: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (ctl) {
              return CustomScrollView(
                scrollBehavior: ScrollBehavior(),
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
                          width: 20,
                          height: 20,
                          color: primaryColor,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          "assets/svg/cart.svg",
                          width: 20,
                          height: 20,
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
                                  title:
                                      "Food of the Day (${ctl.dayOfTheWeek})",
                                  onSeeAllTap: () {},
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: media.width * 0.35,
                            child: Obx(() {
                              if (ctl.foodItems.isEmpty) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
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
                          // SelectionTextView(
                          //   title: "Trending this week",
                          //   onSeeAllTap: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 const TrendingListView()));
                          //   },
                          // ),
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
                            height: media.width * 0.4,
                            child: GetBuilder<HomeController>(
                              init: HomeController(),
                              builder: (ctl) {
                                if (ctl.isLoading) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                return ValueListenableBuilder<List<Menu>>(
                                  valueListenable: ValueNotifier<List<Menu>>(
                                      ctl.menuItems.cast<Menu>().toList()),
                                  builder: (context, collectionsArr, child) {
                                    if (collectionsArr.isEmpty) {
                                      return Center(
                                          child: Text('No Menu Items Found'));
                                    }

                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      itemCount: collectionsArr.length,
                                      itemBuilder: (context, index) {
                                        var menuItem = collectionsArr[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => OutletListView(),
                                              arguments: {
                                                "menuItems": menuItem,
                                              },
                                            );
                                          },
                                          child: CollectionFoodItemCell(
                                            FIL: {
                                              'name': menuItem.name,
                                              'image': menuItem.coverImage,
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          SelectionTextView(
                            title: "Menu Category",
                            onSeeAllTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SubMenuView()));
                            },
                          ),
                          Obx(() {
                            if (ctl.menuItemCategory.isEmpty) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return SizedBox(
                              height: MediaQuery.of(context).size.width * 0.30,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                itemCount: ctl.menuItemCategory.length,
                                itemBuilder: (context, index) {
                                  var menuCategory =
                                      ctl.menuItemCategory[index];

                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => SubMenuFoodView(),
                                        arguments: {
                                          "menuItemCategory": menuCategory,
                                        },
                                      );
                                    },
                                    child: PopularFoodItemCell(
                                      FIL: {
                                        'outlets': menuCategory.name,
                                        'image': menuCategory.coverImage,
                                      },
                                      index: index,
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                          const Gap(50)
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }
}
