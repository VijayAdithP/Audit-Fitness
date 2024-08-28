import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/bad_condition_user.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/user_container.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CampusProgressEdit extends StatefulWidget {
  final String mainArea;
  final String taskid;
  final String specificArea;
  final String reportObservation;
  final String auditDate;
  final String weeknumber;
  final String month;
  final int year;

  const CampusProgressEdit({
    super.key,
    required this.mainArea,
    required this.specificArea,
    required this.reportObservation,
    required this.auditDate,
    required this.taskid,
    required this.weeknumber,
    required this.month,
    required this.year,
  });

  @override
  State<CampusProgressEdit> createState() => _CampusProgressEditState();
}

class _CampusProgressEditState extends State<CampusProgressEdit> {
  TextEditingController specific_Task_id_contorller = TextEditingController();
  TextEditingController action_taken_contorller = TextEditingController();

  String year = '';
  String month = '';
  String formattedDate = '';
  String weekNumber = '';
  bool useractiondis = false;
  @override
  void initState() {
    super.initState();
    processDate();
  }

  void processDate() {
    DateTime date = DateTime.parse(widget.auditDate);
    weekNumber = _formatWeek(date);
    formattedDate = DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatWeek(DateTime date) {
    int weekOfYear = _getWeekOfYear(date);
    year = date.year.toString();

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

  int _getWeekOfYear(DateTime date) {
    var firstDayOfYear = DateTime(date.year, 1, 1);
    var daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    var weekNumber = ((daysSinceFirstDay + firstDayOfYear.weekday) / 7).ceil();
    return weekNumber;
  }

  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> createcampustask() async {
    // print(widget.reportObservation);
    var headers = {'Content-Type': 'application/json'};

    // print(int.parse(weekNumber));
    // print(month);
    // print(int.parse(year));
    // print(widget.taskid);
    // print(formattedDate);
    // print(widget.mainArea);
    // print(widget.specificArea);
    // print(widget.reportObservation);
    // print(specific_Task_id_contorller.text);
    // print(action_taken_contorller.text);

    try {
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.createspecifictaskid);

      var body = json.encode({
        "week_number": int.parse(widget.weeknumber),
        "month": widget.month,
        "year": widget.year,
        "task_id": widget.taskid,
        "audit_date": currentDate,
        "main_area": widget.mainArea,
        "specific_area": widget.specificArea,
        "report_observation": widget.reportObservation,
        "specific_task_id": specific_Task_id_contorller.text,
        "action_taken": action_taken_contorller.text,
        "status": 'In Progress'
      });

      var response = await http.post(url, body: body, headers: headers);
      print(response.body);
      if (response.statusCode == 201) {
        if (mounted) {
          setState(() {
            useractiondis = true;
            DelightToastBar(
              position: DelightSnackbarPosition.top,
              autoDismiss: true,
              animationDuration: const Duration(milliseconds: 100),
              snackbarDuration: const Duration(milliseconds: 800),
              builder: (context) => ToastCard(
                color: Colors.green,
                leading: const Icon(
                  Icons.done,
                  size: 28,
                  color: Colors.white,
                ),
                title: Text(
                  Provider.of<LanguageProvider>(context).isTamil
                      ? "பயனர் வெற்றிகரமாக உருவாக்கப்பட்டது"
                      : "User successfully created",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ).show(context);
          });
        }
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        useractiondis = false;
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'Error!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              contentPadding: const EdgeInsets.all(20),
              children: [
                Text(jsonDecode(response.body)["Message"] ?? "Invalid data")
              ],
            );
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Error!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(error.toString())],
          );
        },
      );
    }
  }

  Future<void> weeklytaskassignednotif() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.sendNotificationToUser);

      var body = json.encode({"message": "New Task assigned."});

      var response = await http.post(url, body: body, headers: headers);
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:
            useractiondis ? Color.fromRGBO(229, 229, 229, 1) : Colors.black,
        body: useractiondis
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "சேர்க்கப்படுகிறது"
                          : "Adding data",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: Provider.of<LanguageProvider>(context).isTamil
                            ? 17
                            : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SpinKitThreeBounce(
                      color: const Color.fromARGB(255, 130, 111, 238),
                      size: 30,
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          // top: 50.0,
                          left: 15.0,
                          right: 15.0,
                          bottom: 20.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    overflow: TextOverflow.visible,
                                    Provider.of<LanguageProvider>(context)
                                            .isTamil
                                        ? "வேலைகளை ஒதுக்குங்கள்"
                                        : "CREATE TASK",
                                    style: GoogleFonts.manrope(
                                      color: Colors.white,
                                      fontSize:
                                          Provider.of<LanguageProvider>(context)
                                                  .isTamil
                                              ? 17
                                              : 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(35.0),
                            topRight: Radius.circular(35.0),
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height - 110,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(229, 229, 229, 1),
                            ),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 15.0, left: 15, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                Provider.of<LanguageProvider>(
                                                            context)
                                                        .isTamil
                                                    ? "பணி ஐடி"
                                                    : 'Task Id',
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              UserContainer(
                                                color: Colors.white,
                                                inside: Text(
                                                  widget.taskid,
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                Provider.of<LanguageProvider>(
                                                            context)
                                                        .isTamil
                                                    ? "தேதி"
                                                    : 'Audit Date',
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              UserContainer(
                                                color: Colors.white,
                                                inside: Text(
                                                  formattedDate,
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),

                                    Text(
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "முக்கிய பகுதி"
                                          : 'Main Area',
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    UserContainer(
                                      color: Colors.white,
                                      inside: Text(
                                        Provider.of<LanguageProvider>(context)
                                                .isTamil
                                            ? "முக்கிய பகுதி"
                                            : widget.mainArea,
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "பகுதி"
                                          : 'Specific Area',
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    UserContainer(
                                      color: Colors.white,
                                      inside: Text(
                                        Provider.of<LanguageProvider>(context)
                                                .isTamil
                                            ? "பகுதி"
                                            : widget.specificArea,
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "பணி ஐடி"
                                          : 'Specific Task Id',
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Badconditionields(
                                      controller: specific_Task_id_contorller,
                                      hintText:
                                          Provider.of<LanguageProvider>(context)
                                                  .isTamil
                                              ? "பணி ஐடியை உள்ளிடவும்"
                                              : 'Enter Specific Task Id',
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "நடவடிக்கை எடுக்க வேண்டும்"
                                          : 'Action to be Taken',
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Badconditionields(
                                      controller: action_taken_contorller,
                                      hintText:
                                          Provider.of<LanguageProvider>(context)
                                                  .isTamil
                                              ? "தேவையான செயலை உள்ளிடவும்"
                                              : 'Enter needed action',
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),

                                    // const SizedBox(
                                    //   height: 20,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    left: 10,
                    child: GestureDetector(
                      onTap: () {
                        if (specific_Task_id_contorller.text.isEmpty) {
                          // print(widget.weeknumber);
                          // print(widget.month);
                          // print(widget.year);
                          // print(widget.taskid);
                          // print(currentDate);
                          // print(widget.mainArea);
                          // print(widget.specificArea);
                          // print(widget.reportObservation);
                          // print(specific_Task_id_contorller.text);
                          // print(action_taken_contorller.text);
                          setState(() {
                            DelightToastBar(
                              position: DelightSnackbarPosition.top,
                              autoDismiss: true,
                              snackbarDuration: Durations.extralong4,
                              builder: (BuildContext) => ToastCard(
                                color: Colors.red,
                                leading: const Icon(
                                  Icons.notification_important_outlined,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "அனைத்து புலங்களையும் நிரப்பவு"
                                      : "Fill all the fields",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ).show(context);
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 3,
                                      left: 3,
                                      right: 3,
                                      bottom: 3,
                                    ),
                                    child: Container(
                                      width: 150,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(229, 229, 229, 1),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(37),
                                          bottomRight: Radius.circular(37),
                                          topLeft: Radius.circular(37),
                                          topRight: Radius.circular(37),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              Provider.of<LanguageProvider>(
                                                          context)
                                                      .isTamil
                                                  ? "நீங்கள் உறுதியாக இருக்கிறீர்களா?"
                                                  : "Are you sure?",
                                              style: GoogleFonts.manrope(
                                                color: Colors.black,
                                                fontSize: 23,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 8,
                                                      horizontal: 32,
                                                    ),
                                                    foregroundColor:
                                                        Colors.black87,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    side: const BorderSide(
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    Provider.of<LanguageProvider>(
                                                                context)
                                                            .isTamil
                                                        ? "இல்லை"
                                                        : "No",
                                                    style: GoogleFonts.manrope(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize:
                                                            Provider.of<LanguageProvider>(
                                                                        context)
                                                                    .isTamil
                                                                ? 12
                                                                : 15),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ElevatedButton(
                                                  style: const ButtonStyle(
                                                    padding:
                                                        WidgetStatePropertyAll(
                                                      EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 32,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        WidgetStatePropertyAll(
                                                            Color.fromRGBO(130,
                                                                204, 146, 1)),
                                                    shape:
                                                        WidgetStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(5),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    createcampustask();
                                                    Navigator.of(context).pop();
                                                    setState(() {
                                                      useractiondis = true;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.maxFinite,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Create Task",
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
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
