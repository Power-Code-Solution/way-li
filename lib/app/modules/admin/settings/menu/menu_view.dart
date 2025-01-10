import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/custom_input.dart';
import 'package:wayli/app/modules/admin/settings/menu/menu_controller.dart';

class MenuView extends GetView<AddMenuController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final AddMenuController addMenuController = Get.put(AddMenuController());
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   backgroundColor: secondaryColor,
      //   leading: IconButton(
      //     icon: SvgPicture.asset(
      //       'assets/svg/back_1.svg',
      //       width: 24,
      //       height: 24,
      //       color: primaryColor,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   title:  Center(
      //     child: AutoSizeText('Create Menu',
      //     style: GoogleFonts.montserrat(
      //       color: primaryColor,
      //       fontSize: 15,
      //       fontWeight: FontWeight.bold

      //     ),
      //     ),
      //   ),
      //   actions: [],
      // ),
      body: GetBuilder<AddMenuController>(
        init: addMenuController,
        builder: (ctl) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(() {
                    return addMenuController.isLoading.value
                        ? const CircularProgressIndicator()
                        : const SizedBox.shrink();
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: CostumFormField(
                      keyboardType: TextInputType.text,
                      textController: nameController,
                      isPassword: false,
                      labelText: "Menu Name",
                      hintText: "Enter Menu Name",
                      icon: const Icon(Icons.menu),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide Menu Name !';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: CostumFormField(
                      keyboardType: TextInputType.text,
                      textController: descriptionController,
                      isPassword: false,
                      minLines: 5,
                      maxLines: 8,
                      labelText: "Menu Description",
                      hintText: "Enter Menu Description",
                      icon: const Icon(Icons.description),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide Menu Description !';
                        }
                        return null;
                      },
                    ),
                  ),
                   const Gap(10),
                  Obx(() {
                    return addMenuController.selectedImage.value == null
                        ? const Text('No image selected.')
                        : Image.file(
                          width: 50,
                          addMenuController.selectedImage.value!
                          );
                  }),
                  const Gap(10),
         FadeInUp(
  duration: Duration(milliseconds: 500),
  child: Column(
    children: [
      Obx(() {
        return ctl.selectedImage.value == null
            ? MaterialButton(
                onPressed: () {},
                height: 50,
                color: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Obx(() => ctl.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          await addMenuController.pickImage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Center(
                          child: AutoSizeText(
                            "SELECT COVER IMAGE",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              color: primaryColor,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      )),
              )
            : Column(
                children: [
                  Image.file(
                    ctl.selectedImage.value!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),

MaterialButton(
                onPressed: () {},
                height: 50,
                color: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Obx(() => ctl.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                      ctl.selectedImage.value = null;
                    },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Center(
                          child: AutoSizeText(
                            "CHANGE/REMOVE IMAGE",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              color: primaryColor,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      )),
              )





                  
                ],
              );
      }),
    ],
  ),
),




                  const Gap(30),
                  FadeInUp(
                    duration: Duration(milliseconds: 500),
                    child: MaterialButton(
                      onPressed: () {},
                      height: 50,
                      color: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Obx(() => ctl.isLoading.value
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                if (addMenuController.selectedImage.value !=
                                    null) {
                                  File menuFile =
                                      addMenuController.selectedImage.value!;
                                  await addMenuController.createMenu(
                                    nameController.text,
                                    descriptionController.text,
                                    menuFile,
                                  );
                                } else {
                                  addMenuController.responseMessage.value =
                                      'Please select an image';
                                  Get.snackbar(
                                      'Error', 'Please select an image.',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: Center(
                                child: AutoSizeText(
                                  "CREATE ",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            )
                            ),
                    ),
                  ),
                  Obx(() {
                    return Text(addMenuController.responseMessage.value);
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
