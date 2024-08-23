import 'package:auditfitnesstest/screens/auth_screen.dart';
import 'package:auditfitnesstest/screens/campus/specific_task_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/widgets/Admin-widgets/audit-id-cards.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    String username = box.read('username');
    return Drawer(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    "https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      username,
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.type_specimen_sharp,
              size: 30,
              color: Colors.black,
            ),
            title: Text(
              Provider.of<LanguageProvider>(context).isTamil
                  ? "English"
                  : 'தமிழ்',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Provider.of<LanguageProvider>(context, listen: false)
                  .toggleLanguage();
            },
          ),
          const Divider(),
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width,
          )),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
              size: 30,
            ),
            title: Text(
              Provider.of<LanguageProvider>(context).isTamil
                  ? "வெளியேறு"
                  : 'Logout',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.clear();
              // box.erase();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
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

  @override
  void initState() {
    super.initState();
  }

  List<Map<String, dynamic>> dailyAudits = [];

  @override
  Widget build(BuildContext context) {
    final String username = box.read('username');
    return Scaffold(
      backgroundColor: const Color.fromRGBO(229, 229, 228, 1),
      drawer: Drawer_(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 17),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) {
                    return InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: const Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 30,
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: Colors.grey,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            color: Colors.black,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Text(
                              Provider.of<LanguageProvider>(context).isTamil
                                  ? "வளாகம்"
                                  : 'Campus',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          username.capitalize(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              top: 15,
            ),
            child: Text(
              overflow: TextOverflow.visible,
              Provider.of<LanguageProvider>(context).isTamil
                  ? "உங்கள் பணிகள்"
                  : "YOUR TASKS",
              style: GoogleFonts.manrope(
                color: Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                AuditCards(
                  icon: Icons.add,
                  background: const Color.fromARGB(255, 130, 111, 238),
                  text2: Provider.of<LanguageProvider>(context).isTamil
                      ? "பார்க்க"
                      : "Tap to view",
                  text1: Provider.of<LanguageProvider>(context).isTamil
                      ? "நிலுவையில் உள்ள தணிக்கைகள்"
                      : "Pending Audits",
                  cardtitle: Provider.of<LanguageProvider>(context).isTamil
                      ? "வாராந்திர தணிக்கை"
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
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
