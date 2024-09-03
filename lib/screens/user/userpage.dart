import 'dart:convert';
import 'package:auditfitnesstest/assets/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:http/http.dart' as http;
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/auth_screen.dart';
import 'package:auditfitnesstest/screens/user/Weekly-Audit/weekly_user_audit_list.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/user_audit_cards.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

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

  @override
  Widget build(BuildContext context) {
    final String username = box.read('username');
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
                                  ? "பயனர்"
                                  : "User",
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
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.type_specimen_sharp,
                  size: 30,
                  color: darkblue,
                ),
              ),
              title: Text(
                Provider.of<LanguageProvider>(context).isTamil
                    ? "English"
                    : 'தமிழ்',
                style: TextStyle(
                    // fontWeight: FontWeight.w700,
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
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.logout_outlined,
                  size: 30,
                  color: darkblue,
                ),
              ),
              title: Text(
                Provider.of<LanguageProvider>(context).isTamil
                    ? "வெளியேறு"
                    : 'Logout',
                style: TextStyle(
                    // fontWeight: FontWeight.w700,
                    ),
              ),
              onTap: () {
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
            body: Column(
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
                //                         ? "பயனர்"
                //                         : "User",
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
                //     // bottom: 10,
                //   ),
                //   child: Text(
                //     overflow: TextOverflow.visible,
                //     Provider.of<LanguageProvider>(context).isTamil
                //         ? "உங்கள் பணிகள்"
                //         : "YOUR TASKS",
                //     style: GoogleFonts.manrope(
                //       color: Colors.black,
                //       fontSize: 30,
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
                  child: RefreshIndicator(
                    onRefresh: _refreshTasks,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          badges.Badge(
                            badgeContent: Text(
                              weeklyTasksCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            position:
                                badges.BadgePosition.topEnd(top: -10, end: 0),
                            badgeStyle: badges.BadgeStyle(
                              padding: EdgeInsets.all(
                                  14), // Increase padding for a larger badge
                              badgeColor:
                                  Colors.red, // Adjust badge color if needed
                              elevation:
                                  1, // Optional: Remove shadow for a flat look
                            ),
                            child: UserAuditCards(
                              bottomtext:
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "பார்க்க அழுத்தவும்"
                                      : "Tap to see",
                              background: lightbackgroundblue,
                              cardtitle:
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "வார வேலை"
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
                                backgroundColor: Colors.transparent,
                                // child: Center(
                                //   child: Text(
                                //     weeklyTasksCount.toString(),
                                //     style:
                                //         GoogleFonts.manrope(color: Colors.white),
                                //   ),
                                // ),
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
