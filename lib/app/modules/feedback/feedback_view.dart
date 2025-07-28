import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/config/constants.dart';
import 'feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
  const FeedbackView({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Give Feedback",
          style: GoogleFonts.montserrat(
            color: secondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          minFontSize: 8,
          maxFontSize: 20,
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () => Get.offAllNamed('/bottom-nav'),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        (controller.foodItem.foodItemsImages != null && 
                         controller.foodItem.foodItemsImages!.isNotEmpty) 
                            ? controller.foodItem.foodItemsImages![0].image ?? 'assets/images/food.png'
                            : 'assets/images/food.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                            Image.asset('assets/images/food.png', width: 80, height: 80),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Product details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.foodItem.name ?? 'Unknown Product',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "LE ${(controller.foodItem.price ?? 0).toStringAsFixed(2)}",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              Text(
                "Rate this food",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your feedback helps us improve our service",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Obx(() => RatingBar.builder(
                  initialRating: controller.rating.value,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: primaryColor,
                  ),
                  onRatingUpdate: (rating) {
                    controller.rating.value = rating;
                  },
                )),
              ),
              const SizedBox(height: 24),
              
              // Comment field
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Comment",
                  hintText: "Tell us what you think about this food",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                onChanged: (value) {
                  controller.comment.value = value;
                },
              ),
              const SizedBox(height: 16),
              
              // Email field
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email (optional)",
                  hintText: "Your email address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                onChanged: (value) {
                  controller.email.value = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Name (optional)",
                  hintText: "Your name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                onChanged: (value) {
                  controller.name.value = value;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () async {
                    if (controller.comment.value.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a comment"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    final success = await controller.submitFeedback();
                    if (success) {
                     Get.offAllNamed('/bottom-nav');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isSubmitting.value
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                  )
                      : Text(
                    "Submit Feedback",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}