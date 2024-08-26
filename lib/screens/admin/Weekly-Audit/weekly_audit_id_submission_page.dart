import 'dart:convert';
import 'package:auditfitnesstest/models/user%20data/all_areas.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/models/user%20data/all_users_model.dart';
import 'package:auditfitnesstest/screens/admin/adminpage.dart';
// import 'package:auditfitnesstest/screens/widgets/User-Widgets/bad_condition_user.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/user_container.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class WeeklyAuditAssignmentpage extends StatefulWidget {
  final int? weeklyAuditweeknumber;
  final String? weeklyAuditId;
  final String? weeklyAuditmonth;
  final int? weeklyAudityear;
  final String? weeklyAuditRange;
  const WeeklyAuditAssignmentpage(
      {super.key,
      required this.weeklyAuditweeknumber,
      required this.weeklyAuditId,
      required this.weeklyAuditmonth,
      required this.weeklyAudityear,
      required this.weeklyAuditRange});

  @override
  State<WeeklyAuditAssignmentpage> createState() =>
      _WeeklyAuditAssignmentpageState();
}

class _WeeklyAuditAssignmentpageState extends State<WeeklyAuditAssignmentpage> {
  // final TextEditingController _usernameController = TextEditingController();
  final List<String> _selectedAreas = [];
  late Future<List<AreasUser>> _futureAreas;
  bool useractiondis = false;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _futureAreas = fetchAreas();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<List<AllUsersModel>> fetchUsers() async {
    final response = await http.get(
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.userdata));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((json) => AllUsersModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<AreasUser>> fetchAreas() async {
    final response = await http.get(Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.specificareas));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => AreasUser.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load areas');
    }
  }

  Future<void> submitweeklyaudittouser() async {
    bool isTamil = box.read('isTamil');
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.assignweeklytaskper);
      var body = json.encode({
        "username": _usernameController.text,
        "weekNumber": widget.weeklyAuditweeknumber,
        "selected_areas": _selectedAreas,
        "weekly_taskId": widget.weeklyAuditId,
        "year": widget.weeklyAudityear,
        "month": widget.weeklyAuditmonth
      });

      var response = await http.post(url, body: body, headers: headers);
      if (response.statusCode == 400) {
        if (mounted) {
          setState(() {
            DelightToastBar(
              position: DelightSnackbarPosition.top,
              autoDismiss: true,
              animationDuration: const Duration(milliseconds: 700),
              snackbarDuration: const Duration(seconds: 2),
              builder: (context) => ToastCard(
                color: Colors.red,
                leading: const Icon(
                  Icons.notification_important_outlined,
                  size: 28,
                  color: Colors.white,
                ),
                title: Text(
                  isTamil ? "பணி ஐடி ஏற்கனவே உள்ளது" : "TaskId already exists",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ).show(context);
            useractiondis = false;
          });
        }
      }

      if (response.statusCode == 200) {
        try {
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
                    isTamil
                        ? "தணிக்கை வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது"
                        : "Audit successfully assigned",
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

          Get.offAll(const AdminNavPage());
        } catch (e) {
          print('Error decoding response body: $e');
        }
      } else {
        try {} catch (e) {
          print('Error decoding error response: $e');
        }
      }
    } catch (error) {
      print('Request error: $error');
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
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Opps!'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          });
    }
  }

  void _onAreaSelected(bool selected, String area) {
    setState(() {
      if (selected) {
        _selectedAreas.add(area);
      } else {
        _selectedAreas.remove(area);
      }
    });
  }

  bool isSelected = false;
  late TextEditingController _usernameController;

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
                          ? "ஐடியை உருவாக்குகிறது"
                          : "Creating audit Id",
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
            : Column(
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
                                Provider.of<LanguageProvider>(context).isTamil
                                    ? "தணிக்கைகளை ஒதுக்குங்கள்"
                                    : "ASSIGN AUDITS",
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? 16
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
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(229, 229, 229, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35.0),
                            topRight: Radius.circular(35.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 15.0,
                            left: 15,
                            top: 10,
                            bottom: 10,
                          ),
                          child: SingleChildScrollView(
                            child: Container(
                              height: MediaQuery.of(context).size.height / 1.1,
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    Provider.of<LanguageProvider>(context)
                                            .isTamil
                                        ? "வாராந்திர தணிக்கை ஐடி"
                                        : 'Weekly Audit ID',
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
                                      widget.weeklyAuditId!,
                                      style: GoogleFonts.manrope(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text(
                                    Provider.of<LanguageProvider>(context)
                                            .isTamil
                                        ? "வாராந்திர தணிக்கை தேதி"
                                        : 'Weekly Audit Date',
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
                                      widget.weeklyAuditRange!,
                                      style: GoogleFonts.manrope(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text(
                                    Provider.of<LanguageProvider>(context)
                                            .isTamil
                                        ? "பயனர் பெயர்"
                                        : 'User Name',
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TypeAheadField(
                                    direction: VerticalDirection.up,
                                    builder: (context, controller, focusNode) {
                                      return TextField(
                                        textInputAction: TextInputAction.done,
                                        controller: controller,
                                        focusNode: focusNode,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          border: InputBorder.none,
                                          hintText:
                                              Provider.of<LanguageProvider>(
                                                          context)
                                                      .isTamil
                                                  ? "முக்கிய பகுதி"
                                                  : "Enter username",
                                          hintStyle: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                    suggestionsCallback: (pattern) async {
                                      List<AllUsersModel> allUsers =
                                          await fetchUsers();
                                      return allUsers
                                          .where((user) =>
                                              user.role == 2 &&
                                              user.username!.contains(pattern))
                                          .toList();
                                    },
                                    itemBuilder:
                                        (context, AllUsersModel suggestion) {
                                      return ListTile(
                                        title: Text(suggestion.username!),
                                      );
                                    },
                                    controller: _usernameController,
                                    onSelected: (AllUsersModel suggestion) {
                                      _usernameController.text =
                                          suggestion.username!;
                                    },
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text(
                                    Provider.of<LanguageProvider>(context)
                                            .isTamil
                                        ? "குறிப்பிட்ட பகுதிகளைத் தேர்ந்தெடுக்கவும்"
                                        : 'Select Specific Areas',
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Container(
                                    // height: MediaQuery.of(context).size.height / 2,
                                    child: FutureBuilder<List<AreasUser>>(
                                      future: _futureAreas,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          return Expanded(
                                            child: Scrollbar(
                                              child: ListView(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                children: snapshot.data!
                                                    .map((areaUser) {
                                                  bool isSelected =
                                                      _selectedAreas.contains(
                                                          areaUser
                                                              .areaSpecific);
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _onAreaSelected(
                                                              !isSelected,
                                                              areaUser
                                                                  .areaSpecific!);
                                                        });
                                                      },
                                                      child: UserContainer(
                                                        color: isSelected
                                                            ? const Color
                                                                .fromRGBO(
                                                                229, 184, 91, 1)
                                                            : Colors.white,
                                                        inside: Text(
                                                          Provider.of<LanguageProvider>(
                                                                      context)
                                                                  .isTamil
                                                              ? areaUser
                                                                  .areaSpecificTamil!
                                                              : areaUser
                                                                  .areaSpecific!,
                                                          style: GoogleFonts
                                                              .manrope(
                                                            color: isSelected
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_usernameController.text.isEmpty &&
                                          isSelected == false) {
                                        setState(() {
                                          DelightToastBar(
                                            position:
                                                DelightSnackbarPosition.top,
                                            autoDismiss: true,
                                            snackbarDuration:
                                                Durations.extralong4,
                                            builder: (context) => ToastCard(
                                              color: Colors.red,
                                              leading: const Icon(
                                                Icons
                                                    .notification_important_outlined,
                                                size: 28,
                                                color: Colors.white,
                                              ),
                                              title: Text(
                                                Provider.of<LanguageProvider>(
                                                            context)
                                                        .isTamil
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
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
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
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(37),
                                                        bottomRight:
                                                            Radius.circular(37),
                                                        topLeft:
                                                            Radius.circular(37),
                                                        topRight:
                                                            Radius.circular(37),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
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
                                                            style: GoogleFonts
                                                                .manrope(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: Provider.of<
                                                                              LanguageProvider>(
                                                                          context)
                                                                      .isTamil
                                                                  ? 19
                                                                  : 23,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              OutlinedButton(
                                                                style: OutlinedButton
                                                                    .styleFrom(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        32,
                                                                  ),
                                                                  foregroundColor:
                                                                      Colors
                                                                          .black87,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  side:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  Provider.of<LanguageProvider>(
                                                                              context)
                                                                          .isTamil
                                                                      ? "இல்லை"
                                                                      : "No",
                                                                  style: GoogleFonts.manrope(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize: Provider.of<LanguageProvider>(context)
                                                                              .isTamil
                                                                          ? 12
                                                                          : 15),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              ElevatedButton(
                                                                style:
                                                                    const ButtonStyle(
                                                                  padding:
                                                                      WidgetStatePropertyAll(
                                                                    EdgeInsets
                                                                        .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          32,
                                                                    ),
                                                                  ),
                                                                  backgroundColor:
                                                                      WidgetStatePropertyAll(Color.fromRGBO(
                                                                          130,
                                                                          204,
                                                                          146,
                                                                          1)),
                                                                  shape:
                                                                      WidgetStatePropertyAll(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            5),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                onPressed: () {
                                                                  submitweeklyaudittouser();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  setState(() {
                                                                    useractiondis =
                                                                        true;
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
                                          "Submit",
                                          style: GoogleFonts.manrope(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
