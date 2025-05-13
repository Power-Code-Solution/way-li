import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/newpages/components/Card.dart';
import 'package:wayli/app/newpages/components/colors.dart';

import '../../core/config/constants.dart';
import '../../core/widgets/animated_textfield/view.dart';
import '../../core/widgets/skelton_loading.dart';
import '../../modules/app_bar/app_bar_page.dart';
import '../../modules/home/home_controller.dart';

class Homepage extends GetView<HomeController> {
  const Homepage({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final HomeController homeController = Get.put(HomeController());
    final crossAxisCount = orientation == Orientation.portrait ? 2 : 3;
    final horizontalPadding = size.width * 0.04;
    final gridSpacing = size.width * 0.02;

    return Scaffold(
        drawer: const AppBarPage(),
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.08),
          child: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    ),
    ),
            backgroundColor: mainYellow,
            title: Row(
              children: [
                
                Image.asset("assets/images/way-li_logo.png", width: 75),
              ],
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Icon(Icons.notifications),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: homeController.refreshButton,
          color: kPrimaryColor,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          displacement: 200.0,
          strokeWidth: 3,

          child: GetBuilder<HomeController>(
              init: HomeController(),
              builder: (ctl) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Gap(4),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 600),
                            child: AnimatedHintTextField(
                              controller: homeController.searchController,
                              onChanged: (value) => homeController.filterFoodItems(value),
                              size: MediaQuery.of(context).size,
                            ),
                          ),
                        ),
                        Gap(4),
                        Obx(() {
                            if (ctl.loading.value) {return Center(child: Skelton());}
                            if (controller.foodItems.isEmpty) {
                              return Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/way-li_logo.png',
                                        height: 200,
                                        width: 200,
                                      ),
                                      SizedBox(height: 20),
                                      AutoSizeText(
                                        'Sorry',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      AutoSizeText(
                                        'No Food Item available at the moment!',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          color: Colors.grey[500],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 30),
                                      ElevatedButton(
                                        onPressed: () {
                                          controller.refreshButton();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          secondaryColor,
                                          shadowColor: Colors.transparent,
                                        ),
                                        child: AutoSizeText('Refresh', style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          color: primaryColor,
                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double itemWidth = (constraints.maxWidth -
                                          (gridSpacing *
                                              (crossAxisCount - 1))) /
                                      crossAxisCount;
                                  double aspectRatio =
                                      itemWidth / (itemWidth * 1.2);

                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: gridSpacing,
                                      mainAxisSpacing: gridSpacing,
                                      childAspectRatio: aspectRatio,
                                    ),
                                    itemCount: ctl.foodItems.length,
                                    itemBuilder: (context, index) {
                                      return CardMain(
                                          foodItem: ctl.foodItems[index]);
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
                );
              }),
        ));
  }
}






