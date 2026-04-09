import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:wayli/app/modules/bottom_nav/bottom_nav_view.dart';
import 'package:wayli/app/modules/customer/registration/registration_controller.dart';
import 'package:wayli/app/modules/login/login_view.dart';
import 'package:wayli/app/modules/otp/otp_view.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:gap/gap.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/custom_input.dart';

class RegistrationView extends GetView<RegistrationController> {
  static const String routeName = '/register';
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<RegistrationController>(
        init: RegistrationController(),
        builder: (ctl) {
          return SafeArea(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    secondaryColor.withOpacity(0.1),
                    Colors.white,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(40),

                      // Back Button
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.arrow_back_ios, color: secondaryColor),
                        padding: EdgeInsets.zero,
                      ),

                      const Gap(20),

                      // Header
                      FadeInDown(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          "Create Account",
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const Gap(8),

                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: Text(
                          "Please fill in the details to register",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      const Gap(40),

                      // Registration Form
                      Form(
                        key: ctl.registrationViewFormKey,
                        child: Column(
                          children: [
                            // Full Name Field
                            FadeInUp(
                              duration: const Duration(milliseconds: 700),
                              child: CostumFormField(
                                keyboardType: TextInputType.name,
                                textController: ctl.fullname,
                                isPassword: false,
                                labelText: "Full Name",
                                hintText: "Enter your full name",
                                icon: Icon(Icons.person_outline, color: secondaryColor),
                                validator: (value) {
                                  if (value!.isEmpty) return 'Full name is required';
                                  return null;
                                },
                              ),
                            ),

                            const Gap(20),

                            // Email Field
                            FadeInUp(
                              duration: const Duration(milliseconds: 800),
                              child: CostumFormField(
                                keyboardType: TextInputType.emailAddress,
                                textController: ctl.email,
                                isPassword: false,
                                labelText: "Email",
                                hintText: "Enter your email address",
                                icon: Icon(Icons.email_outlined, color: secondaryColor),
                                validator: (value) {
                                  if (value!.isEmpty) return 'Email is required';
                                  if (!GetUtils.isEmail(value)) return 'Enter a valid email';
                                  return null;
                                },
                              ),
                            ),

                            const Gap(20),

                            // Phone Field
                            FadeInUp(
                              duration: const Duration(milliseconds: 900),
                              child: CostumFormField(
                                keyboardType: TextInputType.phone,
                                textController: ctl.phone,
                                isPassword: false,
                                labelText: "Phone Number",
                                hintText: "Enter your phone number",
                                icon: Icon(Icons.phone_outlined, color: secondaryColor),
                                validator: (value) {
                                  if (value!.isEmpty) return 'Phone number is required';
                                  return null;
                                },
                              ),
                            ),

                            const Gap(20),

                            // Password Field
                            FadeInUp(
                              duration: const Duration(milliseconds: 1000),
                              child: CostumFormField(
                                textController: ctl.password,
                                isPassword: true,
                                labelText: "Password",
                                hintText: "Enter your password",
                                icon: Icon(Icons.lock_outline, color: secondaryColor),
                                obscureText: ctl.visiblePassword,
                                validator: (value) {
                                  if (value!.isEmpty) return 'Password is required';
                                  if (value.length < 6) return 'Password must be at least 6 characters';
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    ctl.visiblePassword = !ctl.visiblePassword;
                                    ctl.update();
                                  },
                                  icon: Icon(
                                    ctl.visiblePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: secondaryColor,
                                  ),
                                ),
                              ),
                            ),

                            const Gap(20),

                            // Confirm Password Field
                            FadeInUp(
                              duration: const Duration(milliseconds: 1100),
                              child: CostumFormField(
                                textController: ctl.confPassword,
                                isPassword: true,
                                labelText: "Confirm Password",
                                hintText: "Confirm your password",
                                icon: Icon(Icons.lock_outline, color: secondaryColor),
                                obscureText: ctl.visiblePassword,
                                validator: (value) {
                                  if (value!.isEmpty) return 'Please confirm your password';
                                  if (value != ctl.password.text) return 'Passwords do not match';
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    ctl.visiblePassword = !ctl.visiblePassword;
                                    ctl.update();
                                  },
                                  icon: Icon(
                                    ctl.visiblePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: secondaryColor,
                                  ),
                                ),
                              ),
                            ),

                            const Gap(40),

                            // Register Button
                            FadeInUp(
                              duration: const Duration(milliseconds: 1200),
                              child: Obx(
                                    () => SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: ctl.isLoading.value ? null : ctl.createUser,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: ctl.isLoading.value
                                        ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                        : Text(
                                      "Create Account",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const Gap(20),

                            // Login Link
                            FadeInUp(
                              duration: const Duration(milliseconds: 1300),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account? ",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.to(() => const LoginView()),
                                    child: Text(
                                      "Login",
                                      style: GoogleFonts.poppins(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Gap(20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
