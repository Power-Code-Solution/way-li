import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/newpages/components/colors.dart';

class ContactUsView extends StatefulWidget {
  static const String routeName = '/contact-us';
  const ContactUsView({Key? key}) : super(key: key);

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Prepare the request payload
        final payload = {
          "name": _nameController.text,
          "email": _emailController.text,
          "message": _messageController.text,
        };

        print("Sending contact form: ${jsonEncode(payload)}");

        // Make the API call
        final response = await http.post(
          Uri.parse("$apiBaseAddress/contact/send"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(payload),
        );

        print("Contact form response: ${response.body}");

        if (response.statusCode == 200) {
          final parsedResponse = jsonDecode(response.body);

          if (parsedResponse["status"] == 1) {
            // Success
            Get.snackbar(
              'Success',
              parsedResponse["data"] ?? 'Your message has been sent successfully!',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );

            // Clear form fields
            _nameController.clear();
            _emailController.clear();
            _messageController.clear();
          } else {
            // API returned an error
            Get.snackbar(
              'Error',
              parsedResponse["message"] ?? 'Failed to send message',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          // HTTP error
          Get.snackbar(
            'Error',
            'Failed to send message. Please try again later.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        // Exception occurred
        print('Contact form error: $e');
        Get.snackbar(
          'Error',
          'An error occurred: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Contact Us',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/way-li-logo.png'),
                      fit: BoxFit.cover,
                    ),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.3),
                    //     spreadRadius: 2,
                    //     blurRadius: 5,
                    //     offset: const Offset(0, 3),
                    //   ),
                    // ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
                      Text(
                        'Restaurant Information',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.location_on_outlined,
                        'Address',
                        '12 Rodin Street, Freetown, Sierra Leone',
                        onTap: () => _launchUrl('https://maps.google.com?q=12+Rodin+Street,+Freetown,+Sierra+Leone')
                      ),
                      _buildInfoRow(
                          Icons.location_on_outlined,
                          'Address',
                          '12 Rodin Street, Freetown, Sierra Leone',
                          onTap: () => _launchUrl('https://maps.google.com?q=12+Rodin+Street,+Freetown,+Sierra+Leone')
                      ),
                      const Divider(),
                      _buildInfoRow(
                        Icons.phone_outlined,
                        'Phone',
                        '+232 79 366 751',
                        onTap: () => _launchUrl('tel:+23279366751'),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        Icons.email_outlined,
                        'Email',
                        'info@wayli.com',
                        onTap: () => _launchUrl('mailto:info@wayli.com'),
                      ),
                      const Divider(),
                      _buildInfoRow(
                        Icons.access_time,
                        'Opening Hours',
                        'Mon-Fri: 9:00 AM - 10:00 PM\nSat-Sun: 10:00 AM - 11:00 PM',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Social Media Links
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
                      Text(
                        'Follow Us',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSocialButton(
                            'Facebook',
                            Icons.facebook,
                            Colors.blue,
                            () => _launchUrl('https://facebook.com'),
                          ),
                          _buildSocialButton(
                            'Instagram',
                            Icons.camera_alt,
                            Colors.purple,
                            () => _launchUrl('https://instagram.com'),
                          ),
                          _buildSocialButton(
                            'Twitter',
                            Icons.flutter_dash,
                            Colors.blue[300]!,
                            () => _launchUrl('https://twitter.com'),
                          ),
                          _buildSocialButton(
                            'WhatsApp',
                            Icons.call,
                            Colors.green,
                            () => _launchUrl(whatSappLink),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Contact Form
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Send Us a Message',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter your name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!GetUtils.isEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _messageController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            hintText: 'Enter your message',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your message';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainYellow,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: Colors.grey,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Send Message',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Map (Placeholder)
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Find Us',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.map,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Map View',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                _launchUrl('https://maps.google.com');
                              },
                              icon: const Icon(Icons.directions),
                              label: const Text('Get Directions'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainYellow,
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String content, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: mainYellow, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String name, IconData icon, Color color, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
