import 'package:flutter/material.dart';
import 'package:wayli/app/newpages/components/colors.dart';

// Custom widget for category items

class CategoryTile extends StatelessWidget {
  final String categoryName;

  const CategoryTile(this.categoryName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 88,
      height: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: mainYellow),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        categoryName,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
