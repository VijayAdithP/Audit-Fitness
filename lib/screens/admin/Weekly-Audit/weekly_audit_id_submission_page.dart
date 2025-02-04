import 'dart:convert';
import 'package:auditfitnesstest/assets/colors.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageProvider = Provider.of<LanguageProvider>(context);
  }

  late LanguageProvider _languageProvider;
  Future<void> submitweeklyaudittouser() async {
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
                color: alertred,
                leading: const Icon(
                  Icons.notification_important_outlined,
                  size: 28,
                  color: Colors.white,
                ),
                title: Text(
                  _languageProvider.isTamil
                      ? "பணி ஐடி ஏற்கனவே உள்ளது"
                      : "TaskId already exists",
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
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
                          ? "வேலை வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது"
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
          });

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
      isSelected = _selectedAreas.isNotEmpty;
    });
  }

  bool isSelected = false;

  late TextEditingController _usernameController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                  ? "வேலை ஒதுக்க"
                  : "ASSIGN AUDITS",
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
                            ? "ஐடியை உருவாக்குகிறது"
                            : "Creating audit Id",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize:
                              Provider.of<LanguageProvider>(context).isTamil
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
                    //               Provider.of<LanguageProvider>(context).isTamil
                    //                   ? "வேலை ஒதுக்க"
                    //                   : "ASSIGN AUDITS",
                    //               style: GoogleFonts.manrope(
                    //                 color: Colors.white,
                    //                 fontSize:
                    //                     Provider.of<LanguageProvider>(context)
                    //                             .isTamil
                    //                         ? 16
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
                        decoration: BoxDecoration(
                          color: lighterbackgroundblue,
                          // borderRadius: BorderRadius.only(
                          //   topLeft: Radius.circular(35.0),
                          //   topRight: Radius.circular(35.0),
                          // ),
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
                                        ? "வார வேலை ஐடி"
                                        : 'Weekly Audit ID',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: darkblue,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  UserContainer(
                                    color: Colors.white,
                                    inside: Text(
                                      widget.weeklyAuditId!,
                                      style: TextStyle(
                                        fontSize: 17,
                                        // fontWeight: FontWeight.bold,
                                        color: darkblue,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text(
                                    Provider.of<LanguageProvider>(context)
                                            .isTamil
                                        ? "வார வேலை தேதி"
                                        : 'Weekly Audit Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: darkblue,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  UserContainer(
                                    color: Colors.white,
                                    inside: Text(
                                      widget.weeklyAuditRange!,
                                      style: TextStyle(
                                        fontSize: 17,
                                        // fontWeight: FontWeight.bold,
                                        color: darkblue,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                        text: Provider.of<LanguageProvider>(
                                                    context)
                                                .isTamil
                                            ? "பயனர் பெயர்"
                                            : 'User Name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: darkblue,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "*",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.red,
                                        ),
                                      )
                                    ]),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  // Provider.of<LanguageProvider>(context)
                                  //         .isTamil
                                  //     ? "பயனர் பெயர்"
                                  //     : 'User Name',
                                  // style: TextStyle(
                                  //   fontWeight: FontWeight.bold,
                                  //   fontSize: 20,
                                  //   color: darkblue,
                                  // ),
                                  //     ),
                                  //     Text(
                                  //       '*',
                                  //       style: TextStyle(
                                  //         fontWeight: FontWeight.bold,
                                  //         fontSize: 20,
                                  //         color: Colors.red,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TypeAheadField(
                                    direction: VerticalDirection.up,
                                    decorationBuilder: (context, child) =>
                                        DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: CupertinoTheme.of(context)
                                            .barBackgroundColor
                                            .withValues(alpha: 1),
                                        border: Border.all(
                                          color: CupertinoDynamicColor.resolve(
                                            CupertinoColors.systemGrey4,
                                            context,
                                          ),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: child,
                                    ),
                                    offset: Offset(0, 12),
                                    constraints: BoxConstraints(maxHeight: 500),
                                    builder: (context, controller, focusNode) {
                                      return TextField(
                                        maxLines: null,
                                        textInputAction: TextInputAction.done,
                                        controller: controller,
                                        focusNode: focusNode,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  189, 189, 189, 1),
                                            ),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  189, 189, 189, 1),
                                            ),
                                          ),
                                          border: InputBorder.none,
                                          hintText:
                                              Provider.of<LanguageProvider>(
                                                          context)
                                                      .isTamil
                                                  ? "முக்கிய பகுதி"
                                                  : "Enter username",
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: darkblue,
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
                                  Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                        text: Provider.of<LanguageProvider>(
                                                    context)
                                                .isTamil
                                            ? "குறிப்பிட்ட பகுதிகளைத் தேர்ந்தெடுக்கவும்"
                                            : 'Select Specific Areas',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: darkblue,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '*',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ]),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child: Text(
                                  // Provider.of<LanguageProvider>(context)
                                  //         .isTamil
                                  //     ? "குறிப்பிட்ட பகுதிகளைத் தேர்ந்தெடுக்கவும்"
                                  //     : 'Select Specific Areas',
                                  // style: TextStyle(
                                  //   fontWeight: FontWeight.bold,
                                  //   fontSize: 20,
                                  //   color: darkblue,
                                  // ),
                                  //       ),
                                  //     ),
                                  //     Text(
                                  //       '*',
                                  //       style: TextStyle(
                                  //         fontWeight: FontWeight.bold,
                                  //         fontSize: 20,
                                  //         color: Colors.red,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 10.0),
                                  Container(
                                    // height: MediaQuery.of(context).size.height / 2,
                                    child: FutureBuilder<List<AreasUser>>(
                                      future: _futureAreas,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: const SpinKitThreeBounce(
                                              color: const Color.fromARGB(
                                                  255, 130, 111, 238),
                                              size: 30,
                                            ),
                                          );
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
                                                            ? lightbackgroundblue
                                                            : Colors.white,
                                                        inside: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                Provider.of<LanguageProvider>(
                                                                            context)
                                                                        .isTamil
                                                                    ? areaUser
                                                                        .areaSpecificTamil!
                                                                    : areaUser
                                                                        .areaSpecific!,
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      darkblue,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            if (isSelected)
                                                              Icon(
                                                                Icons
                                                                    .done_rounded,
                                                                color: paleblue,
                                                              ),
                                                          ],
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
                                      if (_usernameController.text.isEmpty ||
                                          !isSelected) {
                                        setState(() {
                                          DelightToastBar(
                                            position:
                                                DelightSnackbarPosition.top,
                                            autoDismiss: true,
                                            snackbarDuration:
                                                Durations.extralong4,
                                            builder: (context) => ToastCard(
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
                                            return Dialog(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
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
                                                      padding: const EdgeInsets
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
                                                              color: darkblue,
                                                              fontSize: Provider.of<
                                                                              LanguageProvider>(
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
                                                                      left: 10,
                                                                      right: 10,
                                                                    ),
                                                                    child: Text(
                                                                      Provider.of<LanguageProvider>(context)
                                                                              .isTamil
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
                                                                              .5),
                                                                  thickness: 1,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    submitweeklyaudittouser();
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
                                                                      left: 10,
                                                                      right: 10,
                                                                    ),
                                                                    child: Text(
                                                                      Provider.of<LanguageProvider>(context)
                                                                              .isTamil
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
                                        color: greyblue,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          Provider.of<LanguageProvider>(context)
                                                  .isTamil
                                              ? "சமர்ப்பிக்க"
                                              : "Submit",
                                          style: TextStyle(
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
                  ],
                ),
        ),
      ),
    );
  }
}
