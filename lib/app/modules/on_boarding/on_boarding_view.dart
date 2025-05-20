import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/modules/on_boarding/on_boarding_controller.dart';

import '../../core/config/constants.dart';
import '../../core/widgets/button/button_page.dart';


class OnBoardingView extends GetView<OnBoardingController> {
  static const routeName = 'on-boarding';
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final OnBoardingController controller = Get.put(OnBoardingController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              return PageView.builder(
                controller: controller.controller.value,
                itemCount: controller.pageArr.length,
                onPageChanged: controller.updatePage,
                itemBuilder: (context, index) {
                  var pObj = controller.pageArr[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            pObj["image"]!,
                            width: size.width * 0.7,
                            height: size.width * 0.7,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 30),
                        AutoSizeText(
                          pObj["title"]!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: secondaryColor,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AutoSizeText(
                          pObj["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),

            /// Skip button (top-right)
            Positioned(
              top: 10,
              right: 10,
              child: TextButton(
                onPressed: () => controller.completeOnboarding(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AutoSizeText(
                    "Skip",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),

            /// Page indicators + Next/Get Started button
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.pageArr.length,
                            (index) => AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: controller.selectPage.value == index ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: controller.selectPage.value == index
                                ? Colors.amber
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Obx(() {
                      final isLast = controller.selectPage.value == controller.pageArr.length - 1;
                      return RoundButton(
                        fontSize: 16,


                        onPressed: () {
                          if (isLast) {
                            controller.completeOnboarding();
                          } else {
                            controller.goToNextPage();
                          }
                        },
                        title: isLast ? 'Get Started' : 'Next',
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
