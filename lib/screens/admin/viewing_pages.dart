import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/admin/add_users.dart';
import 'package:auditfitnesstest/screens/admin/viewing%20pages/delete_all_users.dart';
import 'package:auditfitnesstest/screens/admin/viewing%20pages/view_all_users.dart';
import 'package:auditfitnesstest/screens/widgets/Admin-widgets/audit-id-cards.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ViewingAdminPages extends StatefulWidget {
  const ViewingAdminPages({super.key});

  @override
  State<ViewingAdminPages> createState() => _ViewingAdminPagesState();
}

class _ViewingAdminPagesState extends State<ViewingAdminPages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(229, 229, 228, 1),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(229, 229, 228, 1),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(
              //   height: 50,
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: const Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                backgroundColor:
                                    const Color.fromRGBO(46, 46, 46, 1),
                                contentPadding: const EdgeInsets.all(20),
                                title: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        Provider.of<LanguageProvider>(context)
                                                .isTamil
                                            ? "தகவல்"
                                            : "INFO",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        Provider.of<LanguageProvider>(context)
                                                .isTamil
                                            ? "அனைத்து பயனர்கள் பற்றிய தகவல்"
                                            : "Info on all users",
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  Text(
                                    Provider.of<LanguageProvider>(context)
                                            .isTamil
                                        ? "அனைத்து பயனர் விவரங்களையும் பார்க்க, திருத்த, நீக்க மற்றும் புதுப்பிக்க கீழே உள்ள கார்டுகளைத் தட்டவும்"
                                        : "Tap the cards below to view, edit, delete and update all user detailes",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: const Icon(
                        Icons.info,
                        size: 25,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 10,
                ),
                child: Text(
                  overflow: TextOverflow.visible,
                  Provider.of<LanguageProvider>(context).isTamil
                      ? "அனைத்து பயனர்கள் \nபற்றிய தகவல்"
                      : "INFO ON ALL \nUSERS",
                  style: GoogleFonts.manrope(
                    color: Colors.black,
                    fontSize: Provider.of<LanguageProvider>(context).isTamil
                        ? 25
                        : 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    AuditCards(
                      background: Colors.white,
                      text2: Provider.of<LanguageProvider>(context).isTamil
                          ? "பார்க்க"
                          : "Tap to edit",
                      text1: Provider.of<LanguageProvider>(context).isTamil
                          ? "பயனர்களைத் திருத்துவதற்கு"
                          : "Edit Users",
                      cardtitle: Provider.of<LanguageProvider>(context).isTamil
                          ? "அனைத்து பயனாளர்கள்"
                          : "All Users",
                      navpage: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ViewAllUsers(),
                          ),
                        );
                      },
                    ),
                    AuditCards(
                      background: Colors.white,
                      text1: Provider.of<LanguageProvider>(context).isTamil
                          ? "பயனர்களைச் சேர்க்கவும்"
                          : "Add Users",
                      text2: Provider.of<LanguageProvider>(context).isTamil
                          ? "பார்க்க"
                          : "Tap to add",
                      cardtitle: Provider.of<LanguageProvider>(context).isTamil
                          ? "அனைத்து பயனாளர்கள்"
                          : "All Users",
                      navpage: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddUsers(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
