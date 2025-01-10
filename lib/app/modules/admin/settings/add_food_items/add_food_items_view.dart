import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/allergenss.dart';
import 'package:wayli/app/core/model/ingredents.dart';
import 'package:wayli/app/core/model/tag.dart';
import 'package:wayli/app/core/widgets/custom_input.dart';
import 'package:wayli/app/core/widgets/dropdown_select/dropdown_select_page.dart';

import 'add_food_items_controller.dart';

class AddFoodItemsView extends GetView<AddFoodItemsController> {
  const AddFoodItemsView({super.key});

  Widget build(BuildContext context) {
    final AddFoodItemsController ctl = Get.put(AddFoodItemsController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CostumFormField(
                keyboardType: TextInputType.text,
                textController: ctl.nameController,
                isPassword: false,
                labelText: "Menu Name",
                hintText: "Enter Menu Name",
                icon: const Icon(Icons.menu),
                validator: (value) =>
                    value!.isEmpty ? 'Please provide Menu Name!' : null,
              ),
              const SizedBox(height: 20),

              CostumFormField(
                keyboardType: TextInputType.text,
                textController: ctl.typeController,
                isPassword: false,
                labelText: "Type",
                hintText: "Type",
                icon: const Icon(Icons.menu),
                validator: (value) =>
                    value!.isEmpty ? 'Please provide Type!' : null,
              ),
              const SizedBox(height: 20),

//               Obx(() {
//   if (ctl.tagsItems.isEmpty) {
//     return CircularProgressIndicator();  // Show a loading indicator while data is being fetched
//   } else {
//     return MultiDropdown<Tag>(
//       items: ctl.tagsItems.toList(),  // This will automatically update when tagsItems changes
//       enabled: true,
//       searchEnabled: true,
//       chipDecoration: const ChipDecoration(
//         backgroundColor: Colors.yellow,
//         wrap: true,
//         runSpacing: 2,
//         spacing: 10,
//       ),
//       fieldDecoration: FieldDecoration(
//         hintText: 'Tags',
//         hintStyle: const TextStyle(color: Colors.black87),
//         prefixIcon: const Icon(CupertinoIcons.flag),
//         showClearIcon: false,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.black87),
//         ),
//       ),
//       dropdownDecoration: const DropdownDecoration(
//         marginTop: 2,
//         maxHeight: 500,
//         header: Padding(
//           padding: EdgeInsets.all(8),
//           child: Text(
//             'Select tags from the list',
//             textAlign: TextAlign.start,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       dropdownItemDecoration: DropdownItemDecoration(
//         selectedIcon: const Icon(Icons.check_box, color: Colors.green),
//         disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select a tag';
//         }
//         return null;
//       },
//       onSelectionChange: (selectedItems) {
//         debugPrint("OnSelectionChange: $selectedItems");
//       },
//     );
//   }
// }),

              Obx(() {
                if (ctl.tagsItems.isEmpty) {
                  return CircularProgressIndicator();
                } else {
                  return MultiDropdown<Tag>(
                    items: ctl.tagsItems.toList(),
                    enabled: true,
                    searchEnabled: true,
                    chipDecoration: const ChipDecoration(
                      backgroundColor: primaryColor,
                      wrap: true,
                      runSpacing: 2,
                      spacing: 5,
                    ),
                    fieldDecoration: FieldDecoration(
                      hintText: 'Tags',
                      hintStyle:  GoogleFonts.montserrat(color: secondaryColor, fontWeight: FontWeight.w500),
                      prefixIcon: const Icon(CupertinoIcons.flag),
                      showClearIcon: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor),
                      ),
                    ),
                    dropdownDecoration: const DropdownDecoration(
                      marginTop: 2,
                      maxHeight: 500,
                      header: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Select tags from the list',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    dropdownItemDecoration: DropdownItemDecoration(
                      selectedIcon:
                          const Icon(Icons.check_box, color: kPrimaryColor),
                      disabledIcon:
                          Icon(Icons.lock, color: Colors.grey.shade300),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a tag';
                      }
                      return null;
                    },
                    onSelectionChange: (selectedItems) {
                      List<int> selectedTagIds =
                          selectedItems.map((item) => item.id).toList();
                      print('Selected Tag IDs: $selectedTagIds');
                      ctl.fkTagIds.value = selectedTagIds;
                    },
                  );
                }
              }),
              const Gap(20),

Obx(() {
                if (ctl.allergensItemsList.isEmpty) {
                  return CircularProgressIndicator();
                } else {
                  return MultiDropdown<Allergens>(
                    items: ctl.allergensItemsList.toList(),
                    enabled: true,
                    searchEnabled: true,
                    chipDecoration: const ChipDecoration(
                      backgroundColor: primaryColor,
                      wrap: true,
                      runSpacing: 2,
                      spacing: 5,
                    ),
                    fieldDecoration: FieldDecoration(
                      hintText: 'Allergens',
                      hintStyle:  GoogleFonts.montserrat(color: secondaryColor, fontWeight: FontWeight.w500),
                      prefixIcon: const Icon(CupertinoIcons.flag),
                      showClearIcon: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor),
                      ),
                    ),
                    dropdownDecoration: const DropdownDecoration(
                      marginTop: 2,
                      maxHeight: 500,
                      header: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Select Allergens from the list',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    dropdownItemDecoration: DropdownItemDecoration(
                      selectedIcon:
                          const Icon(Icons.check_box, color: kPrimaryColor),
                      disabledIcon:
                          Icon(Icons.lock, color: Colors.grey.shade300),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a fkAllergensId';
                      }
                      return null;
                    },
                    onSelectionChange: (selectedItems) {
                      List<int> selectedTagIds =
                          selectedItems.map((item) => item.id).toList();
                      print('Selected fkAllergensId IDs: $selectedTagIds');
                      ctl.fkAllergensId.value = selectedTagIds;
                    },
                  );
                }
              }),
              const Gap(20),






