import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';

Future<void> showNotificationEmptyDialog() {
  return Get.dialog<void>(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Notifications',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: secondaryColor,
        ),
      ),
      content: Text(
        'Notification Empty',
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[700],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back<void>(),
          child: Text(
            'OK',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: secondaryColor,
            ),
          ),
        ),
      ],
    ),
    barrierDismissible: true,
  );
}
