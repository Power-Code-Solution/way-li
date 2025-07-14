import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/custom_input.dart';
import 'package:wayli/app/modules/customer/registration/registration_view.dart';
import 'package:wayli/app/modules/forget_password/forget_password_view.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  static const String routeName = '/login';
  const LoginView({super.key});
  static final GlobalKey loginBottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (ctl) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  secondaryColor.withOpacity(0.2),
                  Colors.white,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                    child: Column(
                      children: [
                        FadeInDown(
                          duration: Duration(milliseconds: 500),
                          child: Image.asset(
                            'assets/images/way-li_logo.png', // Add your logo image
                            height: 100,
                          ),
                        ),
                        Gap(20),
                        FadeInUp(
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            "Welcome Back",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Gap(8),
                        FadeInUp(
                          duration: Duration(milliseconds: 800),
                          child: Text(
                            "Sign in to continue",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 40),
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                        key: ctl.loginViewFormKey,
                        child: ListView(
                          children: [
                            FadeInUp(
                              duration: Duration(milliseconds: 900),
                              child: CostumFormField(
                                keyboardType: TextInputType.emailAddress,
                                textController: ctl.email,
                                isPassword: false,
                                labelText: "Email",
                                hintText: "Enter your email address",
                                icon: Icon(Icons.email_outlined, color: secondaryColor),
                                validator: (value) {
                                  if (value!.isEmpty) return 'Email is required';
                                  return null;
                                },
                              ),
                            ),
                            Gap(16),
                            FadeInUp(
                              duration: Duration(milliseconds: 1000),
                              child: Obx(
                                () => CostumFormField(
                                  textController: ctl.pass,
                                  isPassword: true,
                                  labelText: "Password",
                                  hintText: "Enter your password",
                                  icon: Icon(Icons.lock_outline, color: secondaryColor),
                                  validator: (value) {
                                    if (value!.isEmpty) return 'Password is required';
                                    return null;
                                  },
                                  obscureText: ctl.visiblePassword.value,
                                  suffixIcon: IconButton(
                                    onPressed: () => ctl.togglePasswordVisibility(),
                                    icon: Icon(
                                      ctl.visiblePassword.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Gap(16),
                            FadeInUp(
                              duration: Duration(milliseconds: 1100),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () => Get.to(() => ForgetPasswordView()),
                                    child: Text(
                                      "Forgot Password?",
                                      style: GoogleFonts.poppins(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.to(() => RegistrationView()),
                                    child: Text(
                                      "Sign Up",
                                      style: GoogleFonts.poppins(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(24),
                            FadeInUp(
                              duration: Duration(milliseconds: 1200),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: ctl.isLoading.value ? null : ctl.handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Obx(() => ctl.isLoading.value
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              "LOGIN",
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            )),
                                    ),
                                  ),
                                  if (ctl.showFingerprint.value) ...[
                                    Gap(16),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: secondaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        onPressed: ctl.authenticate,
                                        icon: SvgPicture.asset(
                                          'assets/svg/fingerprint.svg',
                                          color: secondaryColor,
                                          height: 28,
                                        ),
                                      ),
                                    ),
                                  ],
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
            ),
          );
        },
      ),
    );
  }
}



/*

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/custom_input.dart';
import 'package:wayli/app/modules/customer/registration/registration_view.dart';
import 'package:wayli/app/modules/forget_password/forget_password_view.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  static const String routeName = '/login';
  const LoginView({super.key});
  static final GlobalKey loginBottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (ctl) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/food.png'),
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
                                "Login",
                                style: GoogleFonts.montserrat(
                                    color: primaryColor,
                                    fontSize: 50,
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
                      key: ctl.loginViewFormKey,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: <Widget>[
                                // Gap(60),
                                Container(
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
                                          hintText: "Enter your email address",
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: Obx(
                                              () => CostumFormField(
                                            textController: ctl.pass,
                                            isPassword: true,
                                            labelText: "Password",
                                            hintText: "Enter your password",
                                            icon: const Icon(Icons.lock),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'User password is required';
                                              }
                                              return null;
                                            },
                                            obscureText:
                                            ctl.visiblePassword.value,
                                            suffixIcon: IconButton(
                                              onPressed: () => ctl
                                                  .togglePasswordVisibility(),
                                              icon: Icon(
                                                  ctl.visiblePassword.value
                                                      ? Icons.visibility_off
                                                      : Icons.visibility),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => ForgetPasswordView());
                                        },
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: AutoSizeText(
                                            "Forgot Password?",
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
                                      GestureDetector(
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
                                    ],
                                  ),
                                ),
                                Gap(40),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: MaterialButton(
                                        onPressed: () {},
                                        height: 50,
                                        color: secondaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                        ),
                                        child: Obx(() => ctl.isLoading.value
                                            ? CircularProgressIndicator()
                                            : ElevatedButton(
                                          onPressed: ctl.handleLogin,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            Colors.transparent,
                                            shadowColor:
                                            Colors.transparent,
                                          ),
                                          child: Center(
                                            child: AutoSizeText(
                                              "LOGIN",
                                              style:
                                              GoogleFonts.alfaSlabOne(
                                                fontSize: 18,
                                                color: primaryColor,
                                                fontWeight:
                                                FontWeight.w900,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ),
                                        )),
                                      ),
                                    ),
                                    const Gap(5),
                                    Obx(() => ctl.showFingerprint.value
                                        ? Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          ctl.authenticate();
                                        },
                                        child: SvgPicture.asset(
                                          'assets/svg/fingerprint.svg',
                                          color: primaryColor,
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),
                                    )
                                        : SizedBox()),
                                  ],
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
*/
