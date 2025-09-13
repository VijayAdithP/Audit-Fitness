import 'package:flutter/material.dart';

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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class softtextfield extends StatelessWidget {
  const softtextfield({
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
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Color.fromRGBO(189, 189, 189, 1),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Color.fromRGBO(189, 189, 189, 1),
          ),
        ),
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
