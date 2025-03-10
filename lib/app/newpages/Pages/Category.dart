import 'package:flutter/material.dart';
import 'package:wayli/app/newpages/components/Card.dart';
import 'package:wayli/app/newpages/components/colors.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  int? selectedCategoryIndex;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    // Calculate dynamic grid properties
    final crossAxisCount = orientation == Orientation.portrait ? 2 : 3;
    final horizontalPadding = size.width * 0.04;
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
                  children: [
                    CategoryTile("Pizza", 0, size),
                    CategoryTile("Burgers", 1, size),
                    CategoryTile("Pasta", 2, size),
                    CategoryTile("Drinks", 3, size),
                    CategoryTile("Pizza", 4, size),
                    CategoryTile("Burgers", 5, size),
                    CategoryTile("Pasta", 6, size),
                    CategoryTile("Drinks", 7, size),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),

              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget CategoryTile(String categoryName, int index, Size size) {
    final tileWidth = size.width * 0.22;
    final tileHeight = size.height * 0.05;
    final fontSize = size.width * 0.035;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategoryIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: size.width * 0.02),
        height: tileHeight,
        width: tileWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              selectedCategoryIndex == index ? mainYellow : Colors.transparent,
          border: Border.all(width: 2, color: mainYellow),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          categoryName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
