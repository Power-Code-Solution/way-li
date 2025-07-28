import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'About Way Li',
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
            // Hero section with logo and tagline
            Container(
              color: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/way-li-logo.png',
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Modern Cuisine, Traditional Flavors',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Serving Sierra Leone since 2020',
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
            
            // About us section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('About Us'),
                  const SizedBox(height: 15),
                  _buildParagraph(
                    'Way Li is a premier restaurant that specializes in modern and country food, offering a diverse range of culinary delights to satisfy every palate. Our commitment to quality and excellence has made us a favorite dining destination in Sierra Leone.',
                  ),
                  const SizedBox(height: 10),
                  _buildParagraph(
                    'We take pride in serving all types of non-alcoholic drinks, providing refreshing options to complement our delicious meals. At Way Li, we believe in creating a memorable dining experience that celebrates the rich flavors of our cuisine.',
                  ),
                  
                  const SizedBox(height: 30),
                  _buildSectionTitle('Our Location'),
                  const SizedBox(height: 15),
                  _buildInfoCard(
                    icon: Icons.location_on,
                    title: 'Head Office',
                    description: 'Rodin Street, Freetown, Sierra Leone',
                  ),
                  
                  const SizedBox(height: 30),
                  _buildSectionTitle('Opening Hours'),
                  const SizedBox(height: 15),
                  _buildTimeRow('Monday - Friday', '8:00 AM - 10:00 PM'),
                  _buildTimeRow('Saturday', '9:00 AM - 11:00 PM'),
                  _buildTimeRow('Sunday', '10:00 AM - 9:00 PM'),
                  
                  const SizedBox(height: 30),
                  _buildSectionTitle('Our Mission'),
                  const SizedBox(height: 15),
                  _buildParagraph(
                    'At Way Li, our mission is to provide exceptional dining experiences through innovative cuisine that honors traditional flavors. We are committed to using fresh, high-quality ingredients and delivering outstanding service in a welcoming atmosphere.',
                  ),
                  
                  const SizedBox(height: 30),
                  _buildSectionTitle('Contact Us'),
                  const SizedBox(height: 15),
                  _buildInfoCard(
                    icon: Icons.phone,
                    title: 'Phone',
                    description: '+232 79 123 4567',
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    icon: Icons.email,
                    title: 'Email',
                    description: 'info@wayli.com',
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    icon: Icons.language,
                    title: 'Website',
                    description: 'www.wayli.com',
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
                    '© 2023 Way Li Restaurant',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'All Rights Reserved',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: primaryColor.withOpacity(0.8),
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
  
  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 15,
        height: 1.5,
        color: Colors.grey.shade800,
      ),
    );
  }
  
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
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
      child: Row(
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
    );
  }
  
  Widget _buildTimeRow(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              Icons.access_time,
              color: secondaryColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              day,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: secondaryColor,
              ),
            ),
          ),
          Text(
            hours,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}