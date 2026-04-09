import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:wayli/app/modules/profile/contact_us_view.dart';
import 'help_controller.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Help & Support',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              color: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                children: [
                  Icon(
                    CupertinoIcons.question_circle,
                    size: 70,
                    color: secondaryColor,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'How Can We Help You?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Find answers to common questions below',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: secondaryColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // FAQ Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Frequently Asked Questions'),
                  const SizedBox(height: 20),

                  _buildFaqItem(
                    question: 'How do I place an order?',
                    answer: 'To place an order, browse our menu, select the items you want, add them to your cart, and proceed to checkout. You can choose between delivery or pickup options and select your preferred payment method.',
                  ),

                  _buildFaqItem(
                    question: 'What payment methods do you accept?',
                    answer: 'We accept various payment methods including Orange Money and cash on delivery. You can select your preferred payment method during checkout.',
                  ),

                  _buildFaqItem(
                    question: 'How long does delivery take?',
                    answer: 'Delivery times typically range from 30-45 minutes depending on your location and current order volume. You\'ll receive an estimated delivery time after placing your order.',
                  ),

                  _buildFaqItem(
                    question: 'Can I modify or cancel my order?',
                    answer: 'You can modify or cancel your order within 5 minutes of placing it. Please contact our customer support team immediately if you need to make changes to your order.',
                  ),

                  _buildFaqItem(
                    question: 'Do you offer special dietary options?',
                    answer: 'Yes, we offer various dietary options including vegetarian dishes. Please check the menu for specific dietary information or contact us for special requests.',
                  ),

                  _buildFaqItem(
                    question: 'How do I create an account?',
                    answer: 'To create an account, click on the "Sign Up" button on the login screen. Fill in your details including name, email, and password, then verify your email to complete the registration process.',
                  ),

                  const SizedBox(height: 30),
                  _buildSectionTitle('Contact Support'),
                  const SizedBox(height: 15),

                  _buildContactCard(
                    icon: CupertinoIcons.phone_fill,
                    title: 'Phone Support',
                    description: 'Call us at +232 79 123 4567\nAvailable 9 AM - 8 PM daily',
                    buttonText: 'Call Now',
                    onPressed: () {
                      // Implement phone call functionality
                      Get.snackbar(
                        'Phone Support',
                        'Calling support...',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: primaryColor,
                        colorText: secondaryColor,
                      );
                    },
                  ),

                  const SizedBox(height: 15),
                  _buildContactCard(
                    icon: CupertinoIcons.mail_solid,
                    title: 'Email Support',
                    description: 'Send us an email at support@wayli.com\nWe\'ll respond within 24 hours',
                    buttonText: 'Send Email',
                    onPressed: () {
                      // Implement email functionality
                      Get.snackbar(
                        'Email Support',
                        'Opening email client...',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: primaryColor,
                        colorText: secondaryColor,
                      );
                    },
                  ),

                  const SizedBox(height: 15),
                  _buildContactCard(
                    icon: CupertinoIcons.chat_bubble_fill,
                    title: 'Live Chat',
                    description: 'Chat with our support team\nAvailable 9 AM - 6 PM daily',
                    buttonText: 'Start Chat',
                    onPressed: () {
                      // Implement chat functionality
                      Get.snackbar(
                        'Live Chat',
                        'Starting chat session...',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: primaryColor,
                        colorText: secondaryColor,
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                  _buildSectionTitle('App Information'),
                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                CupertinoIcons.info_circle_fill,
                                color: secondaryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'App Version',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: secondaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Way Li v1.0.0',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildInfoRow(
                          icon: CupertinoIcons.doc_text_fill,
                          title: 'Terms of Service',
                          onTap: () {
                            Get.offAllNamed('/terms-privacy');
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                          icon: CupertinoIcons.shield_fill,
                          title: 'Privacy Policy',
                          onTap: () {
                           Get.offAllNamed('/terms-privacy');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: secondaryColor,
              child: Column(
                children: [
                  Text(
                    'Still need help?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                    Get.offAllNamed('/contact-us');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: secondaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Contact Us',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: secondaryColor,
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: secondaryColor,
          ),
        ),
        iconColor: secondaryColor,
        collapsedIconColor: secondaryColor,
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          Text(
            answer,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: secondaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonText,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: secondaryColor,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: secondaryColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
