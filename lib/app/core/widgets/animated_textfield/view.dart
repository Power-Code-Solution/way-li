import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedHintTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Size size;

  const AnimatedHintTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.size,
  });

  @override
  State<AnimatedHintTextField> createState() => _AnimatedHintTextFieldState();
}

class _AnimatedHintTextFieldState extends State<AnimatedHintTextField> {
  bool showHint = true;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      final isEmpty = widget.controller.text.isEmpty;
      if (showHint != isEmpty) {
        setState(() {
          showHint = isEmpty;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: '',
            suffixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.grey),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.size.width * 0.04,
              vertical: widget.size.height * 0.015,
            ),
          ),
        ),
        if (showHint)
          Positioned(
            left: widget.size.width * 0.04 + 8,
            top: 16,
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'Search ....',
                  textStyle: GoogleFonts.montserrat(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              totalRepeatCount: 100000,
              pause: const Duration(milliseconds: 100),
              displayFullTextOnTap: false,
              stopPauseOnTap: false,
              isRepeatingAnimation: true,
            ),
          ),
      ],
    );
  }
}