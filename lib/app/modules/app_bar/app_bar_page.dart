import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/core/config/constants.dart';

import '../login/login_controller.dart';
import 'app_bar_controller.dart';



class AppBarPage extends GetView<AppBarController> {
  const AppBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    final LoginController loginController = Get.put(LoginController());

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
                  'assets/images/way-li-logo.png',
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

              Obx(() => SwitchListTile(
                secondary: const Icon(Icons.fingerprint),
                title: const Text('Fingerprint Login'),
                value: loginController.showFingerprint.value,
                activeColor: primaryColor,
                activeTrackColor: secondaryColor,
                onChanged: (bool newValue) async {
                  final prefs = await SharedPreferences.getInstance();

                  if (newValue) {
                    // 👉 User is enabling fingerprint
                    final localAuth = LocalAuthentication();
                    try {
                      bool didAuthenticate = await localAuth.authenticate(
                        localizedReason:
                        'Confirm your identity to enable fingerprint login',
                        options: const AuthenticationOptions(biometricOnly: false),
                      );

                      if (didAuthenticate) {
                        await prefs.setBool('is_fingerprint_enabled', true);
                        loginController.showFingerprint.value = true;
                        Get.snackbar('Enabled', 'Fingerprint login enabled');
                      } else {
                        Get.snackbar('Cancelled', 'Authentication cancelled');
                      }
                    } catch (e) {
                      Get.snackbar('Error', 'Failed to authenticate: $e');
                    }
                  } else {
                    // ⚠️ User is disabling fingerprint
                    bool confirm = await Get.dialog(
                      AlertDialog(
                        title: Text("Disable Fingerprint Login?"),
                        content:
                        AutoSizeText("Are you sure you want to turn off fingerprint login?", style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),),
                        actions: [
                          TextButton(
                              onPressed: () => Get.back(result: false),
                              child:  Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                  ),
                  child: AutoSizeText(
                  "Cancel",
                  style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  ),
                  ),
                  ),),
                          TextButton(
                              onPressed: () => Get.back(result: true),
                              child:Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(8),
                  ),
                  child: AutoSizeText(
                  "Yes",
                  style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  ),
                  ),
                  )),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await prefs.setBool('is_fingerprint_enabled', false);
                      loginController.showFingerprint.value = false;
                      Get.snackbar('Disabled', 'Fingerprint login disabled');
                    }
                  }
                },
              )),




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
