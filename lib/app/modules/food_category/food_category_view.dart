import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../newpages/components/colors.dart';
import 'food_category_controller.dart';

class FoodCategoryView extends GetView<FoodCategoryController> {
  const FoodCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final FoodCategoryController categoryController = Get.put(FoodCategoryController());
    final horizontalPadding = size.width * 0.04;

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
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.02),
              // Search Field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
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
              // Horizontal Category List
              SizedBox(
                height: size.height * 0.07,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  children: List.generate(8, (index) {
                    return CategoryTile(index, size);
                  }),
                ),
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}




class CategoryTile extends StatelessWidget {
  final int index;
  final Size size;

  const CategoryTile(this.index, this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<FoodCategoryController>();

    final tileWidth = size.width * 0.22;
    final tileHeight = size.height * 0.05;
    final fontSize = size.width * 0.035;

    return Obx(() => GestureDetector(
      onTap: () {
        categoryController.selectedCategoryIndex.value = index;
      },
      child: Container(
        margin: EdgeInsets.only(right: size.width * 0.02),
        height: tileHeight,
        width: tileWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: categoryController.selectedCategoryIndex.value == index
              ? mainYellow
              : Colors.transparent,
          border: Border.all(width: 2, color: mainYellow),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Category $index',
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
