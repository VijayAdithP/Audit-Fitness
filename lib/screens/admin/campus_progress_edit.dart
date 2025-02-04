import 'dart:convert';
import 'package:auditfitnesstest/assets/colors.dart';
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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageProvider = Provider.of<LanguageProvider>(context);
  }

  late LanguageProvider _languageProvider;
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
                color: alertgreen,
                leading: const Icon(
                  Icons.done,
                  size: 28,
                  color: Colors.white,
                ),
                title: Text(
                  _languageProvider.isTamil
                      ? "பணி ஐடி வெற்றிகரமாக உருவாக்கப்பட்டது"
                      : "Campus-Id successfully created",
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
        setState(() {
          useractiondis = false;
          DelightToastBar(
            position: DelightSnackbarPosition.top,
            autoDismiss: true,
            animationDuration: const Duration(milliseconds: 100),
            snackbarDuration: const Duration(milliseconds: 800),
            builder: (context) => ToastCard(
              color: alertred,
              leading: const Icon(
                Icons.notification_important_rounded,
                size: 28,
                color: Colors.white,
              ),
              title: Text(
                _languageProvider.isTamil ? "தவறான தகவல்" : "Invalid data",
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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: darkblue,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          toolbarHeight: 70,
          // backgroundColor: Colors.red,
          titleSpacing: 0,
          title: Text(
            overflow: TextOverflow.visible,
            Provider.of<LanguageProvider>(context).isTamil
                ? "வேலைகளை உருவாக்க"
                : "CREATE TASK",
            style: TextStyle(
              color: darkblue,
              fontWeight: FontWeight.bold,
              fontSize:
                  Provider.of<LanguageProvider>(context).isTamil ? 18 : 21,
            ),
          ),
        ),
        backgroundColor: lighterbackgroundblue,
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
                      // Container(
                      //   padding: const EdgeInsets.only(
                      //     // top: 50.0,
                      //     left: 15.0,
                      //     right: 15.0,
                      //     bottom: 20.0,
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Padding(
                      //         padding: const EdgeInsets.only(top: 10),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           children: [
                      //             GestureDetector(
                      //               onTap: () {
                      //                 Navigator.of(context).pop();
                      //               },
                      //               child: const Icon(
                      //                 Icons.arrow_back,
                      //                 color: Colors.white,
                      //                 size: 30,
                      //               ),
                      //             ),
                      //             const SizedBox(
                      //               width: 10,
                      //             ),
                      //             Text(
                      //               overflow: TextOverflow.visible,
                      //               Provider.of<LanguageProvider>(context)
                      //                       .isTamil
                      //                   ? "வேலைகளை ஒதுக்குங்கள்"
                      //                   : "CREATE TASK",
                      //               style: GoogleFonts.manrope(
                      //                 color: Colors.white,
                      //                 fontSize:
                      //                     Provider.of<LanguageProvider>(context)
                      //                             .isTamil
                      //                         ? 17
                      //                         : 20,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height - 110,
                          decoration: BoxDecoration(
                            color: lighterbackgroundblue,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: greyblue,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            UserContainer(
                                              color: Colors.white,
                                              inside: Text(
                                                widget.taskid,
                                                style: TextStyle(
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
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: greyblue,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            UserContainer(
                                              color: Colors.white,
                                              inside: Text(
                                                formattedDate,
                                                style: TextStyle(
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: greyblue,
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
                                      style: TextStyle(
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: greyblue,
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Provider.of<LanguageProvider>(context)
                                                .isTamil
                                            ? "பணி ஐடி"
                                            : 'Specific Task Id',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: greyblue,
                                        ),
                                      ),
                                      Text(
                                        " *",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
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
                                  Row(
                                    children: [
                                      Text(
                                        Provider.of<LanguageProvider>(context)
                                                .isTamil
                                            ? "நடவடிக்கை எடுக்க வேண்டும்"
                                            : 'Action to be Taken',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: greyblue,
                                        ),
                                      ),
                                      Text(
                                        " *",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
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
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (specific_Task_id_contorller
                                                .text.isEmpty ||
                                            action_taken_contorller
                                                .text.isEmpty) {
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
                                              position:
                                                  DelightSnackbarPosition.top,
                                              autoDismiss: true,
                                              snackbarDuration:
                                                  Durations.extralong4,
                                              builder: (BuildContext) =>
                                                  ToastCard(
                                                color: alertred,
                                                leading: const Icon(
                                                  Icons
                                                      .notification_important_outlined,
                                                  size: 28,
                                                  color: Colors.white,
                                                ),
                                                title: Text(
                                                  _languageProvider.isTamil
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
                                              return
                                                  // Dialog(
                                                  //   backgroundColor: Color.fromRGBO(
                                                  //       229, 229, 229, 1),
                                                  //   shape: RoundedRectangleBorder(
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(
                                                  //             15.0),
                                                  //   ),
                                                  //   child: ClipRRect(
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(
                                                  //             15.0),
                                                  //     child: Padding(
                                                  //       padding:
                                                  //           const EdgeInsets.only(
                                                  //         top: 3,
                                                  //         left: 3,
                                                  //         right: 3,
                                                  //         bottom: 3,
                                                  //       ),
                                                  //       child: Container(
                                                  //         width: 150,
                                                  //         decoration:
                                                  //             const BoxDecoration(
                                                  //           color: Color.fromRGBO(
                                                  //               229, 229, 229, 1),
                                                  //           borderRadius:
                                                  //               BorderRadius.only(
                                                  //             bottomLeft:
                                                  //                 Radius.circular(
                                                  //                     37),
                                                  //             bottomRight:
                                                  //                 Radius.circular(
                                                  //                     37),
                                                  //             topLeft:
                                                  //                 Radius.circular(
                                                  //                     37),
                                                  //             topRight:
                                                  //                 Radius.circular(
                                                  //                     37),
                                                  //           ),
                                                  //         ),
                                                  //         child: Padding(
                                                  //           padding:
                                                  //               const EdgeInsets
                                                  //                   .symmetric(
                                                  //                   horizontal:
                                                  //                       20.0),
                                                  //           child: Column(
                                                  //             mainAxisSize:
                                                  //                 MainAxisSize.min,
                                                  //             crossAxisAlignment:
                                                  //                 CrossAxisAlignment
                                                  //                     .center,
                                                  //             children: [
                                                  //               const SizedBox(
                                                  //                 height: 20,
                                                  //               ),
                                                  //               Text(
                                                  //                 Provider.of<LanguageProvider>(
                                                  //                             context)
                                                  //                         .isTamil
                                                  //                     ? "நீங்கள் உறுதியாக இருக்கிறீர்களா?"
                                                  //                     : "Are you sure?",
                                                  //                 style: GoogleFonts
                                                  //                     .manrope(
                                                  //                   color: Colors
                                                  //                       .black,
                                                  //                   fontSize: 23,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .w500,
                                                  //                 ),
                                                  //               ),
                                                  //               const SizedBox(
                                                  //                 height: 20,
                                                  //               ),
                                                  //               Row(
                                                  //                 mainAxisAlignment:
                                                  //                     MainAxisAlignment
                                                  //                         .spaceEvenly,
                                                  //                 children: [
                                                  //                   OutlinedButton(
                                                  //                     style: OutlinedButton
                                                  //                         .styleFrom(
                                                  //                       padding:
                                                  //                           const EdgeInsets
                                                  //                               .symmetric(
                                                  //                         vertical:
                                                  //                             8,
                                                  //                         horizontal:
                                                  //                             32,
                                                  //                       ),
                                                  //                       foregroundColor:
                                                  //                           Colors
                                                  //                               .black87,
                                                  //                       shape:
                                                  //                           RoundedRectangleBorder(
                                                  //                         borderRadius:
                                                  //                             BorderRadius.circular(
                                                  //                                 5),
                                                  //                       ),
                                                  //                       side:
                                                  //                           const BorderSide(
                                                  //                         color: Colors
                                                  //                             .black87,
                                                  //                       ),
                                                  //                     ),
                                                  //                     child: Text(
                                                  //                       Provider.of<LanguageProvider>(context)
                                                  //                               .isTamil
                                                  //                           ? "இல்லை"
                                                  //                           : "No",
                                                  //                       style: GoogleFonts.manrope(
                                                  //                           color: Colors
                                                  //                               .black87,
                                                  //                           fontWeight:
                                                  //                               FontWeight
                                                  //                                   .w500,
                                                  //                           fontSize: Provider.of<LanguageProvider>(context).isTamil
                                                  //                               ? 12
                                                  //                               : 15),
                                                  //                     ),
                                                  //                     onPressed:
                                                  //                         () {
                                                  //                       Navigator.of(
                                                  //                               context)
                                                  //                           .pop();
                                                  //                     },
                                                  //                   ),
                                                  //                   ElevatedButton(
                                                  //                     style:
                                                  //                         ButtonStyle(
                                                  //                       padding:
                                                  //                           WidgetStatePropertyAll(
                                                  //                         EdgeInsets
                                                  //                             .symmetric(
                                                  //                           vertical:
                                                  //                               8,
                                                  //                           // horizontal:
                                                  //                           //     32,
                                                  //                         ),
                                                  //                       ),
                                                  //                       backgroundColor:
                                                  //                           WidgetStatePropertyAll(
                                                  //                         paleblue,
                                                  //                       ),
                                                  //                       shape:
                                                  //                           WidgetStatePropertyAll(
                                                  //                         RoundedRectangleBorder(
                                                  //                           borderRadius:
                                                  //                               BorderRadius.all(
                                                  //                             Radius.circular(
                                                  //                                 5),
                                                  //                           ),
                                                  //                         ),
                                                  //                       ),
                                                  //                     ),
                                                  //                     child:
                                                  //                         const Icon(
                                                  //                       Icons.check,
                                                  //                       color: Colors
                                                  //                           .white,
                                                  //                     ),
                                                  //                     onPressed:
                                                  //                         () {
                                                  //                       createcampustask();
                                                  //                       Navigator.of(
                                                  //                               context)
                                                  //                           .pop();
                                                  //                       setState(
                                                  //                           () {
                                                  //                         useractiondis =
                                                  //                             true;
                                                  //                       });
                                                  //                     },
                                                  //                   ),
                                                  //                 ],
                                                  //               ),
                                                  //               const SizedBox(
                                                  //                 height: 20,
                                                  //               ),
                                                  //             ],
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // );
                                                  Dialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 3,
                                                      left: 3,
                                                      right: 3,
                                                      bottom: 3,
                                                    ),
                                                    child: Container(
                                                      width: 150,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 20.0,
                                                          vertical: 20,
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              Provider.of<LanguageProvider>(
                                                                          context)
                                                                      .isTamil
                                                                  ? "நீங்கள் உறுதியாக இருக்கிறீர்களா?"
                                                                  : "Are you sure?",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: Provider.of<LanguageProvider>(
                                                                            context)
                                                                        .isTamil
                                                                    ? 19
                                                                    : 23,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                            IntrinsicHeight(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        Provider.of<LanguageProvider>(context).isTamil
                                                                            ? "இல்லை"
                                                                            : "No",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            fontSize: Provider.of<LanguageProvider>(context).isTamil
                                                                                ? 14
                                                                                : 17),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  VerticalDivider(
                                                                    color: Colors
                                                                        .grey
                                                                        .withValues(
                                                                            alpha:
                                                                                0.5),
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      createcampustask();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      setState(
                                                                          () {
                                                                        useractiondis =
                                                                            true;
                                                                      });
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        Provider.of<LanguageProvider>(context).isTamil
                                                                            ? "ஆம்"
                                                                            : "yes",
                                                                        style: TextStyle(
                                                                            color:
                                                                                paleblue,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize: Provider.of<LanguageProvider>(context).isTamil
                                                                                ? 14
                                                                                : 17),
                                                                      ),
                                                                    ),
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
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                          color: darkblue,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            Provider.of<LanguageProvider>(
                                                        context)
                                                    .isTamil
                                                ? "பணியை உருவாக்க"
                                                : "Create Task",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
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
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
