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
          // Profile Section
          SectionHeader(title: 'Profile'),
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
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: mainYellow,
                        child: Text('U',
                            style:
                            TextStyle(fontSize: 32, color: Colors.white)),
                      ),
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
                    authController.userName.value.isNotEmpty
                        ? authController.userEmail.value
                        : "N/A",
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  )),
                  Text(
                    'Phone: ***********70',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {},
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
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text('Terms & Privacy', style: GoogleFonts.poppins()),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text('Privacy Policy', style: GoogleFonts.poppins()),
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
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title:
                  Text('Enable Biometrics', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_outline),
                  title:
                  Text('Favorite Location', style: GoogleFonts.poppins()),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_outline),
                  title: Text('FAQ', style: GoogleFonts.poppins()),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_outline),
                  title: Text('Setting', style: GoogleFonts.poppins()),
                  onTap: () {
                    Get.to(() => SettingsView());
                  },
                ),
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
                  leading: Icon(Icons.delete_outline, color: Colors.red[400]),
                  title: Text('Delete Account',
                      style: GoogleFonts.poppins(color: Colors.red[400])),
                  onTap: () {},
                ),
                const Divider(height: 0),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red[400]),
                  title: Text('Logout',
                      style: GoogleFonts.poppins(color: Colors.red[400])),
                  onTap: () {},
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



// @override
  // Widget build(BuildContext context) {
  //   final AuthController authController = Get.put(AuthController());
  //   ScreenUtil.init(context,
  //       designSize: Size(414, 896), minTextAdapt: true, splitScreenMode: true);
  //
  //   var profileInfo = Expanded(
  //     child: Column(
  //       children: <Widget>[
  //         Container(
  //           margin: EdgeInsets.all(10),
  //           alignment: Alignment.centerLeft,
  //           child: Icon(
  //             LineAwesomeIcons.long_arrow_alt_left_solid,
  //             color: primaryColor,
  //             size: ScreenUtil().setSp(kSpacingUnit.w * 7),
  //           ),
  //         ),
  //         Container(
  //           height: kSpacingUnit.w * 10,
  //           width: kSpacingUnit.w * 10,
  //           margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
  //           child: Stack(
  //             children: <Widget>[
  //               Container(
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   border: Border.all(
  //                     color: Colors.white,
  //                     width: 3,
  //                   ),
  //                 ),
  //                 child: CircleAvatar(
  //                   radius: kSpacingUnit.w * 5,
  //                   backgroundImage: AssetImage('assets/images/food.png'),
  //                   backgroundColor: Colors.transparent,
  //                 ),
  //               ),
  //               Align(
  //                 alignment: Alignment.bottomRight,
  //                 child: Container(
  //                   height: kSpacingUnit.w * 2.5,
  //                   width: kSpacingUnit.w * 2.5,
  //                   decoration: BoxDecoration(
  //                     color: primaryColor,
  //                     shape: BoxShape.circle,
  //                   ),
  //                   child: Center(
  //                     heightFactor: kSpacingUnit.w * 1.5,
  //                     widthFactor: kSpacingUnit.w * 1.5,
  //                     child: Icon(
  //                       LineAwesomeIcons.pen_alt_solid,
  //                       color: secondaryColor,
  //                       size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: kSpacingUnit.w * 2),
  //         Container(
  //           padding: const EdgeInsets.all(10),
  //           decoration: BoxDecoration(
  //               color: secondaryColor.withOpacity(0.5),
  //               borderRadius: BorderRadius.all(Radius.circular(10))),
  //           child: Column(
  //             children: [
  //               Obx(() => AutoSizeText(
  //                     authController.userName.value.isNotEmpty
  //                         ? authController.userName.value
  //                         : "N/A",
  //                     textAlign: TextAlign.left,
  //                     style: GoogleFonts.montserrat(
  //                         color: primaryColor,
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.w700),
  //                   )),
  //               Obx(() => AutoSizeText(
  //                     authController.userEmail.value.isNotEmpty
  //                         ? authController.userEmail.value
  //                         : "N/A",
  //                     textAlign: TextAlign.left,
  //                     style: GoogleFonts.montserrat(
  //                         color: kWhiteColor,
  //                         fontSize: 15,
  //                         fontWeight: FontWeight.w700),
  //                   )),
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: kSpacingUnit.w * 2),
  //       ],
  //     ),
  //   );
  //
  //   return Scaffold(
  //       resizeToAvoidBottomInset: false,
  //       body: Container(
  //         width: double.infinity,
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //             image: AssetImage('assets/images/piza.jpg'),
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         child: Column(
  //           children: <Widget>[
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 profileInfo,
  //               ],
  //             ),
  //
  //             // header,
  //             Expanded(
  //                 child: Container(
  //               decoration: BoxDecoration(
  //                 // color: Colors.white,
  //                 image: DecorationImage(
  //                   image: AssetImage('assets/images/black-bg1.jpg'),
  //                   fit: BoxFit.cover,
  //                 ),
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(30),
  //                   topRight: Radius.circular(30),
  //                 ),
  //               ),
  //               child: ListView(
  //                 children: <Widget>[
  //                   ProfileListItemPage(
  //                     icon: LineAwesomeIcons.money_bill_alt,
  //                     text: 'Payment Setup',
  //                   ),
  //                   ProfileListItemPage(
  //                     icon: LineAwesomeIcons.history_solid,
  //                     text: 'Order History',
  //                   ),
  //                   ProfileListItemPage(
  //                     icon: LineAwesomeIcons.lock_open_solid,
  //                     text: 'Privacy',
  //                   ),
  //                   ProfileListItemPage(
  //                     icon: LineAwesomeIcons.user_plus_solid,
  //                     text: 'Invite a Friend',
  //                   ),
  //                   ProfileListItemPage(
  //                     icon: LineAwesomeIcons.question_circle,
  //                     text: 'Help & Support',
  //                   ),
  //                   Divider(),
  //                   ProfileListItemPage(
  //                     icon: LineAwesomeIcons.power_off_solid,
  //                     text: 'Settings',
  //                     onPressed: () {
  //                       Get.to(() => SettingsView());
  //                     },
  //                   ),
  //                   ProfileListItemPage(
  //                     onPressed: () {
  //                       authController.logout();
  //                     },
  //                     icon: LineAwesomeIcons.sign_out_alt_solid,
  //                     text: 'Logout',
  //                     hasNavigation: false,
  //                   ),
  //                 ],
  //               ),
  //             ))
  //           ],
  //         ),
  //       ));
  // }
  //






