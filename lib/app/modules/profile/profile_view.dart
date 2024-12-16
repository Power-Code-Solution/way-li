import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/profile_list_item/profile_list_item_page.dart';

import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  static const String routeName = '/profile';
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    ScreenUtil.init(context,
        designSize: Size(414, 896), minTextAdapt: true, splitScreenMode: true);

    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Icon(
              LineAwesomeIcons.long_arrow_alt_left_solid,
              color: primaryColor,
              size: ScreenUtil().setSp(kSpacingUnit.w * 7),
            ),
          ),
          Container(
            height: kSpacingUnit.w * 10,
            width: kSpacingUnit.w * 10,
            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: kSpacingUnit.w * 5,
                    backgroundImage: AssetImage('assets/images/food.png'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: kSpacingUnit.w * 2.5,
                    width: kSpacingUnit.w * 2.5,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: kSpacingUnit.w * 1.5,
                      widthFactor: kSpacingUnit.w * 1.5,
                      child: Icon(
                        LineAwesomeIcons.pen_alt_solid,
                        color: secondaryColor,
                        size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                Obx(() => AutoSizeText(
                      authController.userName.value.isNotEmpty
                          ? authController.userName.value
                          : "N/A",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                          color: primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    )),
                Obx(() => AutoSizeText(
                      authController.userEmail.value.isNotEmpty
                          ? authController.userEmail.value
                          : "N/A",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                          color: kWhiteColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    )),
              ],
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
        ],
      ),
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/piza.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  profileInfo,
                ],
              ),

              // header,
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/images/black-bg1.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  children: <Widget>[
                    ProfileListItemPage(
                      icon: LineAwesomeIcons.money_bill_alt,
                      text: 'Payment Setup',
                    ),
                    ProfileListItemPage(
                      icon: LineAwesomeIcons.history_solid,
                      text: 'Order History',
                    ),
                    ProfileListItemPage(
                      icon: LineAwesomeIcons.lock_open_solid,
                      text: 'Privacy',
                    ),
                    ProfileListItemPage(
                      icon: LineAwesomeIcons.user_plus_solid,
                      text: 'Invite a Friend',
                    ),
                    ProfileListItemPage(
                      icon: LineAwesomeIcons.question_circle,
                      text: 'Help & Support',
                    ),
                    Divider(),
                    ProfileListItemPage(
                      icon: LineAwesomeIcons.power_off_solid,
                      text: 'Settings',
                    ),
                    ProfileListItemPage(
                      onPressed: () {
                        authController.logout();
                      },
                      icon: LineAwesomeIcons.sign_out_alt_solid,
                      text: 'Logout',
                      hasNavigation: false,
                    ),
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
