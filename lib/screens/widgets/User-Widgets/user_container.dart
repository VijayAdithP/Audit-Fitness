import 'package:flutter/material.dart';

class UserContainer extends StatelessWidget {
  const UserContainer({
    super.key,
    this.inside,
    this.length = 110,
    this.color = const Color(0xFF9E9E9E),
  });

  final Widget? inside;
  final double? length;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color!,
          ),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: inside,
    );
  }
}
