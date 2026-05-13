import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/modules/customer/registration/registration_view.dart';
import 'package:wayli/app/modules/login/login_view.dart';

import '../../newpages/components/colors.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  static const String routeName = '/profile';
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authController.isLoggedIn.value) {
        authController.fetchUserProfile();
      }
    });

    return Obx(() {
      if (!authController.isLoggedIn.value) {
        return _buildGuestScaffold(context);
      }

      return _buildAuthenticatedScaffold(context, authController);
    });
  }

  Scaffold _buildGuestScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Account',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: mainYellow,
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Browse First, Sign In When You Are Ready',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'You can explore the menu and build your cart without an account. Sign in only when you want to checkout, track orders, or manage your profile.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => const LoginView()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Get.to(() => RegistrationView()),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: secondaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: secondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Create Account',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SectionHeader(title: 'Support'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.contact_support_outlined),
                  title: Text('Contact Us', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Get.toNamed('/contact-us'),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text('Terms & Privacy', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Get.toNamed('/terms-privacy'),
                ),
                ListTile(
                  leading: const Icon(Icons.question_answer_outlined),
                  title: Text('FAQ', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Get.toNamed('/faq'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Scaffold _buildAuthenticatedScaffold(
    BuildContext context,
    AuthController authController,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Account',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
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
                          final nameParts =
                              authController.userName.value.split(' ');
                          if (nameParts.isNotEmpty &&
                              nameParts.first.isNotEmpty) {
                            initials += nameParts.first[0].toUpperCase();
                          }
                          if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
                            initials += nameParts[1][0].toUpperCase();
                          }
                        }
                        if (initials.isEmpty) {
                          initials = 'U';
                        }
                        return CircleAvatar(
                          radius: 40,
                          backgroundColor: mainYellow,
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          ),
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
                  Obx(
                    () => Text(
                      authController.userName.value.isNotEmpty
                          ? authController.userName.value
                          : "N/A",
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                    ),
                  ),
                  Obx(
                    () => Text(
                      authController.userEmail.value.isNotEmpty
                          ? authController.userEmail.value
                          : "N/A",
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                    ),
                  ),
                  Obx(
                    () => Text(
                      authController.userPhone.value.isNotEmpty
                          ? 'Phone: ${authController.userPhone.value}'
                          : 'Phone: N/A',
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => Get.toNamed('/profile-edit'),
                      child: Text(
                        'Edit Profile',
                        style: GoogleFonts.poppins(
                          color: Colors.red[400],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SectionHeader(title: 'Contact Us'),
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
                  onTap: () => Get.toNamed('/contact-us'),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text('Terms & Privacy', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Get.toNamed('/terms-privacy'),
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Privacy & Security'),
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
                  onTap: () => Get.toNamed('/change-password'),
                ),
                ListTile(
                  leading: const Icon(Icons.question_answer_outlined),
                  title: Text('FAQ', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Get.toNamed('/faq'),
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Account'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red[400]),
                  title: Text(
                    'Logout',
                    style: GoogleFonts.poppins(color: Colors.red[400]),
                  ),
                  onTap: authController.logout,
                ),
                const Divider(height: 0),
                ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red[400]),
                  title: Text(
                    'Delete Account',
                    style: GoogleFonts.poppins(color: Colors.red[400]),
                  ),
                  onTap: () {
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
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );
                                await authController.deleteAccount();
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
