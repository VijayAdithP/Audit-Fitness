import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuditCards extends StatelessWidget {
  AuditCards({
    required this.cardtitle,
    super.key,
    required this.text1,
    required this.text2,
    required this.navpage,
    this.background,
    this.icon = Icons.add,
    this.shadow = const Color.fromRGBO(158, 158, 158, 1),
  });
  final String? text1;
  final String? text2;
  final String? cardtitle;
  final void Function() navpage;
  final Color? background;
  final Color? shadow;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navpage,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            color: background,
            boxShadow: [
              BoxShadow(
                color: shadow!,
                spreadRadius: -5,
                blurRadius: 5,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1 ?? "null",
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      Provider.of<LanguageProvider>(context).isTamil ? 22 : 25,
                ),
              ),
              Text(
                text2 ?? "null",
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Expanded(child: Container()),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
