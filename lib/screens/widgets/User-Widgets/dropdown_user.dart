import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../models/locale_provider.dart';

class DropdownUser extends StatefulWidget {
  final ValueChanged<String?>? onChanged;

  const DropdownUser({super.key, this.onChanged});

  @override
  State<DropdownUser> createState() => _DropdownUserState();
}

class _DropdownUserState extends State<DropdownUser> {
  final box = GetStorage();

  String? selectedCondition;

  final Color goodConditionColor = const Color.fromRGBO(130, 204, 146, 1);
  final Color badConditionColor = const Color.fromARGB(213, 255, 97, 86);
  final Color defaultColor = Colors.white;
  final Color defaultfontColor = Colors.grey[800]!;
  final Color goodfontColor = Colors.grey[800]!;
  final Color badfontColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    Color containerColor;
    Color fontColor;
    switch (selectedCondition) {
      case 'good':
        containerColor = goodConditionColor;
        fontColor = goodfontColor;
        break;
      case 'bad':
        containerColor = badConditionColor;
        fontColor = badfontColor;
        break;
      default:
        containerColor = defaultColor;
        fontColor = defaultfontColor;
    }

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(
          color: Colors.grey[400]!,
        ),
      ),
      child: Center(
        child: DropdownButton<String>(
          // alignment: Alignment.bottomCenter,
          hint: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              top: 10,
              bottom: 10,
              right: 20,
            ),
            child: Text(
              Provider.of<LanguageProvider>(context).isTamil
                  ? "நிலை"
                  : "Condition",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),

          underline: const SizedBox(),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          dropdownColor: Colors.white,
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
          isExpanded: true,
          value: selectedCondition,
          elevation: 1,
          onChanged: (String? newValue) {
            setState(() {
              selectedCondition = newValue;
            });
            widget.onChanged?.call(newValue);
          },
          items: <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(
              value: 'good',
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  top: 10,
                  bottom: 10,
                ),
                child: Text(
                  Provider.of<LanguageProvider>(context).isTamil
                      ? "நல்ல நிலை"
                      : 'Good condition',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    // color: fontColor,
                  ),
                ),
              ),
            ),
            DropdownMenuItem<String>(
              value: 'bad',
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  top: 10,
                  bottom: 10,
                ),
                child: Text(
                  Provider.of<LanguageProvider>(context).isTamil
                      ? "மோசமான நிலை"
                      : 'Bad Condition',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    // color: fontColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
