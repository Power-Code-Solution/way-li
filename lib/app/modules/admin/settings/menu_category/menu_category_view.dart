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
import 'package:wayli/app/core/widgets/dropdown_select/dropdown_select_page.dart';
import 'package:wayli/app/modules/admin/settings/menu/menu_controller.dart';
import 'package:wayli/app/modules/admin/settings/menu_category/menu_category_controller.dart';

class MenuCategoryView extends GetView<MenuCategoryController> {
  const MenuCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final MenuCategoryController ctl = Get.put(MenuCategoryController());
    final TextEditingController nameController = TextEditingController();
    final TextEditingController fkMenuCategoryIdController = TextEditingController();
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
      body: GetBuilder<MenuCategoryController>(
        init: ctl,
        builder: (ctl) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(() {
                    return ctl.isLoading.value
                        ? const CircularProgressIndicator()
                        : const SizedBox.shrink();
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: CostumFormField(
                      keyboardType: TextInputType.text,
                      textController: nameController,
                      isPassword: false,
                      labelText: "Sub Menu Name",
                      hintText: "Enter Sub Menu Name",
                      icon: const Icon(Icons.menu),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide Sub Menu Name !';
                        }
                        return null;
                      },
                    ),
                  ),


const Gap(16),
                      Obx(
                        () => DropdownSelect(
                          hintText: 'Select Menu',
                          list: ctl.menuItemCategory.value
                              .map((c) => c.name)
                              .toList(),
                          onChange: (val) {
                            ctl.selectedMenuCategory(val);
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
                    return ctl.selectedImage.value == null
                        ? const Text('No image selected.')
                        : Image.file(
                          width: 50,
                          ctl.selectedImage.value!
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
                          await ctl.pickImage();
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
                                if (ctl.selectedImage.value !=
                                    null) {
                                  File menuFile =
                                      ctl.selectedImage.value!;
                                  await ctl.createMenuCategory(
                                    nameController.text,
                                    ctl.menuCategoryId?.toString() ?? '0',
                                    descriptionController.text,
                                    menuFile,
                                  );
                                } else {
                                  ctl.responseMessage.value =
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
                            )),
                    ),
                  ),
                  Obx(() {
                    return Text(ctl.responseMessage.value);
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
