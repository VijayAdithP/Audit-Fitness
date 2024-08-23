import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Badconditionields extends StatelessWidget {
  const Badconditionields({
    super.key,
    this.hintText,
    required this.controller,
    this.hidden = false,
  });

  final String? hintText;
  final TextEditingController controller;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: hidden,
      maxLines: null,
      // minLines: 1,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: GoogleFonts.manrope(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
