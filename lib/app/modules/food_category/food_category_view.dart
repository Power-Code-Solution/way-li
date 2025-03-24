import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayli/app/core/model/menu_category.dart';
import 'package:wayli/app/newpages/components/Card.dart';

import '../../core/widgets/skelton_loading.dart';
import '../../newpages/components/colors.dart';
import 'food_category_controller.dart';


class FoodCategoryView extends GetView<FoodCategoryController> {
  const FoodCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final categoryController = Get.find<FoodCategoryController>();
    final horizontalPadding = size.width * 0.04;
    final crossAxisCount = orientation == Orientation.portrait ? 2 : 3;
    final gridSpacing = size.width * 0.02;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.08),
        child: AppBar(
          leading: const Icon(Icons.chevron_left),
          backgroundColor: mainYellow,
          title: const Text("Category"),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: TextFormField(
                    controller: categoryController.searchController,
                    onChanged: (value) => categoryController.filterFoodItems(value),
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(fontSize: size.width * 0.04),
                      suffixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 2, color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.015,
                      ),
                    ),
                  )

                ),
              ),
              SizedBox(height: size.height * 0.02),
              SizedBox(
                height: size.height * 0.07,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  itemCount: controller.menuItemCategory.length,
                  itemBuilder: (context, index) {
                    return CategoryTile(controller.menuItemCategory[index], size);
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: Skelton());
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double itemWidth = (constraints.maxWidth - (gridSpacing * (crossAxisCount - 1))) / crossAxisCount;
                      double aspectRatio = itemWidth / (itemWidth * 1.2);
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: gridSpacing,
                          mainAxisSpacing: gridSpacing,
                          childAspectRatio: aspectRatio,
                        ),
                        itemCount: controller.foodItems.length,
                        itemBuilder: (context, index) {
                          return CardMain(foodItem: controller.foodItems[index]);
                        },
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}


class CategoryTile extends StatelessWidget {
  final MenuCategory category;
  final Size size;

  const CategoryTile(this.category, this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<FoodCategoryController>();
    final tileWidth = size.width * 0.22;
    final tileHeight = size.height * 0.05;
    final fontSize = size.width * 0.035;
    return Obx(() => GestureDetector(
      onTap: () {
        categoryController.setCategory(category.id);
      },
      child: Container(
        margin: EdgeInsets.only(right: size.width * 0.02),
        height: tileHeight,
        width: tileWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: categoryController.selectedCategoryIndex.value == category.id
              ? mainYellow
              : Colors.transparent,
          border: Border.all(width: 2, color: mainYellow),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          category.name.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: fontSize,
          ),
        ),
      ),
    ));
  }
}






// class FoodCategoryView extends GetView<FoodCategoryController> {
//   const FoodCategoryView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final orientation = MediaQuery.of(context).orientation;
//     final FoodCategoryController categoryController =
//         Get.put(FoodCategoryController());
//     final horizontalPadding = size.width * 0.04;
//     final FoodCategoryController homeController =
//         Get.put(FoodCategoryController());
//     final crossAxisCount = orientation == Orientation.portrait ? 2 : 3;
//     final gridSpacing = size.width * 0.02;
//
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(size.height * 0.08),
//         child: AppBar(
//           leading: const Icon(Icons.chevron_left),
//           backgroundColor: mainYellow,
//           title: const Text("Category"),
//           centerTitle: true,
//           actions: const [
//             Padding(
//               padding: EdgeInsets.only(right: 15.0),
//               child: Icon(Icons.chevron_right),
//             )
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: size.height * 0.02),
//               // Search Field
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 600),
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                       hintText: "Search",
//                       hintStyle: TextStyle(fontSize: size.width * 0.04),
//                       suffixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide:
//                             const BorderSide(width: 2, color: Colors.grey),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: size.width * 0.04,
//                         vertical: size.height * 0.015,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: size.height * 0.02),
//               SizedBox(
//                 height: size.height * 0.07,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                   itemCount: controller.menuItemCategory.value.length,
//                   itemBuilder: (context, index) {
//                     return CategoryTile(
//                         controller.menuItemCategory.value[index], size);
//                   },
//                 ),
//               ),
//               SizedBox(height: size.height * 0.02),
//               Obx(() {
//                 if (controller.isLoading.value) {
//                   return Center(child: Skelton());
//                 }
//
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       double itemWidth = (constraints.maxWidth -
//                               (gridSpacing * (crossAxisCount - 1))) /
//                           crossAxisCount;
//                       double aspectRatio = itemWidth / (itemWidth * 1.2);
//                       return GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: crossAxisCount,
//                           crossAxisSpacing: gridSpacing,
//                           mainAxisSpacing: gridSpacing,
//                           childAspectRatio: aspectRatio,
//                         ),
//                         itemCount: homeController.foodItems.length,
//                         itemBuilder: (context, index) {
//                           return CardMain(
//                               foodItem: homeController.foodItems[index]);
//                         },
//                       );
//                     },
//                   ),
//                 );
//               }),
//
//               Obx(() {
//                 if (controller.isLoading.value) {
//                   return Center(child: Skelton());
//                 }
//
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       double itemWidth = (constraints.maxWidth -
//                           (gridSpacing * (crossAxisCount - 1))) /
//                           crossAxisCount;
//                       double aspectRatio = itemWidth / (itemWidth * 1.2);
//                       return GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: crossAxisCount,
//                           crossAxisSpacing: gridSpacing,
//                           mainAxisSpacing: gridSpacing,
//                           childAspectRatio: aspectRatio,
//                         ),
//                         itemCount: homeController.allFoodItems.length,
//                         itemBuilder: (context, index) {
//                           return CardMain(
//                               foodItem: homeController.allFoodItems[index]);
//                         },
//                       );
//                     },
//                   ),
//                 );
//               }),
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CategoryTile extends StatelessWidget {
//   final MenuCategory category;
//   final Size size;
//
//   const CategoryTile(this.category, this.size, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final categoryController = Get.find<FoodCategoryController>();
//     final tileWidth = size.width * 0.22;
//     final tileHeight = size.height * 0.05;
//     final fontSize = size.width * 0.035;
//     return Obx(() => GestureDetector(
//           onTap: () {
//             categoryController.setCategory(category
//                 .id);
//           },
//           child: Container(
//             margin: EdgeInsets.only(right: size.width * 0.02),
//             height: tileHeight,
//             width: tileWidth,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color:
//                   categoryController.selectedCategoryIndex.value == category.id
//                       ? mainYellow
//                       : Colors.transparent,
//               border: Border.all(width: 2, color: mainYellow),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               category.name.toString(),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 fontSize: fontSize,
//               ),
//             ),
//           ),
//         ));
//   }
// }
