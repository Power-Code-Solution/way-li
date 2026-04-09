import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/modules/admin/settings/settings_view.dart';

import '../../newpages/components/colors.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  static const String routeName = '/profile';
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final AuthController authController = Get.put(AuthController());

    // Fetch the latest user profile data when the view is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.fetchUserProfile();
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(() {
                        String initials = '';
                        if (authController.userName.value.isNotEmpty) {
                          List<String> nameParts = authController.userName.value.split(' ');
                          if (nameParts.isNotEmpty) {
                            if (nameParts[0].isNotEmpty) {
                              initials += nameParts[0][0].toUpperCase();
                            }
                            if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
                              initials += nameParts[1][0].toUpperCase();
                            }
                          }
                        }
                        if (initials.isEmpty) {
                          initials = 'U';
                        }
                        return CircleAvatar(
                          radius: 40,
                          backgroundColor: mainYellow,
                          child: Text(initials,
                              style:
                              const TextStyle(fontSize: 32, color: Colors.white)),
                        );
                      }),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: mainYellow,
                        child: IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 12),

              Obx(() => Text(
                authController.userName.value.isNotEmpty
                    ? authController.userName.value
                    : "N/A",
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  )),
                  Obx(() => Text(
                    authController.userEmail.value.isNotEmpty
                        ? authController.userEmail.value
                        : "N/A",
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  )),
                  Obx(() => Text(
                    authController.userPhone.value.isNotEmpty
                        ? 'Phone: ${authController.userPhone.value}'
                        : 'Phone: N/A',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  )),

                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed('/profile-edit');
                      },
                      child: Text('Edit Profile',
                          style: GoogleFonts.poppins(
                              color: Colors.red[400], fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Notifications Section
          SectionHeader(title: 'Contact Us'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: Text('Contact Us', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.toNamed('/contact-us');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text('Terms & Privacy', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.toNamed('/terms-privacy');
                  },
                )
              ],
            ),
          ),

          // Privacy & Security Section
          SectionHeader(title: 'Privacy & Security'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: Text('Change Password', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.toNamed('/change-password');
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.favorite_outline),
                //   title:
                //   Text('Favorite Location', style: GoogleFonts.poppins()),
                //   onTap: () {},
                // ),
                ListTile(
                  leading: const Icon(Icons.question_answer_outlined),
                  title: Text('FAQ', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.toNamed('/faq');
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.favorite_outline),
                //   title: Text('Setting', style: GoogleFonts.poppins()),
                //   onTap: () {
                //     Get.to(() => SettingsView());
                //   },
                // ),
              ],
            ),
          ),

          // Account Section
          SectionHeader( title: 'Account'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red[400]),
                  title: Text('Logout',
                      style: GoogleFonts.poppins(color: Colors.red[400])),
                  onTap: () {
                    authController.logout();
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red[400]),
                  title: Text('Delete Account',
                      style: GoogleFonts.poppins(color: Colors.red[400])),
                  onTap: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Delete Account",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[400],
                            ),
                          ),
                          content: Text(
                            "Are you sure you want to delete your account? This action cannot be undone.",
                            style: GoogleFonts.poppins(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                // Close the dialog
                                Navigator.of(context).pop();

                                // Show loading indicator
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );
                                final success = await authController.deleteAccount();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Yes",
                                style: GoogleFonts.poppins(
                                  color: Colors.red[400],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}


class SectionHeader extends StatefulWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  State<SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        widget.title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
