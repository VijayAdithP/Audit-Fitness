import 'dart:convert';
import 'package:auditfitnesstest/assets/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:http/http.dart' as http;
import 'package:auditfitnesstest/screens/auth_screen.dart';
import 'package:auditfitnesstest/screens/campus/specific_task_list.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:flutter/material.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/widgets/Admin-widgets/audit-id-cards.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

// class CampusNavPage extends StatefulWidget {
//   const CampusNavPage({super.key});

//   @override
//   State<CampusNavPage> createState() => _CampusNavPageState();
// }

// class _CampusNavPageState extends State<CampusNavPage> {
//   int _currentTabIndex = 0;
//   final screens = [
//     const CampusPage(),
//     const AreaAndQuestionsPage(),
//     const ViewingAdminPages(),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(197, 197, 197, 1),
//       drawer: const Drawer_(),
//       body: screens[_currentTabIndex],
//       appBar: AppBar(
//         toolbarHeight: 100,
//         titleSpacing: 0,
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//         backgroundColor: Colors.purple[900],
//         title: Text(
//           overflow: TextOverflow.visible,
//           Provider.of<LanguageProvider>(context).isTamil
//               ? "நிர்வாக டாஷ்போர்டு"
//               : "Campus Dashboard",
//           style: GoogleFonts.manrope(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }

class Drawer_ extends StatefulWidget {
  const Drawer_({super.key});

  @override
  State<Drawer_> createState() => _Drawer_State();
}

class _Drawer_State extends State<Drawer_> {
  Future<void> fcmtokendelete() async {
    String FCMtoken = box.read('FCMtoken');
    var headers = {'Content-Type': 'application/json'};
    try {
      print("calling");
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.FCMtokendelete);

      var body = json.encode({
        "fcmtoken": FCMtoken,
      });

      var response = await http.delete(url, body: body, headers: headers);
      if (response.statusCode == 200) {
        print("all good");
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Opps!'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          });
    }
  }

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    String username = box.read('username');
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.2,
      backgroundColor: lighterbackgroundblue,
      child: Column(
        children: [
          Container(
            height: 200,
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerTheme: const DividerThemeData(color: Colors.transparent),
              ),
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    CircleAvatar(
                      radius: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg",
                          fit: BoxFit.fill,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 5,
                        ),
                        child: Row(
                          textBaseline: TextBaseline.alphabetic,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: darkblue,
                              ),
                            ),
                            Text(
                              Provider.of<LanguageProvider>(context).isTamil
                                  ? "வளாகம்"
                                  : "Campus",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                Icons.type_specimen_sharp,
                size: 30,
                color: darkblue,
              ),
              title: Text(
                Provider.of<LanguageProvider>(context).isTamil
                    ? "English"
                    : 'தமிழ்',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () {
                Provider.of<LanguageProvider>(context, listen: false)
                    .toggleLanguage();
              },
            ),
          ),
          // const Divider(),
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width,
          )),
          // const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                size: 30,
              ),
              title: Text(
                Provider.of<LanguageProvider>(context).isTamil
                    ? "வெளியேறு"
                    : 'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () async {
                // box.erase();
                fcmtokendelete();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                );
                box.write("role", "out");
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class CampusMainPage extends StatefulWidget {
  const CampusMainPage({super.key});

  @override
  State<CampusMainPage> createState() => _CampusMainPageState();
}

class _CampusMainPageState extends State<CampusMainPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CampusPage(),
      drawer: Drawer_(),
    );
  }
}

class CampusPage extends StatefulWidget {
  const CampusPage({super.key});

  @override
  State<CampusPage> createState() => _CampusPageState();
}

class _CampusPageState extends State<CampusPage> {
  final box = GetStorage();

  List<Map<String, dynamic>> dailyAudits = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
              // elevation: 2,
              // shadowColor: lightbackgroundblue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              toolbarHeight: 70,
              backgroundColor: Colors.white,
              // backgroundColor: Colors.red,
              titleSpacing: 0,
              title: Text(
                overflow: TextOverflow.visible,
                Provider.of<LanguageProvider>(context).isTamil
                    ? "உங்கள் பணிகள்"
                    : "YOUR TASKS",
                style: TextStyle(
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
            // drawer: Drawer_(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: MediaQuery.of(context).size.height / 17),
                // Padding(
                //   padding: const EdgeInsets.only(left: 15, right: 10, top: 10),
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
                //       Container(
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //             width: 1.5,
                //             color: Colors.grey,
                //           ),
                //           borderRadius: const BorderRadius.all(
                //             Radius.circular(40),
                //           ),
                //         ),
                //         child: Center(
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Container(
                //                 decoration: const BoxDecoration(
                //                   borderRadius: BorderRadius.all(
                //                     Radius.circular(100),
                //                   ),
                //                   color: Colors.black,
                //                 ),
                //                 child: Padding(
                //                   padding: const EdgeInsets.only(
                //                     left: 10,
                //                     right: 10,
                //                     top: 8,
                //                     bottom: 8,
                //                   ),
                //                   child: Text(
                //                     Provider.of<LanguageProvider>(context).isTamil
                //                         ? "வளாகம்"
                //                         : 'Campus',
                //                     style: const TextStyle(
                //                       color: Colors.white,
                //                       fontSize: 12,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               const SizedBox(
                //                 width: 5,
                //               ),
                //               Text(
                //                 username.capitalize(),
                //                 style: const TextStyle(
                //                     color: Colors.black,
                //                     fontWeight: FontWeight.bold,
                //                     fontSize: 15),
                //               ),
                //               const SizedBox(
                //                 width: 10,
                //               ),
                //             ],
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     left: 15,
                //     top: 15,
                //   ),
                //   child: Text(
                //     overflow: TextOverflow.visible,
                //     Provider.of<LanguageProvider>(context).isTamil
                //         ? "உங்கள் பணிகள்"
                //         : "YOUR TASKS",
                //     style: GoogleFonts.manrope(
                //       color: Colors.black,
                //       fontSize: Provider.of<LanguageProvider>(context).isTamil
                //           ? 27
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
                        ? "முக்கிய செயல்பாடுகள்"
                        : "Main functions",
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AuditCards(
                          icon: Icons.add,
                          background: lightbackgroundblue,
                          text2: Provider.of<LanguageProvider>(context).isTamil
                              ? "பார்க்க அழுத்தவும்"
                              : "Tap to view",
                          text1: Provider.of<LanguageProvider>(context).isTamil
                              ? "நிலுவையில் உள்ள வேலைகள்"
                              : "Pending Audits",
                          cardtitle:
                              Provider.of<LanguageProvider>(context).isTamil
                                  ? "வார வேலை"
                                  : "New Audits",
                          navpage: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SpecificTaskList(),
                              ),
                            );
                          },
                        ),
                      ),
                      // AuditCards(
                      //   text2: Provider.of<LanguageProvider>(context).isTamil
                      //       ? "சேர்க்க தட்டவும்"
                      //       : "Tap to view",
                      //   text1: Provider.of<LanguageProvider>(context).isTamil
                      //       ? "தணிக்கை ஐடியை உருவாக்கவும்"
                      //       : "Add Progress",
                      //   cardtitle: Provider.of<LanguageProvider>(context).isTamil
                      //       ? "வாராந்திர தணிக்கை"
                      //       : "Pending Audits",
                      //   navpage: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => const SpecificTaskList(),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
