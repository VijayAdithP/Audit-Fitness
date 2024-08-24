import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/auth_screen.dart';
import 'package:auditfitnesstest/screens/user/Weekly-Audit/weekly_user_audit_list.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/user_audit_cards.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Userpage extends StatefulWidget {
  const Userpage({super.key});

  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: _Drawer_(),
      body: UserHomePage(),
    );
  }
}

class _Drawer_ extends StatefulWidget {
  const _Drawer_({super.key});

  @override
  State<_Drawer_> createState() => __Drawer_State();
}

class __Drawer_State extends State<_Drawer_> {
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    final String username = box.read('username');
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
                      "https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg"),
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
          )
        ],
      ),
    );
  }
}

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeeklyTasksProvider>(context, listen: false)
          .fetchWeeklyTasks();
    });
    super.initState();
  }

  Future<void> _refreshTasks() async {
    // Trigger the fetch operation using the provider
    await Provider.of<WeeklyTasksProvider>(context, listen: false)
        .fetchWeeklyTasks();
  }

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    final weeklyTasksCount =
        Provider.of<WeeklyTasksProvider>(context).weeklyTasksCount;
    final String username = box.read('username');
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
                                      ? "பயனர்"
                                      : "User",
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
                  // bottom: 10,
                ),
                child: Text(
                  overflow: TextOverflow.visible,
                  Provider.of<LanguageProvider>(context).isTamil
                      ? "உங்கள் பணிகள்"
                      : "YOUR TASKS",
                  style: GoogleFonts.manrope(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshTasks,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      UserAuditCards(
                        bottomtext:
                            Provider.of<LanguageProvider>(context).isTamil
                                ? "பார்க்க"
                                : "Tap to see",
                        background: const Color.fromRGBO(135, 114, 255, 1),
                        cardtitle:
                            Provider.of<LanguageProvider>(context).isTamil
                                ? "வாராந்திர தணிக்கை"
                                : "Weekly Audit",
                        navpage: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const WeeklyUserAuditListPage(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Center(
                            child: Text(
                              weeklyTasksCount.toString(),
                              style: GoogleFonts.manrope(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      // UserAuditCards(
                      //   bottomtext:
                      //       Provider.of<LanguageProvider>(context).isTamil
                      //           ? "தற்போது கிடைக்கவில்லை"
                      //           : "Currently not available",
                      //   background: const Color.fromRGBO(130, 204, 146, 1),
                      //   cardtitle:
                      //       Provider.of<LanguageProvider>(context).isTamil
                      //           ? "மாதாந்திர  தணிக்கை"
                      //           : "Monthly Audit",
                      //   navpage: () {},
                      //   child: Center(
                      //       // child:
                      //       // Text(
                      //       //   weeklyTasksCount.toString(),
                      //       //   style: GoogleFonts.manrope(color: Colors.white),
                      //       // ),
                      //       ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
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