Obx(() {
                if (ctl.ingredientsItemsList.isEmpty) {
                  return CircularProgressIndicator();
                } else {
                  return MultiDropdown<Ingredents>(
                    items: ctl.ingredientsItemsList.toList(),
                    enabled: true,
                    searchEnabled: true,
                    chipDecoration: const ChipDecoration(
                      backgroundColor: primaryColor,
                      wrap: true,
                      runSpacing: 2,
                      spacing: 5,
                    ),
                    fieldDecoration: FieldDecoration(
                      hintText: 'Ingredents',
                      hintStyle:  GoogleFonts.montserrat(color: secondaryColor, fontWeight: FontWeight.w500),
                      prefixIcon: const Icon(CupertinoIcons.flag),
                      showClearIcon: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor),
                      ),
                    ),
                    dropdownDecoration: const DropdownDecoration(
                      marginTop: 2,
                      maxHeight: 500,
                      header: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Select ingredients from the list',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    dropdownItemDecoration: DropdownItemDecoration(
                      selectedIcon:
                          const Icon(Icons.check_box, color: kPrimaryColor),
                      disabledIcon:
                          Icon(Icons.lock, color: Colors.grey.shade300),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a ingredients';
                      }
                      return null;
                    },
                    onSelectionChange: (selectedItems) {
                      List<int> selectedTagIds =
                          selectedItems.map((item) => item.id).toList();
                      print('Selected ingredients IDs: $selectedTagIds');
                      ctl.fkIngredientsId.value = selectedTagIds;
                    },
                  );
                }
              }),
              const Gap(20),








              Obx(
                () => DropdownSelect(
                  hintText: 'Select Menu',
                  list: ctl.menuItemCategory.value.map((c) => c.name).toList(),
                  onChange: (val) {
                    ctl.selectedMenuCategory(val);
                  },
                ),
              ),
              const Gap(16),
              CostumFormField(
                keyboardType: TextInputType.text,
                textController: ctl.descriptionController,
                isPassword: false,
                minLines: 5,
                maxLines: 8,
                labelText: "Menu Description",
                hintText: "Enter Menu Description",
                icon: const Icon(Icons.description),
                validator: (value) =>
                    value!.isEmpty ? 'Please provide Menu Description!' : null,
              ),
              const SizedBox(height: 20),

              // CostumFormField(
              //   keyboardType: TextInputType.text,
              //   textController: ctl.ingredients,
              //   isPassword: false,
              //   labelText: "Ingredients",
              //   hintText: "Ingredients",
              //   icon: const Icon(Icons.insights),
              //   validator: (value) =>
              //       value!.isEmpty ? 'Please provide Ingredients!' : null,
              // ),
              // const SizedBox(height: 20),
              // CostumFormField(
              //   keyboardType: TextInputType.text,
              //   textController: ctl.allergens,
              //   isPassword: false,
              //   labelText: "allergens",
              //   hintText: "Enter allergens",
              //   icon: const Icon(Icons.all_inclusive_rounded),
              //   validator: (value) =>
              //       value!.isEmpty ? 'Please provide Allergens!' : null,
              // ),
              const Gap(20),
              CostumFormField(
                keyboardType: TextInputType.text,
                textController: ctl.servingSize,
                isPassword: false,
                labelText: "Serving Size",
                hintText: "Enter Serving Size",
                icon: const Icon(Icons.line_weight),
                validator: (value) =>
                    value!.isEmpty ? 'Please provide Serving Size!' : null,
              ),
              const Gap(20),

              Obx(() {
                return Column(
                  children: [
                    if (ctl.selectedImages.isEmpty)
                      const Text('No images selected.')
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: ctl.selectedImages
                            .map((file) => Stack(
                                  children: [
                                    Image.file(
                                      file,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () => ctl.removeImage(file),
                                        child: const Icon(Icons.close,
                                            color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    const Gap(10),
                    FadeInUp(
                      duration: Duration(milliseconds: 500),
                      child: MaterialButton(
                        onPressed: () {},
                        height: 50,
                        color: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Obx(
                          () => ctl.isLoading.value
                              ? CircularProgressIndicator()
                              : ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  icon: const Icon(
                                    Icons.add_photo_alternate,
                                    color: primaryColor,
                                  ),
                                  label: AutoSizeText(
                                    "Select Images",
                                    style: GoogleFonts.montserrat(
                                        color: primaryColor),
                                  ),
                                  onPressed: ctl.pickImages,
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),
              CostumFormField(
                keyboardType: TextInputType.text,
                textController: ctl.priceController,
                isPassword: false,
                labelText: "price",
                hintText: "price",
                icon: const Icon(Icons.tag),
              ),
              const SizedBox(height: 20),

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
                            await ctl.createMenu(
                              ctl.nameController.text,
                              ctl.descriptionController.text,
                              ctl.typeController.text,
                              ctl.menuCategoryId?.toString() ?? '0',
                              ctl.servingSize.text,
                              ctl.priceController.text,
                              ctl.selectedImages,
                              ctl.fkTagIds,
                              ctl.fkAllergensId,
                              ctl.fkIngredientsId,
                            );
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

              const SizedBox(height: 20),
              Obx(() => Text(ctl.responseMessage.value)),
            ],
          ),
        ),
      ),
    );
  }
}
