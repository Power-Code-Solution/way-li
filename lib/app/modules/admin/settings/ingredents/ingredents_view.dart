import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/custom_input.dart';
import 'package:wayli/app/modules/admin/settings/ingredents/ingredents_controller.dart';
import 'package:wayli/app/modules/admin/settings/tags/tags_controller.dart';

class IngredentsView extends GetView<IngredentsController> {
  const IngredentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final IngredentsController ctl = Get.put(IngredentsController());
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<IngredentsController>(
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
                      labelText: "Tag Ingredents",
                      hintText: "Enter Tag Name",
                      icon: const Icon(Icons.menu),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide Ingredents Name !';
                        }
                        return null;
                      },
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
                                await ctl.createIngredents(nameController.text);
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
