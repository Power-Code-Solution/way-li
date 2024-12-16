import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/button/button_page.dart';

import 'on_boarding_controller.dart';

class OnBoardingView extends GetView<OnBoardingController> {
  static const routeName = 'on-boarding';
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final OnBoardingController controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Obx(() {
            return PageView.builder(
              controller: controller.controller.value,
              itemCount: controller.pageArr.length,
              onPageChanged: controller.updatePage,
              itemBuilder: (context, index) {
                var pObj = controller.pageArr[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Image.asset(
                        pObj["image"]!,
                        width: MediaQuery.of(context).size.width * 0.65,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.2),
                    AutoSizeText(
                      pObj["title"]!,
                      style: GoogleFonts.montserrat(
                          color: secondaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                    AutoSizeText(
                      pObj["subtitle"]!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          color: secondaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.20),
                  ],
                );
              },
            );
          }),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
              ),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(controller.pageArr.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                          color: index == controller.selectPage.value
                              ? primaryColor
                              : secondaryColor,
                          borderRadius: BorderRadius.circular(4)),
                    );
                  }),
                );
              }),
              SizedBox(height: MediaQuery.of(context).size.height * 0.28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: RoundButton(
                  onPressed: controller.goToNextPage, title: 'Next',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




