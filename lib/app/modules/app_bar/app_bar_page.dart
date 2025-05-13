import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/core/config/constants.dart';

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
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/way-li_logo.png',
                  width: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Obx(() => AutoSizeText(
                      authController.userName.value.isNotEmpty
                          ? authController.userName.value
                          : "N/A",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        color: secondaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                const SizedBox(height: 4),
                Obx(() => AutoSizeText(
                      authController.userEmail.value.isNotEmpty
                          ? authController.userEmail.value
                          : "N/A",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        color: secondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ],
            ),
          ),

          // Top menu items
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.swap_horiz),
                  title: const Text('Transactions'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Bottom menu items
          Column(
            children: [
              const Divider(),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  // Add logout logic here
                  authController.logout(); // Assuming you have this method
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ],
      ),
    );
  }
}
