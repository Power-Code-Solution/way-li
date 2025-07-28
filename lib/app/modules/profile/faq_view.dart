import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../core/config/constants.dart';
import '../../newpages/components/colors.dart';

class FAQView extends StatelessWidget {
  static const String routeName = '/faq';
  const FAQView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Frequently Asked Questions',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFAQSection(
                title: 'About Our Restaurant',
                faqs: [
                  {
                    'question': 'What type of cuisine does Way Li serve?',
                    'answer': 'Way Li specializes in authentic Sierra Leonean cuisine with a modern twist. Our menu features a variety of traditional dishes made with locally sourced ingredients.'
                  },
                  {
                    'question': 'What are your operating hours?',
                    'answer': 'We are open Monday to Thursday from 10:00 AM to 10:00 PM, and Friday to Sunday from 10:00 AM to 11:00 PM.'
                  },
                  {
                    'question': 'Do you offer vegetarian or vegan options?',
                    'answer': 'Yes, we have a selection of vegetarian and vegan dishes on our menu. Please inform our staff about any dietary restrictions you may have.'
                  },
                ],
              ),
              const SizedBox(height: 16),
              _buildFAQSection(
                title: 'Orders & Delivery',
                faqs: [
                  {
                    'question': 'How can I place an order?',
                    'answer': 'You can place an order through our mobile app, website, or by calling our restaurant directly. We also accept walk-in orders.'
                  },
                  {
                    'question': 'What are the delivery areas?',
                    'answer': 'We currently deliver to RowdonStreet, Lumely, and Eastern areas. We\'re continuously expanding our delivery zones to serve more customers.'
                  },
                  {
                    'question': 'How long does delivery usually take?',
                    'answer': 'Delivery times typically range from 30-45 minutes depending on your location and current order volume. You can track your order in real-time through our app.'
                  },
                  {
                    'question': 'Is there a minimum order amount for delivery?',
                    'answer': 'Yes, the minimum order amount for delivery is Le 50,000. There is no minimum order amount for pickup orders.'
                  },
                ],
              ),
              const SizedBox(height: 16),
              _buildFAQSection(
                title: 'Payment & Pricing',
                faqs: [
                  {
                    'question': 'What payment methods do you accept?',
                    'answer': 'We accept cash on delivery, Orange Money, and other mobile payment options. All payment methods are secure and convenient.'
                  },
                  {
                    'question': 'Do you offer any discounts or loyalty programs?',
                    'answer': 'Yes, we have a loyalty program where you earn points for every order. These points can be redeemed for discounts on future orders. We also run seasonal promotions and special offers.'
                  },
                  {
                    'question': 'Is there a delivery fee?',
                    'answer': 'Yes, delivery fees vary based on your location. The exact fee will be displayed before you confirm your order.'
                  },
                ],
              ),
              const SizedBox(height: 16),
              _buildFAQSection(
                title: 'Special Requests & Reservations',
                faqs: [
                  {
                    'question': 'Can I make special requests for my order?',
                    'answer': 'Absolutely! You can add special instructions when placing your order. We\'ll do our best to accommodate your requests.'
                  },
                  {
                    'question': 'How can I make a reservation?',
                    'answer': 'You can make a reservation through our app, website, or by calling us directly. We recommend making reservations at least 24 hours in advance, especially for weekends.'
                  },
                  {
                    'question': 'Do you cater for events?',
                    'answer': 'Yes, we offer catering services for various events and gatherings. Please contact us at least 48 hours in advance to discuss your catering needs.'
                  },
                ],
              ),
              const SizedBox(height: 24),
              _buildContactSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.question_answer, color: secondaryColor, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Welcome to Way Li FAQ',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Find answers to commonly asked questions about our restaurant, ordering process, delivery, and more.',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection({required String title, required List<Map<String, String>> faqs}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...faqs.map((faq) => _buildFAQItem(
          question: faq['question'] ?? '',
          answer: faq['answer'] ?? '',
        )).toList(),
      ],
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          question,
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: secondaryColor,
          ),
        ),
        iconColor: secondaryColor,
        collapsedIconColor: secondaryColor,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            secondaryColor,
            secondaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Still Have Questions?',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Contact our customer support team for further assistance.',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildContactButton(
                icon: Icons.phone,
                label: 'Call Us',
                onTap: () {
                  // Implement call functionality
                },
              ),
              const SizedBox(width: 12),
              _buildContactButton(
                icon: Icons.email,
                label: 'Email',
                onTap: () {
                  // Implement email functionality
                },
              ),
              const SizedBox(width: 12),
              _buildContactButton(
                icon: Icons.chat_bubble,
                label: 'Chat',
                onTap: () {
                  // Implement chat functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: secondaryColor, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}