import 'package:wayli/app/modules/otp/otp_view.dart';

import 'forget_password_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/custom_input.dart';
import 'package:wayli/app/modules/customer/registration/registration_view.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  static const String routeName = '/forget-password';
  const ForgetPasswordView({super.key});
  static final GlobalKey forgetPasswordBottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<ForgetPasswordController>(
        init: ForgetPasswordController(),
        builder: (ctl) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/piza.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Gap(80),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          children: [
                            FadeInUp(
                              duration: Duration(milliseconds: 1000),
                              child: AutoSizeText(
                                "Reset Password",
                                style: GoogleFonts.montserrat(
                                    color: primaryColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            FadeInUp(
                              duration: Duration(milliseconds: 1300),
                              child: AutoSizeText(
                                "Welcome Back",
                                style: GoogleFonts.montserrat(
                                    color: primaryColor, fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Gap(60),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Form(
                      key: ctl.forgetPasswordViewFormKey,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: <Widget>[
                                FadeInUp(
                                  duration: Duration(milliseconds: 1400),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: CostumFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textController: ctl.email,
                                            isPassword: false,
                                            labelText: "Email",
                                            hintText:
                                                "Enter your email address",
                                            icon: const Icon(Icons.email),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please provide email address !';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const Gap(10),
                                      ],
                                    ),
                                  ),
                                ),
                                Gap(20),
                                FadeInUp(
                                  duration: Duration(milliseconds: 1600),
                                  child: MaterialButton(
                                    onPressed: () {
                                      Get.to(() => OtpView());
                                    },
                                    height: 50,
                                    color: secondaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: AutoSizeText(
                                        "Reset Password",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Gap(20),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      FadeInUp(
                                        duration: Duration(milliseconds: 1500),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.toNamed('/login');
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: AutoSizeText(
                                              "Back to Login?",
                                              style: GoogleFonts.montserrat(
                                                  color: kRedColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                              minFontSize: 12,
                                              maxFontSize: 15,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      FadeInUp(
                                        duration: Duration(milliseconds: 1500),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(() => RegistrationView());
                                          },
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: AutoSizeText(
                                              "Sign Up",
                                              style: GoogleFonts.montserrat(
                                                  color: secondaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                              minFontSize: 12,
                                              maxFontSize: 15,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Gap(50),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
