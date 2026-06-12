import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/line_textfield.dart';
import 'package:wayli/app/core/widgets/notification_empty_dialog.dart';
import 'package:wayli/app/core/widgets/popular_food_item_cell.dart';
import 'package:wayli/app/modules/sub_menu_food/sub_menu_food_view.dart';

import 'sub_menu_controller.dart';

class SubMenuView extends GetView<SubMenuController> {
  const SubMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<SubMenuController>(
        init: SubMenuController(),
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
                      width: 20,
                      height: 20,
                      color: primaryColor,
                    ),
                    onPressed: () => showNotificationEmptyDialog(),
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
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            // SelectionTextView(
                            //   title: "Food of the Day (${ctl.dayOfTheWeek})",
                            //   onSeeAllTap: () {},
                            // ),
                          ],
                        ),
                      ),

                      Obx(() {
                        if (ctl.menuItemCategory.isEmpty) {
                          return Center(child: CircularProgressIndicator());
                        }

                        return Container(
                          height: MediaQuery.of(context).size.width * 0.42,
                          padding: const EdgeInsets.only(top: 30.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: ctl.menuItemCategory.length,
                            itemBuilder: (context, index) {
                              var menuCategory = ctl.menuItemCategory[index];

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

                      // Obx(() {
                      //   if (ctl.menuItemCategory == null ||
                      //       ctl.menuItemCategory.isEmpty) {
                      //     return Center(child: CircularProgressIndicator());
                      //   }
                      //   return SizedBox(
                      //     height: MediaQuery.of(context).size.width * 0.42,
                      //     child: ListView.builder(
                      //       scrollDirection: Axis.horizontal,
                      //       padding: const EdgeInsets.symmetric(horizontal: 8),
                      //       itemCount: ctl.menuItemCategory.length,
                      //       itemBuilder: (context, index) {
                      //         var menuCategory = ctl.menuItemCategory[index];

                      //         return GestureDetector(
                      //           onTap: () {
                      //             Get.to(
                      //               () => SubMenuFoodView(),
                      //               arguments: {
                      //                 "menuItemCategory": menuCategory,
                      //               },
                      //             );
                      //           },
                      //           child: PopularFoodItemCell(
                      //             FIL: {
                      //               'outlets': menuCategory.name,
                      //               'image': menuCategory.coverImage,
                      //             },
                      //             index: index,
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //   );
                      // }),
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
