import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthTextfields extends StatelessWidget {
  const AuthTextfields(
      {super.key, this.hintText, this.controller, this.hidden = false});

  final String? hintText;
  final TextEditingController? controller;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.transparent,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          top: 10,
        ),
        child: TextField(
          textInputAction: TextInputAction.done,
          controller: controller,
          obscureText: hidden,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.manrope(fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
