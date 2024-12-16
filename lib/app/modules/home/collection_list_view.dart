import 'package:flutter/material.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/collection_food_item_cell.dart';


class CollectionListView extends StatefulWidget {
  const CollectionListView({super.key});

  @override
  State<CollectionListView> createState() => _CollectionListViewState();
}

class _CollectionListViewState extends State<CollectionListView> {
  List collectionsArr = [
    {"name": "Legendary food", "place": "34", "image": "assets/images/c1.png"},
    {"name": "Seafood", "place": "28", "image": "assets/images/c2.png"},
    {"name": "Fizza Meli", "place": "56", "image": "assets/images/c3.png"},
    {"name": "Legendary food", "place": "34", "image": "assets/images/c1.png"},
    {"name": "Seafood", "place": "28", "image": "assets/images/c2.png"},
    {"name": "Fizza Meli", "place": "56", "image": "assets/images/c3.png"},
    {"name": "Legendary food", "place": "34", "image": "assets/images/c1.png"},
    {"name": "Seafood", "place": "28", "image": "assets/images/c2.png"},
    {"name": "Fizza Meli", "place": "56", "image": "assets/images/c3.png"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              pinned: true,
              floating: false,
              centerTitle: false,
              leading: IconButton(
                icon: Image.asset(
                  "assets/images/back.png",
                  width: 24,
                  height: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Collections",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "By Way Li Restaurant",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ];
        },
        body: GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                childAspectRatio: 0.7,
                mainAxisSpacing: 0),
            itemCount: collectionsArr.length,
            itemBuilder: (context, index) {
              var FIL = collectionsArr[index] as Map? ?? {};

              return CollectionFoodItemCell(
                FIL: FIL,
                isGrid: true,
              );
            }),
      ),
    );
  }
}
