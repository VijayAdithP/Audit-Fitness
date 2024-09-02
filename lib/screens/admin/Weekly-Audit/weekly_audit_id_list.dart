import 'dart:convert';
import 'package:auditfitnesstest/assets/colors.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/models/admin%20specific/weekly%20models/weekly_task_id_module.dart';
import 'package:auditfitnesstest/screens/admin/Weekly-Audit/weekly_audit_id_submission_page.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeeklyAuditListPage extends StatefulWidget {
  const WeeklyAuditListPage({super.key});

  @override
  State<WeeklyAuditListPage> createState() => _WeeklyAuditListPageState();
}

class _WeeklyAuditListPageState extends State<WeeklyAuditListPage> {
  @override
  void initState() {
    super.initState();
    futureWeeklyTasks = fetchWeeklyTasks();
  }

  Future<List<WeeklyTaskId>> fetchWeeklyTasks() async {
    final response = await http.get(Uri.parse(ApiEndPoints.baseUrl +
        ApiEndPoints.authEndpoints.showallweeklyauditId));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<WeeklyTaskId> weeklyTasks =
          jsonData.map((item) => WeeklyTaskId.fromJson(item)).toList();

      weeklyTasks.sort((a, b) => b.weekTaskId!.compareTo(a.weekTaskId!));
      if (mounted) {
        setState(() {
          lastFiveTasks = weeklyTasks.take(5).toList();
          isLoading = false;
        });
      }

      return lastFiveTasks;
    } else {
      throw Exception('Failed to load daily tasks');
    }
  }

  bool isLoading = true;

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
    String formattedRange =
        '${DateFormat('dd MMMM').format(startOfWeek) + ' To '}' +
            '${DateFormat('dd MMMM').format(endOfWeek)}';

    return formattedRange;
  }

  Future<void> _refreshTasks() async {
    // Simulate a network request or perform your actual data fetching logic here
    await Future.delayed(const Duration(seconds: 1));

    try {
      await fetchWeeklyTasks();
    } catch (error) {
      print('Error fetching tasks: $error');
    }
  }

  late Future<List<WeeklyTaskId>> futureWeeklyTasks;
  String? weeklyauditId;
  List<WeeklyTaskId> lastFiveTasks = [];

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
            toolbarHeight: 70,
            // backgroundColor: Colors.red,
            titleSpacing: 0,
            title: Text(
              overflow: TextOverflow.visible,
              Provider.of<LanguageProvider>(context).isTamil
                  ? "நிர்வாக வேலை"
                  : "Recent weekly audit id's",
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
                    color: Color.fromARGB(255, 97, 81, 188),
                    size: 30,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Container(
                    //   padding: const EdgeInsets.only(
                    //     // top: 50.0,
                    //     left: 20.0,
                    //     right: 20.0,
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
                    //                                   ? "சில வாராந்திர வேலை ஐடிகள்"
                    //                                   : "Recent weekly audit id's",
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
                    //                               ? "மிகச் சமீபத்திய வாராந்திர வேலைகள் அனைத்து பலவீனமான வேலை களையும் பார்க்க, தேடல் பட்டியில் தட்டவும்"
                    //                               : "The most recent weekly audits are listed here to view all weekly audits tap on the search bar",
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
                    //             child: const Icon(
                    //               Icons.info,
                    //               size: 25,
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //       const SizedBox(
                    //         height: 5,
                    //       ),
                    //       Text(
                    //         overflow: TextOverflow.visible,
                    //         Provider.of<LanguageProvider>(context).isTamil
                    //             ? "சில வாராந்திர வேலை ஐடிகள்"
                    //             : "RECENT WEEKLY AUDIT IDs",
                    //         style: GoogleFonts.manrope(
                    //           color: Colors.black,
                    //           fontSize:
                    //               Provider.of<LanguageProvider>(context).isTamil
                    //                   ? 28
                    //                   : 35,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(37.0),
                          topRight: Radius.circular(37.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: lighterbackgroundblue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(37.0),
                              topRight: Radius.circular(37.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Hero(
                              //     tag: "search bar",
                              //     child: Material(
                              //       borderRadius: BorderRadius.circular(40),
                              //       child: ClipRRect(
                              //         borderRadius: BorderRadius.circular(40),
                              //         child: Container(
                              //           height: 60,
                              //           width: MediaQuery.of(context).size.width,
                              //           decoration: BoxDecoration(
                              //             color: Colors.white,
                              //             borderRadius: BorderRadius.circular(40),
                              //           ),
                              //           child: TextField(
                              //             textInputAction: TextInputAction.done,
                              //             maxLines: null,
                              //             expands: true,
                              //             controller: _searchController,
                              //             decoration: InputDecoration(
                              //               icon: GestureDetector(
                              //                 onTap: () {
                              //                   Navigator.of(context).pop();
                              //                 },
                              //                 child: const Padding(
                              //                   padding: const EdgeInsets.only(
                              //                       left: 20.0),
                              //                   child: const Icon(
                              //                     Icons.search,
                              //                     size: 25,
                              //                     color: Colors.black54,
                              //                   ),
                              //                 ),
                              //               ),
                              //               filled: true,
                              //               fillColor: Colors.white,
                              //               enabledBorder: const OutlineInputBorder(
                              //                 borderRadius: BorderRadius.all(
                              //                   Radius.circular(10),
                              //                 ),
                              //                 borderSide: BorderSide(
                              //                   color: Colors.transparent,
                              //                 ),
                              //               ),
                              //               focusedBorder: const OutlineInputBorder(
                              //                 borderRadius: BorderRadius.all(
                              //                   Radius.circular(10),
                              //                 ),
                              //                 borderSide: BorderSide(
                              //                   color: Colors.transparent,
                              //                 ),
                              //               ),
                              //               border: InputBorder.none,
                              //               hintText: "Search by username",
                              //               hintStyle: const TextStyle(
                              //                 fontSize: 18,
                              //                 color: Colors.black54,
                              //                 fontWeight: FontWeight.bold,
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 10.0,
                                  left: 10,
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Hero(
                                  tag: "Task search bar",
                                  child: Material(
                                    elevation: 1,
                                    shadowColor: lightbackgroundblue,
                                    borderRadius: BorderRadius.circular(40),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SearchAllWeeklyTaks(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromRGBO(
                                                  158, 158, 158, 1),
                                              spreadRadius: -5,
                                              blurRadius: 5,
                                              // offset:
                                              // const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        height: 60,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.search,
                                              size: 25,
                                              color: darkblue.withOpacity(0.6),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              Provider.of<LanguageProvider>(
                                                          context)
                                                      .isTamil
                                                  ? "பணி ஐடி"
                                                  : 'Search by taskId',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize:
                                                    Provider.of<LanguageProvider>(
                                                                context)
                                                            .isTamil
                                                        ? 16
                                                        : 18,
                                                color:
                                                    darkblue.withOpacity(0.6),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: RefreshIndicator(
                                  onRefresh: _refreshTasks,
                                  child: lastFiveTasks.isEmpty
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              Provider.of<LanguageProvider>(
                                                          context)
                                                      .isTamil
                                                  ? "தற்போது \nகாலியாக உள்ளது"
                                                  : "Currently empty",
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: lastFiveTasks.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        WeeklyAuditAssignmentpage(
                                                      weeklyAuditRange:
                                                          getWeekDateRange(
                                                              lastFiveTasks[
                                                                      index]
                                                                  .weekNumber!,
                                                              lastFiveTasks[
                                                                      index]
                                                                  .year!),
                                                      weeklyAuditId:
                                                          lastFiveTasks[index]
                                                              .weeklyTaskId,
                                                      weeklyAuditweeknumber:
                                                          lastFiveTasks[index]
                                                              .weekNumber,
                                                      weeklyAuditmonth:
                                                          lastFiveTasks[index]
                                                              .month,
                                                      weeklyAudityear:
                                                          lastFiveTasks[index]
                                                              .year,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 10.0,
                                                  left: 10,
                                                  top: 10,
                                                  bottom: 10,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: paleblue,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color
                                                            .fromRGBO(
                                                            158, 158, 158, 1),
                                                        spreadRadius: -5,
                                                        blurRadius: 5,
                                                        // offset:
                                                        // const Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        lastFiveTasks[index]
                                                                .weeklyTaskId ??
                                                            'No Task ID',
                                                        style:
                                                            TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25,
                                                          color:
                                                              lighterbackgroundblue,
                                                        ),
                                                      ),
                                                      Text(
                                                        // lastFiveTasks[index].weekNumber.toString(),
                                                        getWeekDateRange(
                                                            lastFiveTasks[index]
                                                                .weekNumber!,
                                                            lastFiveTasks[index]
                                                                .year!),
                                                        style:
                                                            TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 15,
                                                          color:
                                                              Colors.grey[200],
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey[300],
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                Icons.add,
                                                                size: 30,
                                                                color: darkblue,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                            ],
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

class SearchAllWeeklyTaks extends StatefulWidget {
  const SearchAllWeeklyTaks({super.key});

  @override
  State<SearchAllWeeklyTaks> createState() => _SearchAllWeeklyTaksState();
}

class _SearchAllWeeklyTaksState extends State<SearchAllWeeklyTaks> {
  @override
  void initState() {
    super.initState();
    fetchWeeklyTasks();
    _searchController.addListener(_filterTasks);
  }

  Future<void> fetchWeeklyTasks() async {
    final response = await http.get(Uri.parse(ApiEndPoints.baseUrl +
        ApiEndPoints.authEndpoints.showallweeklyauditId));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<WeeklyTaskId> weeklyTasks =
          jsonData.map((item) => WeeklyTaskId.fromJson(item)).toList();

      weeklyTasks.sort((a, b) => b.weekTaskId!.compareTo(a.weekTaskId!));
      if (mounted) {
        setState(() {
          allTasks =
              jsonData.map((item) => WeeklyTaskId.fromJson(item)).toList();
          _filteredTasks = allTasks;
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load daily tasks');
    }
  }

  void _filterTasks() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTasks = allTasks
          .where((user) => user.weeklyTaskId!.toLowerCase().contains(query))
          .toList();
    });
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
    String formattedRange =
        '${DateFormat('dd MMMM').format(startOfWeek) + ' To '}' +
            '${DateFormat('dd MMMM').format(endOfWeek)}';

    return formattedRange;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool isLoading = true;

  List<WeeklyTaskId> allTasks = [];
  List<WeeklyTaskId> _filteredTasks = [];
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: lighterbackgroundblue,
          // appBar: AppBar(
          //   title: const Text('User Search'),
          // ),
          body: Column(
            children: [
              // const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: "Task search bar",
                  child: Material(
                    elevation: 1,
                    shadowColor: lightbackgroundblue,
                    borderRadius: BorderRadius.circular(40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(158, 158, 158, 1),
                              spreadRadius: -5,
                              blurRadius: 5,
                              // offset:
                              // const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          maxLines: null,
                          // expands: true,
                          controller: _searchController,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 25,
                                    color: darkblue.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            border: InputBorder.none,
                            hintText:
                                Provider.of<LanguageProvider>(context).isTamil
                                    ? "பணி ஐடி"
                                    : "Search by taskId",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: darkblue.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _filteredTasks.isEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Provider.of<LanguageProvider>(context).isTamil
                                ? "முடிவு இல்லை"
                                : "No Result",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          const SpinKitThreeBounce(
                            color: Color.fromARGB(255, 97, 81, 188),
                            size: 30,
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _filteredTasks.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      WeeklyAuditAssignmentpage(
                                    weeklyAuditRange: getWeekDateRange(
                                        _filteredTasks[index].weekNumber!,
                                        _filteredTasks[index].year!),
                                    weeklyAuditId:
                                        _filteredTasks[index].weeklyTaskId,
                                    weeklyAuditweeknumber:
                                        _filteredTasks[index].weekNumber,
                                    weeklyAuditmonth:
                                        _filteredTasks[index].month,
                                    weeklyAudityear: _filteredTasks[index].year,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                                left: 10,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Container(
                                // height: 120,
                                decoration: BoxDecoration(
                                  color: lightbackgroundblue,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _filteredTasks[index].weeklyTaskId ??
                                          'No Task ID',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: darkblue,
                                      ),
                                    ),
                                    Text(
                                      getWeekDateRange(
                                          _filteredTasks[index].weekNumber!,
                                          _filteredTasks[index].year!),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: darkblue,
                                      ),
                                    ),
                                    // const Expanded(
                                    //   child: SizedBox(height: 10),
                                    // ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            size: 30,
                                            color: darkblue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
