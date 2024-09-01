import 'dart:convert';
import 'package:auditfitnesstest/assets/colors.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/models/admin%20specific/weekly%20models/user_weekly_tasks_model.dart';
import 'package:auditfitnesstest/screens/user/Weekly-Audit/weekly_audit_submit_page.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeeklyUserAuditListPage extends StatefulWidget {
  const WeeklyUserAuditListPage({super.key});

  @override
  State<WeeklyUserAuditListPage> createState() =>
      _WeeklyUserAuditListPageState();
}

class _WeeklyUserAuditListPageState extends State<WeeklyUserAuditListPage> {
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    futureweeklyTasks = fetchDailyTasks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeeklyTasksProvider>(context, listen: false)
          .fetchWeeklyTasks();
    });
  }

  Future<List<UserWeeklyTasksModel>> fetchDailyTasks() async {
    username = box.read('username');
    final response = await http.get(Uri.parse(
        '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getweeklytaskper}/$username'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          weeklyTasks = jsonData
              .map((item) => UserWeeklyTasksModel.fromJson(item))
              .toList();
          isLoading = false;
        });
      }

      weeklyTasks.sort((a, b) => b.assignedAt!.compareTo(a.assignedAt!));
      return weeklyTasks;
    } else {
      throw Exception('Failed to load daily tasks');
    }
  }

  Future<void> _refreshTasks() async {
    try {
      // Call the fetchDailyTasks method
      await fetchDailyTasks();
    } catch (error) {
      // Handle any errors here (e.g., show a message to the user)
      print('Error fetching tasks: $error');
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

  late Future<List<UserWeeklyTasksModel>> futureweeklyTasks;
  List<UserWeeklyTasksModel> weeklyTasks = [];
  String username = '';
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
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
            // toolbarHeight: 70,
            // backgroundColor: Colors.red,
            titleSpacing: 0,
            title: Text(
              overflow: TextOverflow.visible,
              Provider.of<LanguageProvider>(context).isTamil
                  ? "வார வேலைகள்"
                  : "PENDING WEEKLY AUDIT",
              style: TextStyle(
                color: darkblue,
                fontWeight: FontWeight.bold,
                fontSize:
                    Provider.of<LanguageProvider>(context).isTamil ? 18 : 21,
              ),
            ),
          ),
          backgroundColor:
              isLoading ? lighterbackgroundblue : lighterbackgroundblue,
          body: isLoading
              ? const Center(
                  child: SpinKitThreeBounce(
                    color: const Color.fromARGB(255, 130, 111, 238),
                    size: 30,
                  ),
                )
              : Column(
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.only(
                    //     top: 10.0,
                    //     left: 15.0,
                    //     right: 15.0,
                    //     bottom: 10.0,
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           GestureDetector(
                    //             onTap: () {
                    //               Navigator.of(context).pop();
                    //             },
                    //             child: const Icon(
                    //               Icons.arrow_back,
                    //               color: Colors.black,
                    //               size: 30,
                    //             ),
                    //           ),
                    //           GestureDetector(
                    //             onTap: () {
                    //               showDialog(
                    //                   context: context,
                    //                   builder: (context) {
                    //                     return SimpleDialog(
                    //                       backgroundColor: const Color.fromRGBO(
                    //                           46, 46, 46, 1),
                    //                       contentPadding:
                    //                           const EdgeInsets.all(20),
                    //                       title: Column(
                    //                         children: [
                    //                           Align(
                    //                             alignment: Alignment.center,
                    //                             child: Text(
                    //                               Provider.of<LanguageProvider>(
                    //                                           context)
                    //                                       .isTamil
                    //                                   ? "தகவல்"
                    //                                   : "INFO",
                    //                               style: const TextStyle(
                    //                                 fontSize: 20,
                    //                                 fontWeight: FontWeight.bold,
                    //                                 color: Colors.blueAccent,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           const SizedBox(
                    //                             height: 5,
                    //                           ),
                    //                           Align(
                    //                             alignment: Alignment.center,
                    //                             child: Text(
                    //                               textAlign: TextAlign.center,
                    //                               Provider.of<LanguageProvider>(
                    //                                           context)
                    //                                       .isTamil
                    //                                   ? "நிலுவையில் உள்ள வேலைகள்"
                    //                                   : "Pending weekly audits",
                    //                               style: const TextStyle(
                    //                                 fontSize: 17,
                    //                                 fontWeight: FontWeight.bold,
                    //                                 color: Colors.white,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                       children: [
                    //                         Text(
                    //                           Provider.of<LanguageProvider>(
                    //                                       context)
                    //                                   .isTamil
                    //                               ? "உங்களிடம் நிலுவையில் உள்ள வேலைகள் இதோ, நிர்ணயிக்கப்பட்ட காலக்கெடுவிற்கு முன் அவற்றை முடிக்கவும்"
                    //                               : "Here are the pending audits you have, Complete them before the set deadline",
                    //                           style: const TextStyle(
                    //                             fontSize: 17,
                    //                             // fontWeight: FontWeight.bold,
                    //                             color: Colors.white,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     );
                    //                   });
                    //             },
                    //             child: const Icon(Icons.info,
                    //                 size: 25, color: Colors.black),
                    //           )
                    //         ],
                    //       ),
                    //       const SizedBox(
                    //         height: 5,
                    //       ),
                    //       Text(
                    //         overflow: TextOverflow.visible,
                    //         Provider.of<LanguageProvider>(context).isTamil
                    //             ? "வாராந்திர வேலைகள்"
                    //             : "PENDING WEEKLY AUDIT",
                    //         style: GoogleFonts.manrope(
                    //           color: Colors.black,
                    //           fontSize: 30,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: lighterbackgroundblue,
                          // borderRadius: BorderRadius.only(
                          //   topLeft: Radius.circular(37.0),
                          //   topRight: Radius.circular(37.0),
                          // ),
                        ),
                        child: RefreshIndicator(
                          onRefresh: _refreshTasks,
                          child: weeklyTasks.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "தற்போது \nகாலியாக உள்ளது"
                                          : "Currently empty",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: weeklyTasks.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WeeklyUserAuditSubmmitPage(
                                                auditAuditRange:
                                                    getWeekDateRange(
                                                        weeklyTasks[index]
                                                            .weekNumber!,
                                                        weeklyTasks[index]
                                                            .year!),
                                                auditId: weeklyTasks[index]
                                                    .weeklyTaskId,
                                                auditarea: weeklyTasks[index]
                                                    .selectedArea,
                                                auditdata: weeklyTasks[index]
                                                    .assignedAt
                                                    .toString(),
                                                auditmonth:
                                                    weeklyTasks[index].month,
                                                auditweeknumber:
                                                    weeklyTasks[index]
                                                        .weekNumber
                                                        .toString(),
                                                audityear: weeklyTasks[index]
                                                    .year
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            height: 120,
                                            decoration: BoxDecoration(
                                              // color: HexColor("#228aba"),
                                              color: paleblue,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //     color: const Color.fromRGBO(
                                              //         158, 158, 158, 1),
                                              //     spreadRadius: -5,
                                              //     blurRadius: 5,
                                              //     offset: const Offset(0, 4),
                                              //   ),
                                              // ],
                                            ),
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  weeklyTasks[index]
                                                          .weeklyTaskId ??
                                                      'No Task ID',
                                                  style: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25,
                                                      color:
                                                          lighterbackgroundblue),
                                                ),
                                                // const SizedBox(height: 10),
                                                Text(
                                                  getWeekDateRange(
                                                      weeklyTasks[index]
                                                          .weekNumber!,
                                                      weeklyTasks[index].year!),
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                    color:
                                                        lighterbackgroundblue,
                                                  ),
                                                ),
                                                const Expanded(
                                                  child: SizedBox(height: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
