import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/colors.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Settings',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          // Profile Section
          _buildSectionHeader('Profile'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: mainYellow,
                        child: Text('U',
                            style:
                                TextStyle(fontSize: 32, color: Colors.white)),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: mainYellow,
                        child: IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 12),
                  Text(
                    'User Name',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                  Text(
                    'Email: user@example.com',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                  Text(
                    'Phone: ***********70',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Edit Profile',
                          style: GoogleFonts.poppins(
                              color: Colors.red[400], fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Notifications Section
          _buildSectionHeader('Contact Us'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: Text('Contact Us', style: GoogleFonts.poppins()),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text('Terms & Privacy', style: GoogleFonts.poppins()),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text('Privacy Policy', style: GoogleFonts.poppins()),
                )
              ],
            ),
          ),

          // Privacy & Security Section
          _buildSectionHeader('Privacy & Security'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: Text('Change Password', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title:
                      Text('Enable Biometrics', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_outline),
                  title:
                      Text('Favorite Location', style: GoogleFonts.poppins()),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_outline),
                  title: Text('FAQ', style: GoogleFonts.poppins()),
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Account Section
          _buildSectionHeader('Account'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red[400]),
                  title: Text('Delete Account',
                      style: GoogleFonts.poppins(color: Colors.red[400])),
                  onTap: () {},
                ),
                const Divider(height: 0),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red[400]),
                  title: Text('Logout',
                      style: GoogleFonts.poppins(color: Colors.red[400])),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
