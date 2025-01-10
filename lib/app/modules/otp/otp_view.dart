import 'package:pinput/pinput.dart';
import 'package:wayli/app/modules/login/login_view.dart';
import 'package:wayli/app/modules/otp/otp_controller.dart';
import 'package:wayli/app/modules/otp/otp_view.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/custom_input.dart';
import 'package:wayli/app/modules/customer/registration/registration_view.dart';
import 'package:wayli/app/modules/home/home_view.dart';
import 'package:wayli/app/modules/tabs/tabs_view.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});
  static const String routeName = '/otp';
  static final GlobalKey otpBottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const focusedBorderColor = primaryColor;
    // const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = secondaryColor;
    // const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = kWhiteColor;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle:  GoogleFonts.montserrat(
        fontSize: 22,
        color: kWhiteColor,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<OtpController>(
        init: OtpController(),
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
                                "Validate OTP",
                                style: GoogleFonts.montserrat(
                                    color: primaryColor,
                                    fontSize: 20,
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
                      key: ctl.otpKey,
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
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Directionality(
                                                textDirection:
                                                    TextDirection.ltr,
                                                child: Pinput(
                                                  controller:
                                                      controller.pinController,
                                                  focusNode:
                                                      controller.focusNode,
                                                  defaultPinTheme:
                                                      defaultPinTheme,
                                                  separatorBuilder: (index) =>
                                                      const SizedBox(width: 8),
                                                  validator: (value) {
                                                    return value == '2222'
                                                        ? null
                                                        : 'Pin is incorrect';
                                                  },
                                                  hapticFeedbackType:
                                                      HapticFeedbackType
                                                          .lightImpact,
                                                  onCompleted: (pin) {
                                                    debugPrint(
                                                        'onCompleted: $pin');
                                                  },
                                                  onChanged: (value) {
                                                    debugPrint(
                                                        'onChanged: $value');
                                                  },
                                                  cursor: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 9),
                                                        width: 22,
                                                        height: 1,
                                                        color:
                                                            focusedBorderColor,
                                                      ),
                                                    ],
                                                  ),
                                                  focusedPinTheme:
                                                      defaultPinTheme.copyWith(
                                                    decoration: defaultPinTheme
                                                        .decoration!
                                                        .copyWith(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      border: Border.all(
                                                          color:
                                                              focusedBorderColor),
                                                    ),
                                                  ),
                                                  submittedPinTheme:
                                                      defaultPinTheme.copyWith(
                                                    decoration: defaultPinTheme
                                                        .decoration!
                                                        .copyWith(
                                                      color: fillColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      border: Border.all(
                                                          color:
                                                              focusedBorderColor),
                                                    ),
                                                  ),
                                                  errorPinTheme: defaultPinTheme
                                                      .copyBorderWith(
                                                    border: Border.all(
                                                        color:
                                                            Colors.redAccent),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                                        "Validate",
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
