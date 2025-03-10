import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wayli/app/newpages/components/Card.dart';
import 'package:wayli/app/newpages/components/colors.dart';

import '../../core/config/constants.dart';
import '../../modules/home/home_controller.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final HomeController homeController = Get.put(HomeController());
    // Calculate dynamic grid properties
    final crossAxisCount = orientation == Orientation.portrait
        ? 2
        : 3;
    final horizontalPadding = size.width * 0.04;
    final gridSpacing = size.width * 0.02;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(size.height * 0.08),
        child: AppBar(
          leading: const Icon(Icons.menu),
          backgroundColor: mainYellow,
          title: Row(
            children: [
              const Text(
                "Way Li",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset("assets/images/way-li_logo.png", width: 30),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(Icons.notifications),
            )
          ],
        ),
      ),
      body:
      RefreshIndicator(
      onRefresh: () => homeController.refreshButton(),
      color: kPrimaryColor,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      displacement: 200.0,
      strokeWidth: 3,
      child:
      SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.02),
              // Search Field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 600,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(fontSize: size.width * 0.04),
                      suffixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.015,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Grid View
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double itemWidth = (constraints.maxWidth -
                            (gridSpacing * (crossAxisCount - 1))) /
                        crossAxisCount;
                    double aspectRatio = itemWidth /
                        (itemWidth * 1.2); // Adjust 1.2 to change card height
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: gridSpacing,
                        mainAxisSpacing: gridSpacing,
                        childAspectRatio: aspectRatio,
                      ),
                      itemCount: homeController.foodItems.length,
                      itemBuilder: (context, index) {
                        return CardMain(foodItem: homeController.foodItems[index]);
                      },
                    );

                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      )),
    );
  }
}
