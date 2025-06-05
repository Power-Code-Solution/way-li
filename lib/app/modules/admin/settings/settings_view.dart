// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // import 'settings_controller.dart';

// // class SettingsView extends GetView<SettingsController> {
// //   const SettingsView({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('SettingsView'),
// //         centerTitle: true,
// //       ),
// //       body: const Center(
// //         child: Text(
// //           'SettingsView is working',
// //           style: TextStyle(fontSize: 20),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:wayli/app/core/config/constants.dart';
// import 'package:wayli/app/modules/admin/settings/add_food_items/add_food_items_view.dart';
// import 'package:wayli/app/modules/admin/settings/allergens/allergens_view.dart';
// import 'package:wayli/app/modules/admin/settings/ingredents/ingredents_view.dart';
// import 'package:wayli/app/modules/admin/settings/menu/menu_view.dart';
// import 'package:wayli/app/modules/admin/settings/menu_category/menu_category_view.dart';
// import 'package:wayli/app/modules/admin/settings/settings_controller.dart';
// import 'package:wayli/app/modules/admin/settings/tags/tags_view.dart';
// import 'package:wayli/app/modules/admin/settings/users/users_view.dart';

// class SettingsView extends GetView<SettingsController> {
//   const SettingsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 6,
//       child: Scaffold(
//         backgroundColor: secondaryColor,
//         appBar: AppBar(
//           backgroundColor: secondaryColor,
//           elevation: 0,
//           centerTitle: true,
//           leading: IconButton(
//             icon: SvgPicture.asset(
//               'assets/svg/arrow_back.svg',
//               color: kWhiteColor,
//               height: 30,
//               width: 30,
//             ),
//             onPressed: () {
//               Get.back();
//             },
//           ),
//           title: AutoSizeText(
//             "SETTINGS",
//             style: GoogleFonts.poppins(color: kWhiteColor, fontSize: 15),
//             minFontSize: 15,
//             maxFontSize: 15,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(50.0),
//             child: Container(
//               color: secondaryColor,
//               child: TabBar(
//                 labelPadding: const EdgeInsets.symmetric(horizontal: 5),
//                 indicator: ShapeDecoration(
//                   color: kSecondaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                 ),
//                 labelColor: Colors.white,
//                 labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                 unselectedLabelColor: Colors.white54,
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 tabs: const [
//                   Tab(text: '    Foodies  '),
//                   Tab(text: '    Menu     '),
//                   Tab(text: 'Menu Category'),
//                   Tab(text: '    Tags     '),
//                   Tab(text: '    Allergens '),
//                   Tab(text: '    Ingredents'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             Center(child: AddFoodItemsView()),
//             Center(child: MenuView()),
//             Center(child: MenuCategoryView()),
//             Center(child: TagsView()),
//             Center(child: AllergensView()),
//             Center(child: IngredentsView()),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/modules/admin/settings/add_food_items/add_food_items_view.dart';
import 'package:wayli/app/modules/admin/settings/allergens/allergens_view.dart';
import 'package:wayli/app/modules/admin/settings/ingredents/ingredents_view.dart';
import 'package:wayli/app/modules/admin/settings/menu/menu_view.dart';
import 'package:wayli/app/modules/admin/settings/menu_category/menu_category_view.dart';
import 'package:wayli/app/modules/admin/settings/tags/tags_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Update the state when the tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/svg/arrow_back.svg',
            color: kWhiteColor,
            height: 30,
            width: 30,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: AutoSizeText(
          _getAppBarTitle(),
          style: GoogleFonts.poppins(color: kWhiteColor, fontSize: 15),
          minFontSize: 15,
          maxFontSize: 15,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: secondaryColor,
            child: TabBar(
              controller: _tabController,
              labelPadding: const EdgeInsets.symmetric(horizontal: 5),
              indicator: ShapeDecoration(
                color: kSecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              labelColor: Colors.white,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.white54,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              tabs: const [
                Tab(text: '    Foodies  '),
                Tab(text: '    Menu     '),
                Tab(text: 'Menu Category'),
                Tab(text: '    Tags     '),
                Tab(text: '    Allergens '),
                Tab(text: '    Ingredients'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: AddFoodItemsView()),
          Center(child: MenuView()),
          Center(child: MenuCategoryView()),
          Center(child: TagsView()),
          Center(child: AllergensView()),
          Center(child: IngredentsView()),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    return switch (_tabController.index) {
      0 => "Foodies",
      1 => "Menu",
      2 => "Menu Category",
      3 => "Tags",
      4 => "Allergens",
      5 => "Ingredients",
      _ => "Settings",
    };
  }
}
