import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/admin/Tables/campus-progress-table.dart';
import 'package:auditfitnesstest/screens/admin/Weekly-Audit/weekly_audit_id_list.dart';
import 'package:auditfitnesstest/screens/admin/area_and_questions.dart';
import 'package:auditfitnesstest/screens/admin/Tables/submited_weekly_audits.dart';
import 'package:auditfitnesstest/screens/admin/viewing_pages.dart';
import 'package:auditfitnesstest/screens/auth_screen.dart';
import 'package:auditfitnesstest/screens/widgets/Admin-widgets/Weekly%20Audit/weekly_audit_dialog.dart';
import 'package:auditfitnesstest/screens/widgets/Admin-widgets/audit-id-cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AdminNavPage extends StatefulWidget {
  const AdminNavPage({super.key});

  @override
  State<AdminNavPage> createState() => _AdminNavPageState();
}

class _AdminNavPageState extends State<AdminNavPage> {
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
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(229, 229, 228, 1),
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              // SvgPicture.asset(
              //   'lib/assets/icons/icons8-home.svg',
              //   semanticsLabel: 'My SVG Image',
              //   width: 25,
              // ),
              // activeIcon: SvgPicture.asset(
              //   'lib/assets/icons/icons8-home.svg',
              //   semanticsLabel: 'My SVG Image',
              //   width: 25,
              //   color: Colors.black,
              // ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                size: 25,
              ),
              label: 'Questions',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 25,
              ),
              label: 'Users',
            ),
          ],
        ),
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
          // ListTile(
          //   leading: const Icon(
          //     Icons.add,
          //     size: 30,
          //     color: Colors.black,
          //   ),
          //   title: Text(
          //     Provider.of<LanguageProvider>(context).isTamil
          //         ? "பயனரைச் சேர்க்கவும்"
          //         : 'Add Users',
          //     style: GoogleFonts.manrope(
          //       fontWeight: FontWeight.w700,
          //       color: Colors.black,
          //     ),
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const AddUsers(),
          //       ),
          //     );
          //   },
          // ),
          // const Divider(),
          ExpansionTile(
            iconColor: Colors.black,
            textColor: Colors.black,
            collapsedIconColor: Colors.black,
            collapsedTextColor: Colors.black,
            shape: const Border(),
            leading: const Icon(
              Icons.date_range_outlined,
              size: 30,
              color: Colors.black,
            ),
            title: Text(
              Provider.of<LanguageProvider>(context).isTamil
                  ? "சமீபத்தில் சேர்க்கப்பட்ட தணிக்கைகள்"
                  : 'Recently Added Audits',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w700,
              ),
            ),
            children: [
              const Divider(),
              ListTile(
                title: Text(
                  Provider.of<LanguageProvider>(context).isTamil
                      ? "வாராந்திர தணிக்கை"
                      : 'Weekly Audit',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
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
              const Divider(),
              ListTile(
                title: Text(
                  Provider.of<LanguageProvider>(context).isTamil
                      ? "மாதாந்திர தணிக்கை"
                      : 'Monthly Audit',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                onTap: () async {},
              ),
            ],
          ),
          const Divider(),
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
                color: Colors.black,
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
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 400,
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedDate: selectedDate,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  Navigator.of(context).pop(args.value);
                },
                todayHighlightColor: Colors.white,
                backgroundColor: Colors.black,
                selectionTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                selectionColor: Colors.white,
                monthCellStyle: const DateRangePickerMonthCellStyle(
                  todayTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                headerStyle: const DateRangePickerHeaderStyle(
                  backgroundColor: Colors.black,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
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
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 400,
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedDate: campusselectedDate,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  Navigator.of(context).pop(args.value);
                },
                todayHighlightColor: Colors.white,
                backgroundColor: Colors.black,
                selectionTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                selectionColor: Colors.white,
                monthCellStyle: const DateRangePickerMonthCellStyle(
                  todayTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                headerStyle: const DateRangePickerHeaderStyle(
                  backgroundColor: Colors.black,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
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
      color: const Color.fromRGBO(229, 229, 228, 1),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromRGBO(229, 229, 228, 1),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: MediaQuery.of(context).devicePixelRatio * 10,
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
                                      ? "நிர்வாகி"
                                      : 'Admin',
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
                  top: 10,
                  bottom: 10,
                ),
                child: Text(
                  overflow: TextOverflow.visible,
                  Provider.of<LanguageProvider>(context).isTamil
                      ? "நிர்வாக டாஷ்போர்டு"
                      : "MANAGE YOUR TASKS",
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
                      // shadow: Colors.blue[300],
                      background: Colors.white,
                      text1: Provider.of<LanguageProvider>(context).isTamil
                          ? "தணிக்கை ஐடியை உருவாக்கவும்"
                          : "Weekly Audits Id",
                      text2: Provider.of<LanguageProvider>(context).isTamil
                          ? "சேர்க்க தட்டவும்"
                          : "Tap to add",
                      cardtitle: Provider.of<LanguageProvider>(context).isTamil
                          ? "வாராந்திர தணிக்கை"
                          : "Weekly Audit",
                      navpage: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const WeeklyAuditDialog();
                            });
                      },
                    ),
                    AuditCards(
                      // shadow: Colors.blue[300],
                      background: Colors.white,
                      text2: Provider.of<LanguageProvider>(context).isTamil
                          ? "தற்போது கிடைக்கவில்லை"
                          : "Not Avilable at the moment",
                      text1: Provider.of<LanguageProvider>(context).isTamil
                          ? "தணிக்கை ஐடியை உருவாக்கவும்"
                          : "Monthly Audit Id",
                      cardtitle: Provider.of<LanguageProvider>(context).isTamil
                          ? "மாதாந்திர தணிக்கை"
                          : "Monthly Audit",
                      navpage: () {
                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return StatefulBuilder(
                        //         builder: (BuildContext context, setState) {
                        //           return const MonthlyAuditDialog();
                        //         },
                        //       );
                        //     });
                      },
                    ),
                    AuditCards(
                      // shadow: Colors.blue[300],
                      background: Colors.white,
                      text2: Provider.of<LanguageProvider>(context).isTamil
                          ? "சேர்க்க தட்டவும்"
                          : "Tap to view",
                      text1: Provider.of<LanguageProvider>(context).isTamil
                          ? "வாராந்திர தணிக்கை அறிக்கைகள்"
                          : "Weekly Audit Reports",
                      cardtitle: Provider.of<LanguageProvider>(context).isTamil
                          ? "வாராந்திர அறிக்கைகள்"
                          : "Weekly Reports",
                      navpage: () {
                        _weeklyshowDatePicker();
                      },
                    ),
                    AuditCards(
                      // shadow: Colors.blue[300],
                      background: Colors.white,
                      text2: Provider.of<LanguageProvider>(context).isTamil
                          ? "சேர்க்க தட்டவும்"
                          : "Tap to view",
                      text1: Provider.of<LanguageProvider>(context).isTamil
                          ? "வளாக தணிக்கை அறிக்கைகள்"
                          : "Campus Audit Reports",
                      cardtitle: Provider.of<LanguageProvider>(context).isTamil
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
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
