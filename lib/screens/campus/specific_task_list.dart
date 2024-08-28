import 'dart:convert';
import 'package:auditfitnesstest/models/campus%20info/specific_task.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/campus/specific_task_submission.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SpecificTaskList extends StatefulWidget {
  const SpecificTaskList({super.key});

  @override
  State<SpecificTaskList> createState() => _SpecificTaskListState();
}

class _SpecificTaskListState extends State<SpecificTaskList> {
  List<SpecificTask> tasks = [];
  bool isLoading = false;
  int _currIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchSpecificTasks();
  }

  Future<void> fetchSpecificTasks() async {
    final response = await http.get(Uri.parse(ApiEndPoints.baseUrl +
        ApiEndPoints.authEndpoints.specificPendingAreas));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        tasks = jsonData.map((json) => SpecificTask.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> _refreshSpecificTasks() async {
    // Simulate a network request or perform your actual data fetching logic here
    await Future.delayed(const Duration(seconds: 1));

    try {
      await fetchSpecificTasks();
    } catch (error) {
      print('Error fetching tasks: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isLoading
          ? const Color.fromRGBO(229, 229, 228, 1)
          : const Color.fromARGB(255, 130, 111, 238),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: isLoading
              ? const Color.fromRGBO(229, 229, 228, 1)
              : const Color.fromARGB(255, 130, 111, 238),
          body: isLoading
              ? const Center(
                  child: SpinKitThreeBounce(
                    color: Color.fromARGB(255, 97, 81, 188),
                    size: 50,
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        // top: 10.0,
                        left: 15.0,
                        right: 15.0,
                        bottom: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: AnimatedSwitcher(
                                        duration: const Duration(seconds: 1),
                                        transitionBuilder: (child, anim) =>
                                            RotationTransition(
                                              turns:
                                                  child.key == ValueKey('icon1')
                                                      ? Tween<double>(
                                                              begin: 1, end: -1)
                                                          .animate(anim)
                                                      : Tween<double>(
                                                              begin: -1, end: 1)
                                                          .animate(anim),
                                              child: FadeTransition(
                                                  opacity: anim, child: child),
                                            ),
                                        child: _currIndex == 0
                                            ? Icon(Icons.sync,
                                                color: Colors.black,
                                                key: const ValueKey('icon1'))
                                            : Icon(
                                                Icons.sync,
                                                color: Colors.black,
                                                key: const ValueKey('icon2'),
                                              )),
                                    onPressed: () {
                                      _refreshSpecificTasks();
                                      setState(() {
                                        _currIndex = _currIndex == 0 ? 1 : 0;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      46, 46, 46, 1),
                                              contentPadding:
                                                  const EdgeInsets.all(20),
                                              title: Column(
                                                children: [
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      Provider.of<LanguageProvider>(
                                                                  context)
                                                              .isTamil
                                                          ? "தகவல்"
                                                          : "INFO",
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.blueAccent,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      Provider.of<LanguageProvider>(
                                                                  context)
                                                              .isTamil
                                                          ? "நிலுவையில் உள்ள வேலைகள்"
                                                          : "Pending audits",
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              children: [
                                                Text(
                                                  Provider.of<LanguageProvider>(
                                                              context)
                                                          .isTamil
                                                      ? "காலக்கெடு தேதிக்கு முன் முடிக்க வேண்டிய அனைத்து வளாகப் பணிகளும் இங்கே உள்ளன."
                                                      : "Here are all the Campus task that are needed to be completed before the deadline date.",
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: const Icon(
                                      Icons.info,
                                      size: 25,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            overflow: TextOverflow.visible,
                            Provider.of<LanguageProvider>(context).isTamil
                                ? "நிலுவையில் உள்ள வேலைகள்"
                                : "PENDING AUDITS",
                            style: GoogleFonts.manrope(
                              color: Colors.black,
                              fontSize:
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? 23
                                      : 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(37.0),
                          topRight: Radius.circular(37.0),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(229, 229, 228, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(37.0),
                              topRight: Radius.circular(37.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 10.0,
                                  left: 10,
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Hero(
                                  tag: "Campus Task search bar",
                                  child: SizedBox(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CampusTaskSearch(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 15),
                                        backgroundColor: Colors.white,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.search,
                                            size: 25,
                                            color: Colors.black54,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            Provider.of<LanguageProvider>(
                                                        context)
                                                    .isTamil
                                                ? "பணி ஐடி"
                                                : 'Search by task id',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: RefreshIndicator(
                                  onRefresh: _refreshSpecificTasks,
                                  child: tasks.isEmpty
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
                                          itemCount: tasks.length,
                                          itemBuilder: (context, index) {
                                            final task = tasks[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SpecificTaskSubmission(
                                                      specificArea:
                                                          task.specificArea!,
                                                      month: task.month!,
                                                      specificTaskId:
                                                          task.specificTaskId!,
                                                      weeknumber:
                                                          task.weekNumber!,
                                                      year: task.year!,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 180,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(30),
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        task.specificArea!,
                                                        style:
                                                            GoogleFonts.manrope(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25,
                                                        ),
                                                      ),
                                                      Text(
                                                        task.actionTaken!,
                                                        style:
                                                            GoogleFonts.manrope(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 15,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                      const Expanded(
                                                        child: SizedBox(
                                                            height: 10),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                              // width:
                                                              //     Provider.of<LanguageProvider>(
                                                              //                 context)
                                                              //             .isTamil
                                                              //         ? 130
                                                              //         : 100,
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
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    Provider.of<LanguageProvider>(context)
                                                                            .isTamil
                                                                        ? "பணி ஐடி: ${task.specificTaskId!.toString()}"
                                                                        : 'Task Id: ${task.specificTaskId!.toString()}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      // fontSize: Provider.of<
                                                                      //                 LanguageProvider>(
                                                                      //             context)
                                                                      //         .isTamil
                                                                      //     ? 15
                                                                      //     : 14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                              // const Icon(
                                                              //   Icons.add,
                                                              //   size: 30,
                                                              // ),
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

class CampusTaskSearch extends StatefulWidget {
  const CampusTaskSearch({super.key});

  @override
  State<CampusTaskSearch> createState() => _CampusTaskSearchState();
}

class _CampusTaskSearchState extends State<CampusTaskSearch> {
  @override
  void initState() {
    super.initState();
    fetchCampusTasks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Future<void> fetchCampusTasks() async {
  //   final response = await http.get(Uri.parse(ApiEndPoints.baseUrl +
  //       ApiEndPoints.authEndpoints.specificPendingAreas));

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonData = jsonDecode(response.body);
  //     setState(() {
  //       allcampustasks =
  //           jsonData.map((json) => SpecificTask.fromJson(json)).toList();
  //       _filteredCampusTasks = allcampustasks;
  //       isLoading = false;
  //     });
  //   } else {
  //     throw Exception('Failed to load tasks');
  //   }
  // }

  Future<void> fetchCampusTasks() async {
    try {
      final response = await http.get(Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.specificPendingAreas));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            allcampustasks =
                jsonData.map((json) => SpecificTask.fromJson(json)).toList();
            _filteredCampusTasks = allcampustasks;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      // Handle exceptions (e.g., network errors)
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          isLoading = false;
        });
      }
      throw e;
    }
  }

  void _filterTasks() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCampusTasks = allcampustasks
          .where((user) =>
              user.specificArea!.toString().toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _refreshTasks() async {
    // Simulate a network request or perform your actual data fetching logic here
    await Future.delayed(const Duration(seconds: 1));

    try {
      await fetchCampusTasks();
    } catch (error) {
      print('Error fetching tasks: $error');
    }
  }

  List<SpecificTask> allcampustasks = [];
  List<SpecificTask> _filteredCampusTasks = [];
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(229, 229, 228, 1),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: "Campus Task search bar",
                child: Material(
                  borderRadius: BorderRadius.circular(40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        maxLines: null,
                        expands: true,
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 10,
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          // icon: GestureDetector(
                          //   onTap: () {
                          //     Navigator.of(context).pop();
                          //   },
                          //   child: const Padding(
                          //     padding: const EdgeInsets.only(left: 20.0),
                          //     child: const Icon(
                          //       Icons.arrow_back,
                          //       size: 25,
                          //       color: Colors.black54,
                          //     ),
                          //   ),
                          // ),
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
                          hintStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
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
              child: _filteredCampusTasks.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "ஒன்றுமில்லை"
                              : "No Result",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SpinKitThreeBounce(
                          color: Color.fromARGB(255, 97, 81, 188),
                          size: 40,
                        ),
                      ],
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshTasks,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _filteredCampusTasks.length,
                        itemBuilder: (context, index) {
                          final task = _filteredCampusTasks[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SpecificTaskSubmission(
                                    specificArea: task.specificArea!,
                                    month: task.month!,
                                    specificTaskId: task.specificTaskId!,
                                    weeknumber: task.weekNumber!,
                                    year: task.year!,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 180,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.specificArea!,
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text(
                                      task.actionTaken!,
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const Expanded(
                                      child: SizedBox(height: 10),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                            // width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  Provider.of<LanguageProvider>(
                                                              context)
                                                          .isTamil
                                                      ? "பணி ஐடி ${task.specificTaskId!.toString()}"
                                                      : 'Task Id: ${task.specificTaskId!.toString()}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    // fontSize:
                                                    //     Provider.of<LanguageProvider>(
                                                    //                 context)
                                                    //             .isTamil
                                                    //         ? 15
                                                    //         : 15,
                                                  ),
                                                ),
                                              ),
                                            )),
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
            ),
          ],
        ),
      ),
    );
  }
}
