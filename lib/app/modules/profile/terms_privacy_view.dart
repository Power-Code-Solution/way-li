import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/newpages/components/colors.dart';

class TermsPrivacyView extends StatelessWidget {
  static const String routeName = '/terms-privacy';
  const TermsPrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Terms & Privacy',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Get.offAllNamed('/bottom-nav'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.gavel_rounded,
                          size: 40,
                          color: mainYellow,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terms of Service & Privacy Policy',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last Updated: July 28, 2023',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Terms of Service
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description_outlined, color: mainYellow),
                          const SizedBox(width: 8),
                          Text(
                            'Terms of Service',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTermsSection(
                        '1. Acceptance of Terms',
                        'By accessing or using the WAY LI restaurant app, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our app.',
                      ),
                      _buildTermsSection(
                        '2. User Accounts',
                        'To use certain features of our app, you may need to create an account. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.',
                      ),
                      _buildTermsSection(
                        '3. Ordering and Payment',
                        'When you place an order through our app, you agree to provide accurate payment information. All payments are processed securely through our payment providers. Prices and availability of items are subject to change without notice.',
                      ),
                      _buildTermsSection(
                        '4. Delivery and Pickup',
                        'Delivery times are estimates and may vary based on factors such as traffic, weather, and restaurant capacity. We are not responsible for delays caused by factors outside our control.',
                      ),
                      _buildTermsSection(
                        '5. User Conduct',
                        'You agree not to use our app for any illegal or unauthorized purpose. You agree not to violate any laws in your jurisdiction.',
                      ),
                      _buildTermsSection(
                        '6. Intellectual Property',
                        'All content on the WAY LI app, including text, graphics, logos, and software, is the property of WAY LI and is protected by copyright and other intellectual property laws.',
                      ),
                      _buildTermsSection(
                        '7. Limitation of Liability',
                        'WAY LI shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the app.',
                      ),
                      _buildTermsSection(
                        '8. Changes to Terms',
                        'We reserve the right to modify these terms at any time. Your continued use of the app after such changes constitutes your acceptance of the new terms.',
                      ),
                      _buildTermsSection(
                        '9. Governing Law',
                        'These terms shall be governed by and construed in accordance with the laws of the jurisdiction in which WAY LI operates, without regard to its conflict of law provisions.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Privacy Policy
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.privacy_tip_outlined, color: mainYellow),
                          const SizedBox(width: 8),
                          Text(
                            'Privacy Policy',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'At WAY LI, we take your privacy seriously. This Privacy Policy explains how we collect, use, and protect your personal information.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTermsSection(
                        '1. Information We Collect',
                        'We collect information you provide directly to us, such as your name, email address, phone number, delivery address, and payment information when you create an account, place an order, or contact customer service.',
                      ),
                      _buildTermsSection(
                        '2. How We Use Your Information',
                        'We use your information to process orders, provide customer service, send promotional offers (if you opt in), improve our services, and comply with legal obligations.',
                      ),
                      _buildTermsSection(
                        '3. Information Sharing',
                        'We may share your information with third-party service providers who help us operate our business, such as payment processors and delivery partners. We do not sell your personal information to third parties.',
                      ),
                      _buildTermsSection(
                        '4. Data Security',
                        'We implement appropriate security measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction.',
                      ),
                      _buildTermsSection(
                        '5. Your Rights',
                        'You have the right to access, correct, or delete your personal information. You can manage your preferences through your account settings or by contacting us.',
                      ),
                      _buildTermsSection(
                        '6. Cookies and Tracking Technologies',
                        'We use cookies and similar technologies to enhance your experience, analyze usage, and assist in our marketing efforts. You can manage your cookie preferences through your browser settings.',
                      ),
                      _buildTermsSection(
                        '7. Children\'s Privacy',
                        'Our services are not directed to children under 13. We do not knowingly collect personal information from children under 13.',
                      ),
                      _buildTermsSection(
                        '8. Changes to Privacy Policy',
                        'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
                      ),
                      _buildTermsSection(
                        '9. Contact Us',
                        'If you have any questions about this Privacy Policy, please contact us at privacy@wayli.com.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Acceptance Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'I Understand and Accept',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}