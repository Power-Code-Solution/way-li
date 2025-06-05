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
import 'package:wayli/app/modules/sub_menu_food/sub_menu_food_view.dart';

class OutletListView extends StatelessWidget {
  final Map? FIL;

  const OutletListView({super.key, this.FIL});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final OutletController controller = Get.put(OutletController());

    return Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<OutletController>(
            init: OutletController(),
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
                          height: media.width * 0.660,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                controller.menuItem.coverImage ?? 'N/A',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                              padding: EdgeInsets.only(top: media.width * 0.25),
                              height: media.width * 0.8,
                              alignment: Alignment.center,
                              child: AutoSizeText('')),
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
                body: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: AutoSizeText(
                            controller.menuItem.name ?? '',
                            style: GoogleFonts.montserrat(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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

                    Obx(() {
                      if (ctl.menuItemCategory.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return Container(
                        // Use a Container instead of SizedBox
                        height: MediaQuery.of(context).size.width * 0.42,
                        padding: const EdgeInsets.only(top: 30.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: ctl.menuItemCategory.length,
                          itemBuilder: (context, index) {
                            var menuItemCategory = ctl.menuItemCategory[index];

                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => SubMenuFoodView(),
                                  arguments: {
                                    "menuItemCategory": menuItemCategory,
                                  },
                                );
                              },
                              child: PopularFoodItemCell(
                                FIL: {
                                  'outlets': menuItemCategory.name,
                                  'image': menuItemCategory.coverImage,
                                },
                                index: index,
                              ),
                            );
                          },
                        ),
                      );
                    }),

                    Obx(() {
                      if (ctl.menuItemCategory.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return Container(
                        // Use a Container instead of SizedBox
                        height: MediaQuery.of(context).size.width * 0.42,
                        padding: const EdgeInsets.only(top: 30.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: ctl.menuItemCategory.length,
                          itemBuilder: (context, index) {
                            var menuItemCategory = ctl.menuItemCategory[index];

                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => SubMenuFoodView(),
                                  arguments: {
                                    "menuItemCategory": menuItemCategory,
                                  },
                                );
                              },
                              child: PopularFoodItemCell(
                                FIL: {
                                  'outlets': menuItemCategory.name,
                                  'image': menuItemCategory.coverImage,
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
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(top: 30.0),
                    //       child: ListView.builder(
                    //         scrollDirection: Axis.horizontal,
                    //         padding: const EdgeInsets.symmetric(horizontal: 8),
                    //         itemCount: ctl.menuItemCategory.length,
                    //         itemBuilder: (context, index) {
                    //           var menuItemCategory =
                    //               ctl.menuItemCategory[index];

                    //           return GestureDetector(
                    //             onTap: () {
                    //               Get.to(
                    //                 () => SubMenuFoodView(),
                    //                 arguments: {
                    //                   "menuItemCategory": menuItemCategory,
                    //                 },
                    //               );
                    //             },
                    //             child: PopularFoodItemCell(
                    //               FIL: {
                    //                 'outlets': menuItemCategory.name,
                    //                 'image': menuItemCategory.coverImage,
                    //               },
                    //               index: index,
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   );
                    // }),
                  ],
                ),
              );
            }));
  }
}
