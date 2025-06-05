//
// class TabsView extends GetView<TabsController> {
//   static String routeName = "/tabs";
//    final GlobalKey bottomNavigationKey;
//   const TabsView({super.key, required this.bottomNavigationKey});
//
//   @override
//   Widget build(BuildContext context) {
// final List<String> iconPaths = [
//       'assets/svg/dashboard.svg',
//       'assets/svg/favourite.svg',
//       'assets/svg/history.svg',
//       'assets/svg/setting.svg',
//     ];
//
// final List<Widget> screens = [
//    const HomeView(),
//   const FavouriteFoodView(),
//   // const MenuView(),
//   const Homepage(),
//   // const ProfileView()
//   const BottomBarMain()
//     ];
//    final TabsController tabsController = Get.put(TabsController());
//      return Scaffold(
//       extendBody: true,
//       floatingActionButton: Padding(
//       padding: const EdgeInsets.all(0),
//
//       child: FloatingActionButton(
//         backgroundColor: primaryColor,
//         shape: const CircleBorder(),
//         onPressed: () {
//           Get.to( HistoryView());
//         },
//
//         child: SvgPicture.asset(
//           'assets/svg/addition.svg',
//           color: secondaryColor,
//           height: 30,
//           width: 30,
//         ),
//       ),
//             ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       body: Obx(() => screens[tabsController.selectedIndex.value]),
//       bottomNavigationBar: CurvedNavigationBar(
//         backgroundColor: Colors.transparent,
//         color: secondaryColor,
//         key: bottomNavigationKey,
//         items: List<Widget>.generate(iconPaths.length, (index) {
//           return SvgPicture.asset(
//             iconPaths[index],
//             height: 30,
//             width: 30,
//             color: primaryColor,
//           );
//         }),
//         onTap: (index) {
//           tabsController.selectedIndex.value = index;
//         },
//       ),
//     );
//   }
// }
