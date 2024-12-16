import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/filter_view.dart';
import 'package:wayli/app/core/widgets/outlet_list_row.dart';
import 'package:wayli/app/core/widgets/popup_layout.dart';

class OutletListView extends StatefulWidget {
  final Map FIL;
  const OutletListView({super.key, required this.FIL});

  @override
  State<OutletListView> createState() => _OutletListViewState();
}

class _OutletListViewState extends State<OutletListView> {

  List outletArr = [
    {
      "name": "Lombar Pizza",
      "address": "East 46th Street",
      "category": "Pizza, Italian",
      "image": "assets/images/l1.png",
      "time": "11:30AM to 11:00PM",
      "rate": 4.8
    },
    {
      "name": "Sushi Bar",
      "address": "210 Salt Pond Rd.",
      "category": "Sushi, Japan",
      "image": "assets/images/l2.png",
      "time": "11:30AM to 11:00PM",
      "rate": 3.8
    },
    {
      "name": "Steak House",
      "address": "East 46th Street",
      "category": "Steak, American",
      "image": "assets/images/l3.png",
      "time": "11:30AM to 11:00PM",
      "rate": 2.8
    },
    {
      "name": "Seafood Lee",
      "address": "210 Salt Pond Rd.",
      "category": "Seafood, Spain",
      "image": "assets/images/t1.png",
      "time": "11:30AM to 11:00PM",
      "rate": 5.0
    },
    {
      "name": "Egg Tomato",
      "address": "East 46th Street",
      "category": "Egg, Italian",
      "image": "assets/images/t2.png",
      "time": "11:30AM to 11:00PM",
      "rate": 4.8
    },
    {
      "name": "Burger Hot",
      "address": "East 46th Street",
      "category": "Pizza, Italian",
      "image": "assets/images/t3.png",
      "time": "11:30AM to 11:00PM",
      "rate": 4.8
    }
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
return [
  SliverAppBar(
    backgroundColor: secondaryColor.withOpacity(0.5),
    elevation: 0,
    expandedHeight: media.width * 0.660,
    floating: false,
    centerTitle: false,
    pinned: true,
    automaticallyImplyLeading: false,

    flexibleSpace: FlexibleSpaceBar(
      title: Container(
        width: media.width,
        height: media.width * 0.667,
        color: secondaryColor.withOpacity(0.5),
        child: Container(
          padding: EdgeInsets.only(top: media.width * 0.25),
          height: media.width * 0.8,
          alignment: Alignment.center,
          child: Image.asset(
            widget.FIL["image"].toString(),
            width: media.width * 0.25,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    ),
    actions: [
      IconButton(
      icon: SvgPicture.asset(
        "assets/svg/back_1.svg",
        width: 24,
        height: 30,
        color: primaryColor,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    ],
  ),
];
        },


        
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            
              ListView.builder(
                  itemCount: outletArr.length,
                  itemBuilder: (context, index) {
                    var FIL = outletArr[index] as Map? ?? {};
                    return OutletListRow(
                      FIL: FIL,
                    );
                  }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: AutoSizeText(
                      "${ widget.FIL["outlets"] } Outlets",
                      style: GoogleFonts.montserrat(
                          color: secondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context, PopupLayout(child: const FilterView()));
                    },
                    child: AutoSizeText(
                      "Filter",
                      style: GoogleFonts.montserrat(
                          color: secondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
