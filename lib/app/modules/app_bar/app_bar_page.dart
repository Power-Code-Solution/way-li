import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/modules/customer/order_history/order_history_view.dart';

import 'app_bar_controller.dart';

class AppBarPage extends GetView<AppBarController> {
  const AppBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return Drawer(
      child: Column(
          children: [
            // Header
            Container(
              color: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/way-li-logo.png',
                    width: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  Obx(() => AutoSizeText(
                    authController.userName.value.isNotEmpty
                        ? authController.userName.value
                        : "N/A",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      color: secondaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
                  const SizedBox(height: 2),
                  Obx(() => AutoSizeText(
                    authController.userEmail.value.isNotEmpty
                        ? authController.userEmail.value
                        : "N/A",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    minFontSize: 10,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      color: secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ],
              ),
            ),
            // Menu
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildListTile(
                    context: context,
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildListTile(
                    context: context,
                    icon: Icons.info,
                    title: 'About',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/about');
                    },
                  ),
                  _buildListTile(
                    context: context,
                    icon: Icons.history,
                    title: 'My Orders',
                    onTap: () => Get.to(
                          () => const OrderHistoryView(),
                      transition: Transition.rightToLeft,
                    ),
                  ),
                  // _buildListTile(
                  //   context: context,
                  //   icon: Icons.swap_horiz,
                  //   title: 'Transactions',
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Get.toNamed('/transactions');
                  //   },
                  // ),
                  const Divider(),
                  // _buildListTile(
                  //   context: context,
                  //   icon: Icons.share,
                  //   title: 'Share',
                  //   onTap: () => Navigator.pop(context),
                  // ),
                  _buildListTile(
                    context: context,
                    icon: Icons.help_outline,
                    title: 'Help',
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/help');
                    },
                  ),
            /*      _buildListTile(
                    context: context,
                    icon: Icons.history,
                    title: 'My Orders',
                    onTap: () => Get.to(
                          () => const OrderHistoryView(),
                      transition: Transition.rightToLeft,
                    ),
                  ),*/
                  _buildListTile(
                    context: context,
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      authController.logout();
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: secondaryColor,
        size: 22,
      ),
      title: AutoSizeText(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        minFontSize: 10,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      dense: true,
    );
  }
}