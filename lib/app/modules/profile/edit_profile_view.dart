import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/newpages/components/colors.dart';

class EditProfileView extends StatefulWidget {
  static const String routeName = '/profile-edit';
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  late TextEditingController _fullnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  bool _isLoading = false;

  // State variable to track the current initials
  String _currentInitials = 'U';

  @override
  void initState() {
    super.initState();

    // Fetch the latest user profile data
    _fetchUserProfile();

    // Add listener to update initials when name changes
    _fullnameController = TextEditingController();
    _fullnameController.addListener(_updateInitials);
  }

  // Method to update initials when name changes
  void _updateInitials() {
    if (!mounted) return;

    setState(() {
      String fullName = _fullnameController.text;
      _currentInitials = _getInitialsFromName(fullName);
    });
  }

  // Helper method to extract initials from a name
  String _getInitialsFromName(String fullName) {
    String initials = '';
    if (fullName.isNotEmpty) {
      List<String> nameParts = fullName.split(' ');
      if (nameParts.isNotEmpty) {
        // Add first letter of first name
        if (nameParts[0].isNotEmpty) {
          initials += nameParts[0][0].toUpperCase();
        }
        // Add first letter of last name if available
        if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
          initials += nameParts[1][0].toUpperCase();
        }
      }
    }
    // Default to 'U' if no initials could be extracted
    return initials.isEmpty ? 'U' : initials;
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    await authController.fetchUserProfile();

    // Initialize controllers with current user data
    final userData = authController.getCompleteUserData();

    // Initialize other controllers
    _emailController = TextEditingController(text: userData['email'] ?? '');
    _phoneController = TextEditingController(text: userData['phone'] ?? '');
    _addressController = TextEditingController(text: userData['address'] ?? '');

    // Set text for fullname controller (already initialized in initState)
    _fullnameController.text = userData['fullname'] ?? '';

    // Update initials based on the name
    _updateInitials();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // Remove listener before disposing
    _fullnameController.removeListener(_updateInitials);

    // Dispose all controllers
    _fullnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Get the auth token
        final token = await authController.getToken();
        if (token == null) {
          Get.snackbar("Error", "You are not logged in");
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Prepare the request body
        final requestBody = {
          "fullname": _fullnameController.text,
          "email": _emailController.text,
          "phone": _phoneController.text,
        };

        // Add address if provided
        if (_addressController.text.isNotEmpty) {
          requestBody["address"] = _addressController.text;
        }

        print("Update profile payload: ${jsonEncode(requestBody)}");

        // Make the API call
        final response = await http.post(
          Uri.parse("$apiBaseAddress/secure/admin/user/update"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode(requestBody),
        );

        print("Update profile response: ${response.body}");

        if (response.statusCode == 200) {
          final parsedResponse = jsonDecode(response.body);

          if (parsedResponse["status"] == 1) {
            final updatedUserData = parsedResponse["data"];

            // Update the user data in memory
            authController.userData.value = Map<String, dynamic>.from(updatedUserData);
            authController.userName.value = updatedUserData["fullname"] ?? '';
            authController.userEmail.value = updatedUserData["email"] ?? '';
            authController.userPhone.value = updatedUserData["phone"] ?? '';

            // Save the updated user data to SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_id', updatedUserData["id"]?.toString() ?? '');
            await prefs.setString('user_email', updatedUserData["email"] ?? '');
            await prefs.setString('user_name', updatedUserData["fullname"] ?? '');
            await prefs.setString('user_phone', updatedUserData["phone"] ?? '');
            await prefs.setString('user_role', updatedUserData["role"] ?? '');
            await prefs.setString('user_data', jsonEncode(updatedUserData));

            Get.snackbar("Success", "Profile updated successfully");
            Get.back();
          } else {
            Get.snackbar("Error", parsedResponse["message"] ?? "Failed to update profile");
          }
        } else {
          // Handle error response
          try {
            final errorResponse = jsonDecode(response.body);
            Get.snackbar("Error", errorResponse["message"] ?? "Failed to update profile");
          } catch (e) {
            Get.snackbar("Error", "Failed to update profile");
          }
        }
      } catch (e) {
        Get.snackbar("Error", e.toString());
        print('Update profile error: $e');
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
        title: Text('Edit Profile',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile picture
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: mainYellow,
                              child: Text(
                                _currentInitials,
                                style: const TextStyle(fontSize: 40, color: Colors.white),
                              ),
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: mainYellow,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, size: 20),
                                color: Colors.white,
                                onPressed: () {
                                  // TODO: Implement image picker
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Full Name
                      Text(
                        'Full Name',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _fullnameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your full name',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email
                      Text(
                        'Email',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
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

                      // Phone
                      Text(
                        'Phone',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Enter your phone number',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Address
                      Text(
                        'Address',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter your address',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainYellow,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Save Changes',
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
    );
  }
}
