import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/custom_input.dart';
import 'package:wayli/app/modules/customer/registration/registration_view.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  static const String routeName = '/login';
  const LoginView({super.key});
  static final GlobalKey loginBottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final loginReason =
        Get.arguments is Map ? Get.arguments["loginReason"] as String? : null;
    final authController = Get.find<AuthController>();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, __) {
        authController.pendingCheckoutAfterLogin.value = false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: GetBuilder<LoginController>(
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
                              'assets/images/way-li-logo.png', // Add your logo image
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
                              loginReason ?? "Sign in to continue",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
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
                                  icon: Icon(Icons.email_outlined,
                                      color: secondaryColor),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Email is required';
                                    }
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
                                    icon: Icon(Icons.lock_outline,
                                        color: secondaryColor),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Password is required';
                                      }
                                      return null;
                                    },
                                    obscureText: ctl.visiblePassword.value,
                                    suffixIcon: IconButton(
                                      onPressed: () =>
                                          ctl.togglePasswordVisibility(),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // TextButton(
                                    //   onPressed: () => Get.to(() => ForgetPasswordView()),
                                    //   child: Text(
                                    //     "Forgot Password?",
                                    //     style: GoogleFonts.poppins(
                                    //       color: secondaryColor,
                                    //       fontWeight: FontWeight.w600,
                                    //     ),
                                    //   ),
                                    // ),
                                    TextButton(
                                      onPressed: () =>
                                          Get.to(() => RegistrationView()),
                                      child: Text(
                                        "Sign Up",
                                        style: GoogleFonts.poppins(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.find<AuthController>()
                                            .pendingCheckoutAfterLogin
                                            .value = false;
                                        Get.offAllNamed('/bottom-nav');
                                      },
                                      child: Text(
                                        "Continue Browsing",
                                        style: GoogleFonts.poppins(
                                          color: secondaryColor,
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
                                child: Obx(
                                  () => Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: ctl.isLoading.value
                                              ? null
                                              : () => ctl.handleLogin(),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: ctl.isLoading.value
                                              ? SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  "LOGIN",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
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
      ),
    );
  }
}
