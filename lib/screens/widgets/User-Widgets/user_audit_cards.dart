import 'package:auditfitnesstest/assets/colors.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAuditCards extends StatelessWidget {
  const UserAuditCards({
    required this.cardtitle,
    required this.bottomtext,
    super.key,
    required this.navpage,
    this.background,
    required this.child,
  });
  final String? cardtitle;
  final String? bottomtext;
  final void Function() navpage;
  final Color? background;
  // final Color? fontcolro;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navpage,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // height: 150,
          decoration: BoxDecoration(
            color: background,
            // boxShadow: [
            //   BoxShadow(
            //     offset: Offset.fromDirection(7, 1.0),
            //     color: Colors.grey[500]!,
            //   ),
            // ],
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cardtitle!,
                style: TextStyle(
                  fontSize:
                      Provider.of<LanguageProvider>(context).isTamil ? 23 : 25,
                  fontWeight: FontWeight.bold,
                  color: greyblue,
                ),
              ),
              Text(
                bottomtext!,
                style: TextStyle(
                  fontSize:
                      Provider.of<LanguageProvider>(context).isTamil ? 13 : 15,
                  fontWeight: FontWeight.bold,
                  color: greyblue,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [child],
              )
            ],
          ),
        ),
      ),
    );
  }
}
