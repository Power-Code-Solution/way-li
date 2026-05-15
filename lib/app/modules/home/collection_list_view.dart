import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/menu.dart';
import 'package:wayli/app/core/widgets/collection_food_item_cell.dart';
import 'package:wayli/app/core/widgets/line_textfield.dart';
import 'package:wayli/app/core/widgets/notification_empty_dialog.dart';
import 'package:wayli/app/modules/favourite_food/outlet_list_view.dart';

import 'home_controller.dart';

class CollectionListView extends GetView<HomeController> {
  const CollectionListView({super.key});

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
                    onPressed: () => showNotificationEmptyDialog(),
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: media.width * 5,
                          ),
                          child: ValueListenableBuilder<List<Menu>>(
                            valueListenable: ValueNotifier<List<Menu>>(
                                ctl.menuItems.toList().cast<Menu>()),
                            builder: (context, collectionsArr, child) {
                              return GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 8),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 0,
                                  childAspectRatio: 0.7,
                                  mainAxisSpacing: 0,
                                ),
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
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
