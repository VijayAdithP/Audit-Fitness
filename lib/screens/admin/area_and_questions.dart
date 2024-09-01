import 'package:auditfitnesstest/assets/colors.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/admin/Questions%20and%20Areas/add_questions-areas.dart';
import 'package:auditfitnesstest/screens/widgets/Admin-widgets/audit-id-cards.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class AreaAndQuestionsPage extends StatefulWidget {
  const AreaAndQuestionsPage({super.key});

  @override
  State<AreaAndQuestionsPage> createState() => _AreaAndQuestionsPageState();
}

class _AreaAndQuestionsPageState extends State<AreaAndQuestionsPage> {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String FCMtoken = box.read('FCMtoken');
    return Container(
      color: HexColor("#FFFFFF"),
      child: SafeArea(
        child: DoubleBackToCloseApp(
          snackBar: SnackBar(
            duration: Duration(
              milliseconds: 700,
            ),
            dismissDirection: DismissDirection.startToEnd,
            shape: StadiumBorder(),
            content: Text("Tap again to exit the app"),
            behavior: SnackBarBehavior.floating,
          ),
          child: Scaffold(
            backgroundColor: lighterbackgroundblue,
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              toolbarHeight:
                  Provider.of<LanguageProvider>(context).isTamil ? 70 : 70,
              backgroundColor: Colors.white,
              // backgroundColor: Colors.red,
              titleSpacing: 0,
              title: Text(
                overflow: TextOverflow.visible,
                Provider.of<LanguageProvider>(context).isTamil
                    ? "பகுதிகளை உருவாக்கவும்"
                    : "CREATE AREAS",
                style: GoogleFonts.manrope(
                  color: darkblue,
                  fontWeight: FontWeight.bold,
                  fontSize:
                      Provider.of<LanguageProvider>(context).isTamil ? 18 : 21,
                ),
              ),
              leading: InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  color: darkblue,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(
                  //   height: 50,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       InkWell(
                  //         onTap: () {
                  //           Scaffold.of(context).openDrawer();
                  //         },
                  //         child: const Icon(
                  //           Icons.menu,
                  //           color: Colors.black,
                  //           size: 30,
                  //         ),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           showDialog(
                  //               context: context,
                  //               builder: (context) {
                  //                 return SimpleDialog(
                  //                   backgroundColor:
                  //                       const Color.fromRGBO(46, 46, 46, 1),
                  //                   contentPadding: const EdgeInsets.all(20),
                  //                   title: Column(
                  //                     children: [
                  //                       Align(
                  //                         alignment: Alignment.center,
                  //                         child: Text(
                  //                           Provider.of<LanguageProvider>(context)
                  //                                   .isTamil
                  //                               ? "தகவல்"
                  //                               : "INFO",
                  //                           style: const TextStyle(
                  //                             fontSize: 20,
                  //                             fontWeight: FontWeight.bold,
                  //                             color: Colors.blueAccent,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       const SizedBox(
                  //                         height: 5,
                  //                       ),
                  //                       Align(
                  //                         alignment: Alignment.center,
                  //                         child: Text(
                  //                           textAlign: TextAlign.center,
                  //                           Provider.of<LanguageProvider>(context)
                  //                                   .isTamil
                  //                               ? "பகுதிகள் மற்றும் கேள்விகளை உருவாக்கவும்"
                  //                               : "Create areas and questions",
                  //                           style: const TextStyle(
                  //                             fontSize: 17,
                  //                             fontWeight: FontWeight.bold,
                  //                             color: Colors.white,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   children: [
                  //                     Text(
                  //                       Provider.of<LanguageProvider>(context)
                  //                               .isTamil
                  //                           ? "குறிப்பிட்ட பகுதிகள் மற்றும் குறிப்பிட்ட பகுதிகளுக்கான பிரத்யேக கேள்விகளைச் சேர்க்க, கீழே உள்ள கார்டுகளைத் தட்டவும்"
                  //                           : "To add specific areas and dedicated question for those specific areas tap on the cards below",
                  //                       style: const TextStyle(
                  //                         fontSize: 17,
                  //                         // fontWeight: FontWeight.bold,
                  //                         color: Colors.white,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 );
                  //               });
                  //         },
                  //         child: const Icon(
                  //           Icons.info,
                  //           size: 25,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //     left: 15,
                  //     bottom: 10,
                  //   ),
                  //   child: Text(
                  //     overflow: TextOverflow.visible,
                  //     Provider.of<LanguageProvider>(context).isTamil
                  //         ? "பகுதிகள் மற்றும் கேள்விகளை உருவாக்கவும்"
                  //         : "CREATE AREAS AND QUESTIONS",
                  //     style: GoogleFonts.manrope(
                  //       color: Colors.black,
                  //       fontSize: Provider.of<LanguageProvider>(context).isTamil
                  //           ? 25
                  //           : 30,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      top: 20,
                    ),
                    child: Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "செயல்கள்"
                          : "Actions",
                      style: TextStyle(
                        fontSize: 20,
                        color: darkblue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        AuditCards(
                          background: lightbackgroundblue,
                          text2: Provider.of<LanguageProvider>(context).isTamil
                              ? "சேர்க்க அழுத்தவும்"
                              : "Tap to add",
                          text1: Provider.of<LanguageProvider>(context).isTamil
                              ? "பகுதிகளை உருவாக்கவும்"
                              : "Create Areas",
                          cardtitle:
                              Provider.of<LanguageProvider>(context).isTamil
                                  ? "கேள்விகள் மற்றும் பகுதிகள்"
                                  : "Questions and Areas",
                          navpage: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AddQuestionAndAreas(),
                              ),
                            );
                          },
                        ),
                        // AuditCards(
                        //   background: Colors.white,
                        //   text1: Provider.of<LanguageProvider>(context).isTamil
                        //       ? "பகுதிகளைத் திருத்தவும்"
                        //       : "Edit Areas",
                        //   text2: Provider.of<LanguageProvider>(context).isTamil
                        //       ? "திருத்த"
                        //       : "Tap to edit",
                        //   cardtitle: Provider.of<LanguageProvider>(context).isTamil
                        //       ? "கேள்விகள் மற்றும் பகுதிகள்"
                        //       : "Questions and Areas",
                        //   navpage: () {},
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
