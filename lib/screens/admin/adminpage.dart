import 'dart:convert';
import 'package:auditfitnesstest/assets/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/admin/Tables/campus-progress-table.dart';
import 'package:auditfitnesstest/screens/admin/Weekly-Audit/weekly_audit_id_list.dart';
import 'package:auditfitnesstest/screens/admin/area_and_questions.dart';
import 'package:auditfitnesstest/screens/admin/Tables/submited_weekly_audits.dart';
import 'package:auditfitnesstest/screens/admin/viewing_pages.dart';
import 'package:auditfitnesstest/screens/auth_screen.dart';
import 'package:auditfitnesstest/screens/widgets/Admin-widgets/Weekly%20Audit/weekly_audit_dialog.dart';
import 'package:auditfitnesstest/screens/widgets/Admin-widgets/audit-id-cards.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AdminNavPage extends StatefulWidget {
  const AdminNavPage({super.key});

  @override
  State<AdminNavPage> createState() => _AdminNavPageState();
}

class _AdminNavPageState extends State<AdminNavPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this); // Add this class as an observer
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance
  //       .removeObserver(this); // Remove this class as an observer
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.detached ||
  //       state == AppLifecycleState.inactive) {
  //     _clearCache(); // Clear cache when app is going to be closed
  //   }
  // }

  // Future<void> _clearCache() async {
  //   try {
  //     final cacheDir = await getTemporaryDirectory();
  //     if (cacheDir.existsSync()) {
  //       cacheDir.deleteSync(recursive: true);
  //     }
  //   } catch (e) {
  //     print('Error clearing cache: $e');
  //   }
  // }

  final screens = [
    const AdminPage(),
    const AreaAndQuestionsPage(),
    const ViewingAdminPages(),
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer_(),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: greyblue,
            ),
          ),
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(
              color: greyblue,
              size: 25,
            ),
          ),
          height: 65,
        ),
        child: NavigationBar(
          backgroundColor: HexColor("#FFFFFF"),
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                size: 30,
              ),
              selectedIcon: Icon(
                Icons.home,
              ),
              label: Provider.of<LanguageProvider>(context).isTamil
                  ? "டாஷ்போர்டு"
                  : "Home",
            ),
            NavigationDestination(
                icon: Icon(
                  Icons.library_add_outlined,
                  size: 30,
                ),
                selectedIcon: Icon(
                  Icons.library_add,
                ),
                label: Provider.of<LanguageProvider>(context).isTamil
                    ? "சேர்க்க"
                    : "Areas"),
            NavigationDestination(
                icon: Icon(
                  Icons.group_add_outlined,
                  size: 30,
                ),
                selectedIcon: Icon(
                  Icons.group_add,
                ),
                label: Provider.of<LanguageProvider>(context).isTamil
                    ? "பயனர்கள்"
                    : "Users"),
          ],
        ),
        // BottomNavigationBar(
        //   backgroundColor: HexColor("#FFFFFF"),
        //   elevation: 0,
        //   currentIndex: _selectedIndex,
        //   onTap: _onItemTapped,
        //   selectedItemColor: HexColor("#034b93"),
        //   unselectedItemColor: Colors.black,
        //   // showSelectedLabels: false,
        //   showUnselectedLabels: false,
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.home,
        //         size: 30,
        //       ),
        //       label: 'Home',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.add,
        //         size: 30,
        //       ),
        //       label: 'Questions',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.person,
        //         size: 30,
        //       ),
        //       label: 'Users',
        //     ),
        //   ],
        // ),
      ),
      body: screens[_selectedIndex],
    );
  }
}

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
            // decoration: BoxDecoration(
            //   boxShadow: [
            //     BoxShadow(
            //       color: skyblue,
            //       spreadRadius: -40,
            //       blurRadius: 50,
            //       offset: const Offset(0, 4),
            //     ),
            //   ],
            //   borderRadius: const BorderRadius.all(
            //     Radius.circular(15),
            //   ),
            // ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerTheme: const DividerThemeData(color: Colors.transparent),
              ),
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: HexColor("#FFFFFF"),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey,
                  //     spreadRadius: -4,
                  //     blurRadius: 3,
                  //     offset: const Offset(0, 4),
                  //   ),
                  // ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    CircleAvatar(
                      radius: 30,
                      // backgroundImage: NetworkImage(
                      //   "https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg",
                      // ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg",
                          fit: BoxFit.fill,
                          placeholder: (context, url) => const Center(
                            child: SpinKitThreeBounce(
                              color: const Color.fromARGB(255, 130, 111, 238),
                              size: 10,
                            ),
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
                            // SizedBox(
                            //   width: 5,
                            // ),
                            Text(
                              Provider.of<LanguageProvider>(context).isTamil
                                  ? "நிர்வாகி"
                                  : "Admin",
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
            child: ExpansionTile(
              iconColor: darkblue,
              textColor: darkblue,
              collapsedIconColor: darkblue,
              collapsedTextColor: darkblue,
              shape: const Border(),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.date_range_outlined,
                  size: 30,
                  color: darkblue,
                ),
              ),
              title: Text(
                Provider.of<LanguageProvider>(context).isTamil
                    ? "சமீபத்தில் சேர்க்கப்பட்ட வேலைகள்"
                    : 'Recently Added Audits',
                style: TextStyle(
                  // fontWeight: FontWeight.w700,
                  color: darkblue,
                ),
              ),
              children: [
                // const Divider(),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text(
                    Provider.of<LanguageProvider>(context).isTamil
                        ? "வார வேலை"
                        : 'Weekly Audit',
                    style: TextStyle(
                      // fontWeight: FontWeight.w700,
                      color: darkblue,
                    ),
                  ),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WeeklyAuditListPage(),
                      ),
                    );
                  },
                ),
                // const Divider(),
                // ListTile(
                //   title: Text(
                //     Provider.of<LanguageProvider>(context).isTamil
                //         ? "மாதாந்திர தணிக்கை"
                //         : 'Monthly Audit',
                //     style: GoogleFonts.manrope(
                //       fontWeight: FontWeight.w700,
                //       color: Colors.black,
                //     ),
                //   ),
                //   onTap: () async {},
                // ),
              ],
            ),
          ),
          // const Divider(),
          SizedBox(
            height: 10,
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
                  color: darkblue,
                ),
              ),
              onTap: () {
                Provider.of<LanguageProvider>(context, listen: false)
                    .toggleLanguage();
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width,
          )),
          SizedBox(
            height: 10,
          ),
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
                  color: darkblue,
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
          ),
        ],
      ),
    );
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final box = GetStorage();

  List<Map<String, dynamic>> dailyAudits = [];

  DateTime selectedDate = DateTime.now();
  String selectedWeek = '';
  int year = 0;
  String month = '';

  DateTime campusselectedDate = DateTime.now();
  String campusselectedWeek = '';
  int campusyear = 0;
  String campusmonth = '';

  String _formatWeek(DateTime date) {
    int weekOfYear = _getWeekOfYear(date);
    setState(() {
      year = date.year;
    });
    List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    month = monthNames[date.month - 1];
    return weekOfYear.toString().padLeft(2, '0');
  }

  String _Campus_formatWeek(DateTime date) {
    int weekOfYear = _getWeekOfYear(date);
    setState(() {
      campusyear = date.year;
    });
    List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    campusmonth = monthNames[date.month - 1];
    return weekOfYear.toString().padLeft(2, '0');
  }

  int _getWeekOfYear(DateTime date) {
    var firstDayOfYear = DateTime(date.year, 1, 1);
    var daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    var weekNumber = ((daysSinceFirstDay + firstDayOfYear.weekday) / 7).ceil();
    return weekNumber;
  }

  void _weeklyshowDatePicker() async {
    DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: lighterbackgroundblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfDateRangePicker(
                  view: DateRangePickerView.month,
                  selectionMode: DateRangePickerSelectionMode.single,
                  initialSelectedDate: selectedDate,
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    Navigator.of(context).pop(args.value);
                  },
                  todayHighlightColor: greyblue,
                  backgroundColor: lighterbackgroundblue,
                  selectionTextStyle: TextStyle(
                    color: lighterbackgroundblue,
                    fontWeight: FontWeight.bold,
                  ),
                  selectionColor: greyblue,
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    todayTextStyle: TextStyle(
                      color: greyblue,
                      fontWeight: FontWeight.bold,
                    ),
                    textStyle: TextStyle(
                      color: greyblue,
                    ),
                  ),
                  headerStyle: DateRangePickerHeaderStyle(
                    backgroundColor: lighterbackgroundblue,
                    textStyle: TextStyle(
                      color: greyblue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(
                        color: greyblue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        selectedWeek = _formatWeek(selectedDate);
      });
      // Navigate to WeeklyReportPage after selecting the date
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeeklyReportPage(
            premonth: month,
            preweeknumber: selectedWeek,
            preyear: year.toString(),
            predate: selectedDate,
          ),
        ),
      );
    }
  }

  void _CampusshowDatePicker() async {
    DateTime? campuspickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: lighterbackgroundblue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfDateRangePicker(
                  view: DateRangePickerView.month,
                  selectionMode: DateRangePickerSelectionMode.single,
                  initialSelectedDate: campusselectedDate,
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    Navigator.of(context).pop(args.value);
                  },
                  todayHighlightColor: greyblue,
                  backgroundColor: lighterbackgroundblue,
                  selectionTextStyle: TextStyle(
                    color: lighterbackgroundblue,
                    fontWeight: FontWeight.bold,
                  ),
                  selectionColor: greyblue,
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    todayTextStyle: TextStyle(
                      color: greyblue,
                      fontWeight: FontWeight.bold,
                    ),
                    textStyle: TextStyle(
                      color: greyblue,
                    ),
                  ),
                  headerStyle: DateRangePickerHeaderStyle(
                    backgroundColor: lighterbackgroundblue,
                    textStyle: TextStyle(
                      color: greyblue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(
                        color: greyblue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (campuspickedDate != null) {
      setState(() {
        campusselectedDate = campuspickedDate;
        campusselectedWeek = _Campus_formatWeek(campusselectedDate);
      });

      // print(campusmonth);
      // print(campusselectedWeek);
      // print(campusyear.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Campusprogresstable(
            pre_month: campusmonth,
            pre_weeknumber: campusselectedWeek,
            pre_year: campusyear.toString(),
            pre_date: campusselectedDate,
          ),
        ),
      );
    }
  }

  String getWeekDateRange(int weekNumber, int year) {
    // Get the first day of the year
    DateTime firstDayOfYear = DateTime(year, 1, 1);

    // Calculate the start date of the week
    DateTime startOfWeek =
        firstDayOfYear.add(Duration(days: (weekNumber - 1) * 7));

    // Adjust to get the correct start of the week (Monday)
    startOfWeek = startOfWeek.subtract(Duration(days: startOfWeek.weekday - 1));

    // Calculate the end date of the week (Sunday)
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    // Format the date range
    String formattedRange = DateFormat('dd MMMM').format(startOfWeek) +
        ' To ' +
        DateFormat('dd MMMM').format(endOfWeek);

    return formattedRange;
  }

  @override
  Widget build(BuildContext context) {
    String username = box.read('username');
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
            resizeToAvoidBottomInset: false,
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
              // toolbarHeight: 70,
              toolbarHeight:
                  Provider.of<LanguageProvider>(context).isTamil ? 70 : 70,
              backgroundColor: Colors.white,
              // backgroundColor: Colors.red,
              titleSpacing: 0,
              title: Text(
                overflow: TextOverflow.visible,
                Provider.of<LanguageProvider>(context).isTamil
                    ? "நிர்வாக வேலை"
                    : "MANAGE YOUR TASKS",
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
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: MediaQuery.of(context).devicePixelRatio * 10,
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
                  //         child: Icon(
                  //           Icons.menu,
                  //           color: HexColor("#051739"),
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
                  //                 decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.all(
                  //                     Radius.circular(100),
                  //                   ),
                  //                   color: HexColor("#051739"),
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
                  //                         ? "நிர்வாகி"
                  //                         : 'Admin',
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
                  //                 style: TextStyle(
                  //                     color: HexColor("#051739"),
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
                  //     top: 10,
                  //     bottom: 10,
                  //   ),
                  // child: Text(
                  //   overflow: TextOverflow.visible,
                  //   Provider.of<LanguageProvider>(context).isTamil
                  //       ? "நிர்வாக வேலை"
                  //       : "MANAGE YOUR TASKS",
                  //   style: GoogleFonts.manrope(
                  //     color: HexColor("#051739"),
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
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
                        AuditCards(
                          background: lightbackgroundblue,
                          text1: Provider.of<LanguageProvider>(context).isTamil
                              ? "வேலை ஐடியை உருவாக்கவும்"
                              : "Weekly Audits Id",
                          text2: Provider.of<LanguageProvider>(context).isTamil
                              ? "சேர்க்க அழுத்தவும்"
                              : "Tap to add",
                          cardtitle:
                              Provider.of<LanguageProvider>(context).isTamil
                                  ? "வார வேலை"
                                  : "Weekly Audit",
                          navpage: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const WeeklyAuditDialog();
                                });
                          },
                        ),
                        // AuditCards(
                        //   // shadow: Colors.blue[300],
                        //   background: Colors.white,
                        //   text2: Provider.of<LanguageProvider>(context).isTamil
                        //       ? "தற்போது கிடைக்கவில்லை"
                        //       : "Not Avilable at the moment",
                        //   text1: Provider.of<LanguageProvider>(context).isTamil
                        //       ? "தணிக்கை ஐடியை உருவாக்கவும்"
                        //       : "Monthly Audit Id",
                        //   cardtitle: Provider.of<LanguageProvider>(context).isTamil
                        //       ? "மாதாந்திர தணிக்கை"
                        //       : "Monthly Audit",
                        //   navpage: () {
                        //     // showDialog(
                        //     //     context: context,
                        //     //     builder: (context) {
                        //     //       return StatefulBuilder(
                        //     //         builder: (BuildContext context, setState) {
                        //     //           return const MonthlyAuditDialog();
                        //     //         },
                        //     //       );
                        //     //     });
                        //   },
                        // ),
                        AuditCards(
                          // shadow: Colors.blue[300],
                          // background: HexColor("#006abd"),
                          background: lightbackgroundblue,
                          text2: Provider.of<LanguageProvider>(context).isTamil
                              ? "சேர்க்க அழுத்தவும்"
                              : "Tap to view",
                          text1: Provider.of<LanguageProvider>(context).isTamil
                              ? "வார வேலை அறிக்கைகள்"
                              : "Weekly Audit Reports",
                          cardtitle:
                              Provider.of<LanguageProvider>(context).isTamil
                                  ? "வார அறிக்கைகள்"
                                  : "Weekly Reports",
                          navpage: () {
                            _weeklyshowDatePicker();
                          },
                        ),
                        AuditCards(
                          background: lightbackgroundblue,
                          text2: Provider.of<LanguageProvider>(context).isTamil
                              ? "பார்க்க அழுத்தவும்"
                              : "Tap to view",
                          text1: Provider.of<LanguageProvider>(context).isTamil
                              ? "வளாக வேலை அறிக்கைகள்"
                              : "Campus Audit Reports",
                          cardtitle:
                              Provider.of<LanguageProvider>(context).isTamil
                                  ? "வளாக அறிக்கைகள்"
                                  : "Campus Reports",
                          navpage: () {
                            _CampusshowDatePicker();
                          },
                        ),
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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
