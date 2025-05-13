import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:wayli/app/modules/bottom_nav/bottom_nav_view.dart';
import 'package:wayli/app/modules/customer/registration/registration_controller.dart';
import 'package:wayli/app/modules/customer/registration/registration_controller.dart';
import 'package:wayli/app/modules/customer/registration/registration_controller.dart';
import 'package:wayli/app/modules/customer/registration/registration_controller.dart';
import 'package:wayli/app/modules/customer/registration/registration_controller.dart';
import 'package:wayli/app/modules/customer/registration/registration_controller.dart';
import 'package:wayli/app/modules/login/login_view.dart';
import 'package:wayli/app/modules/otp/otp_view.dart';

import 'registration_controller.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/button/button_page.dart';
import 'package:wayli/app/core/widgets/custom_input.dart';
import 'package:wayli/app/modules/customer/registration/registration_view.dart';
import 'package:wayli/app/modules/home/home_view.dart';
import 'package:wayli/app/modules/tabs/tabs_view.dart';

class RegistrationView extends GetView<RegistrationController> {
  static const String routeName = '/register';
  RegistrationView({super.key});
  static final GlobalKey registrationBottomNavigationKey = GlobalKey();
  final RegistrationController ctl = Get.put(RegistrationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<RegistrationController>(
        init: RegistrationController(),
        builder: (ctl) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fried-rice.jpg'),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FadeInUp(
                              duration: Duration(milliseconds: 1000),
                              child: AutoSizeText(
                                "Registration",
                                style: GoogleFonts.montserrat(
                                    color: primaryColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            FadeInUp(
                              duration: Duration(milliseconds: 1000),
                              child: AutoSizeText(
                                "Welcome Back",
                                style: GoogleFonts.montserrat(
                                    color: primaryColor, fontSize: 15),
                                textAlign: TextAlign.left,
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
                      key: ctl.registrationViewFormKey,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: <Widget>[
                                // Gap(60),
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
                                              horizontal: 15),
                                          child: CostumFormField(
                                            keyboardType: TextInputType.name,
                                            textController: ctl.firstName,
                                            isPassword: false,
                                            labelText: "First Name",
                                            hintText: "Enter your first name",
                                            icon: const Icon(Icons.person),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please provide your first name !';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const Gap(10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: CostumFormField(
                                            keyboardType: TextInputType.name,
                                            textController: ctl.lastName,
                                            isPassword: false,
                                            labelText: "Last Name",
                                            hintText: "Enter your last name",
                                            icon: const Icon(Icons.person),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please provide your last name !';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const Gap(10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: CostumFormField(
                                            keyboardType: TextInputType.phone,
                                            textController: ctl.phone,
                                            isPassword: false,
                                            labelText: "Phone Number",
                                            hintText: "Enter your Phone Number",
                                            icon: const Icon(Icons.phone),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please provide your Phone number !';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const Gap(10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: CostumFormField(
                                            keyboardType: TextInputType.number,
                                            textController:
                                                ctl.fkCityIdController,
                                            isPassword: false,
                                            labelText: "City",
                                            hintText:
                                                "Enter your City of Residence",
                                            icon:
                                                const Icon(Icons.location_city),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please provide City !';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const Gap(10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: CostumFormField(
                                            keyboardType: TextInputType.text,
                                            textController:
                                                ctl.fkCommunityIdController,
                                            isPassword: false,
                                            labelText: "Community",
                                            hintText: "Enter your Community",
                                            icon:
                                                const Icon(Icons.location_city),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please provide your community !';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const Gap(10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: CostumFormField(
                                            keyboardType: TextInputType.text,
                                            textController: ctl.address,
                                            isPassword: false,
                                            labelText: "Address",
                                            hintText: "Enter your address",
                                            icon: const Icon(Icons.location_on),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please provide  address !';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const Gap(10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 15,
                                              bottom: 0),
                                          child: CostumFormField(
                                            textController: ctl.password,
                                            isPassword: true,
                                            labelText: "Password",
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                ctl.visiblePassword =
                                                    !ctl.visiblePassword;
                                                ctl.update();
                                              },
                                              icon: Icon((ctl.visiblePassword)
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                            ),
                                            hintText: "Enter your password",
                                            icon: const Icon(Icons.lock),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'User password is required';
                                              }
                                              return null;
                                            },
                                            obscureText: ctl.visiblePassword,
                                          ),
                                        ),
                                        const Gap(10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 15,
                                              bottom: 0),
                                          child: CostumFormField(
                                            textController: ctl.confPassword,
                                            isPassword: true,
                                            labelText: "Confirm Password",
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                ctl.visiblePassword =
                                                    !ctl.visiblePassword;
                                                ctl.update();
                                              },
                                              icon: Icon((ctl.visiblePassword)
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                            ),
                                            hintText: "Confirm password",
                                            icon: const Icon(Icons.lock),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Confirm Password is Required';
                                              }
                                              return null;
                                            },
                                            obscureText: ctl.visiblePassword,
                                          ),
                                        ),
                                      ],
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
                                            Get.to(() => LoginView());
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: AutoSizeText(
                                              "Already have an Account ?",
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
                                    ],
                                  ),
                                ),
                                Gap(40),
                                FadeInUp(
                                  duration: Duration(milliseconds: 1600),
                                  child: MaterialButton(
                                    onPressed: () {
                                      Get.to(() => BottomNavView(
                                          ));
                                    },
                                    height: 50,
                                    color: secondaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Obx(() => ctl.isLoading.value
                                        ? CircularProgressIndicator()
                                        : ElevatedButton(
                                            // onPressed: () =>
                                            //     showBottomModal(context, ctl),
                                            onPressed: ctl.createUser,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                            ),
                                            child: Center(
                                              child: AutoSizeText(
                                                "Register",
                                                style: GoogleFonts.alfaSlabOne(
                                                  fontSize: 18,
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                            ),
                                          )),
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



    void showBottomModal(BuildContext context, var foodItem) {
  const fillColor = secondaryColor;
  const borderColor = kWhiteColor;
  const focusedBorderColor = primaryColor;
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 40,
    textStyle: GoogleFonts.montserrat(
      fontSize: 22,
      color: kWhiteColor,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: borderColor),
    ),
  );

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: ctl.otpKey,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              FadeInUp(
                                duration: Duration(milliseconds: 100),
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
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: Pinput(
                                                controller: controller.pinController,
                                                focusNode: controller.focusNode,
                                                defaultPinTheme: defaultPinTheme,
                                                length: 6,
                                                separatorBuilder: (index) => const Gap(4),
                                                validator: (value) {
                                                  return value == '222299' ? null : 'Pin is incorrect';
                                                },
                                                hapticFeedbackType: HapticFeedbackType.lightImpact,
                                                onCompleted: (pin) {
                                                  debugPrint('onCompleted: $pin');
                                                },
                                                onChanged: (value) {
                                                  debugPrint('onChanged: $value');
                                                },
                                                cursor: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.only(bottom: 9),
                                                      width: 22,
                                                      height: 1,
                                                      color: focusedBorderColor,
                                                    ),
                                                  ],
                                                ),
                                                focusedPinTheme: defaultPinTheme.copyWith(
                                                  decoration: defaultPinTheme.decoration!.copyWith(
                                                    borderRadius: BorderRadius.circular(6),
                                                    border: Border.all(color: focusedBorderColor),
                                                  ),
                                                ),
                                                submittedPinTheme: defaultPinTheme.copyWith(
                                                  decoration: defaultPinTheme.decoration!.copyWith(
                                                    color: fillColor,
                                                    borderRadius: BorderRadius.circular(6),
                                                    border: Border.all(color: focusedBorderColor),
                                                  ),
                                                ),
                                                errorPinTheme: defaultPinTheme.copyBorderWith(
                                                  border: Border.all(color: Colors.redAccent),
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
                              const Gap(10),
                              FadeInUp(
                                  duration: Duration(milliseconds: 100),
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
                                        "VALIDATE",
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
                            ],
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
      );
    },
  );
}

 
 
 
 
 
 
  }

