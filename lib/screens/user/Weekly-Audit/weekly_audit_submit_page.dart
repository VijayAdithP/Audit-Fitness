import 'dart:convert';
import 'dart:io';
import 'package:auditfitnesstest/assets/colors.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/models/admin%20specific/question_model.dart';
import 'package:auditfitnesstest/models/user%20data/specific_user_main_area_model.dart';
import 'package:auditfitnesstest/models/user%20data/usermodel.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/bad_condition_user.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/dropdown_user.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/user_container.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class WeeklyUserAuditSubmmitPage extends StatefulWidget {
  const WeeklyUserAuditSubmmitPage(
      {required this.auditarea,
      required this.auditdata,
      required this.auditId,
      super.key,
      required this.auditmonth,
      required this.audityear,
      required this.auditweeknumber,
      this.auditAuditRange});

  final String? auditarea;
  final String? auditdata;
  final String? auditId;
  final String? auditmonth;
  final String? audityear;
  final String? auditweeknumber;
  final String? auditAuditRange;
  @override
  State<WeeklyUserAuditSubmmitPage> createState() =>
      _WeeklyUserAuditSubmmitPageState();
}

final box = GetStorage();

final TextEditingController suggestioncontroller = TextEditingController();

String username = '';
String userdate = '';
int? userPhonenumber;

bool language = true;

class _WeeklyUserAuditSubmmitPageState
    extends State<WeeklyUserAuditSubmmitPage> {
  final box = GetStorage();
  List<QuestionModel> questions = [];
  Map<int, String?> answers = {};
  Map<int, TextEditingController> controllers = {};
  Map<int, File?> images = {};

  final ImagePicker _picker = ImagePicker();
  int? userDataNumber;

  String MainAreaVar = "";

  SpecificUserMainAreaModel? mainAreaData;

  bool _useractivityblock = false;

  @override
  void initState() {
    super.initState();
    fetchMainArea();
    fetchUserPhoneNumber();
    fetchQuestions();
  }

  bool allDropdownsFilled = false;

  bool allRemarksFilled = false;
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void checkCondition() {
    List<int?> relevantIds = questions.map((q) => q.id).toList();

    bool areAllRemarksFilled = relevantIds.every((id) {
      return id != null && answers.containsKey(id) && answers[id]!.isNotEmpty;
    });

    setState(() {
      allRemarksFilled = areAllRemarksFilled;
    });
  }

  Future<void> fetchUserPhoneNumber() async {
    username = box.read('username');
    final response = await http.get(Uri.parse(
        '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.userdata}/$username'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          userDataNumber = UserModel.fromJson(json).phoneNumber;
        });
      }
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> fetchQuestions() async {
    try {
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.questionsBySpecArea}?area_specific=${widget.auditarea}');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            questions =
                data.map((json) => QuestionModel.fromJson(json)).toList();
            for (var question in questions) {
              controllers[question.id!] = TextEditingController();
            }
          });
        }
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  Future<void> fetchMainArea() async {
    DateTime dateTime = DateTime.parse(widget.auditdata!);
    userdate = DateFormat('yyyy-MM-dd').format(dateTime);
    try {
      final response = await http.get(Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.mainareaBySpecArea}?area_specific=${widget.auditarea!}'));

      if (response.statusCode == 200) {
        List<dynamic> responseBody = jsonDecode(response.body);
        if (responseBody.isNotEmpty) {
          if (mounted) {
            setState(() {
              mainAreaData =
                  SpecificUserMainAreaModel.fromJson(responseBody[0]);
              MainAreaVar = mainAreaData!.mainArea!;
            });
          }
          // print(mainAreaData!.mainArea);
        } else {
          throw Exception('Empty response');
        }
      } else {
        throw Exception('Failed to load main area');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }

    allRemarksFilled = false;
    allDropdownsFilled = false;
    suggestioncontroller.clear();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageProvider = Provider.of<LanguageProvider>(context);
  }

  late LanguageProvider _languageProvider;
  Future<void> auditsubmituser() async {
    username = box.read('username');
    try {
      var uri = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.submitUserWeeklyAudit);
      var request = http.MultipartRequest('POST', uri);

      request.fields['main_area'] = MainAreaVar;
      request.fields['specific_area'] = widget.auditarea!;
      request.fields['task_id'] = widget.auditId!;
      request.fields['audit_date'] = currentDate;
      request.fields['week_number'] = widget.auditweeknumber!;
      request.fields['month'] = widget.auditmonth!;
      request.fields['year'] = widget.audityear!;
      request.fields['auditor_name'] = username;
      request.fields['auditor_phone'] = userDataNumber.toString();
      request.fields['suggestions'] = suggestioncontroller.text;

      List<Map<String, dynamic>> questionData = [];
      for (var question in questions) {
        questionData.add({
          'question_number': question.id,
          'question': question.question,
          'remark': answers[question.id],
          'comment': controllers[question.id]!.text,
        });

        if (images[question.id] != null) {
          var stream = http.ByteStream(images[question.id]!.openRead());
          var length = await images[question.id]!.length();
          var multipartFile = http.MultipartFile(
            'image_${question.id}',
            stream,
            length,
            filename: path.basename(images[question.id]!.path),
          );
          request.files.add(multipartFile);
        }
      }
      request.fields['audit_details'] = jsonEncode(questionData);

      var response = await request.send();

      if (response.statusCode == 200) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
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
                        : "Audit successfully submitted",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ).show(context);
              _useractivityblock = true;
            });
          }
        });

        // Get.offAll(() => const UserHomePage());
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to submit audit');
      }
    } catch (e) {
      _useractivityblock = false;
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Oops!'),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(e.toString())],
          );
        },
      );
    }
  }

  bool _isRequestingPermission = false;

  @override
  Widget build(BuildContext context) {
    username = box.read('username');
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: lighterbackgroundblue,
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
                  ? "வேலை விவரங்கள்"
                  : "WEEKLY AUDITS",
              style: TextStyle(
                color: darkblue,
                fontWeight: FontWeight.bold,
                fontSize:
                    Provider.of<LanguageProvider>(context).isTamil ? 18 : 21,
              ),
            ),
          ),
          body: _useractivityblock
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
                    //     // top: 10.0,
                    //     left: 15.0,
                    //     right: 15.0,
                    //     bottom: 10.0,
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
                    //                   ? "வேலை விவரங்கள்"
                    //                   : "WEEKLY AUDITS",
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
                        decoration: BoxDecoration(
                          color: lighterbackgroundblue,
                          // borderRadius: BorderRadius.only(
                          //   topLeft: Radius.circular(35.0),
                          //   topRight: Radius.circular(35.0),
                          // ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              left: 15.0,
                              right: 15.0,
                              bottom: 10.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "ஆடிட்டர்"
                                      : "Auditor",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: greyblue,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                UserContainer(
                                  color: Colors.white,
                                  inside: Text(
                                    username,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "தொலைபேசி எண்"
                                      : "PhoneNumber",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: greyblue,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                UserContainer(
                                  color: Colors.white,
                                  inside: Text(
                                    userDataNumber.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: greyblue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "வேலை ஐடி"
                                      : "Audit Id",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: greyblue,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                UserContainer(
                                  color: Colors.white,
                                  inside: Text(
                                    widget.auditId!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: greyblue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "தேதி"
                                      : "Date",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: greyblue,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                UserContainer(
                                  color: Colors.white,
                                  inside: Text(
                                    widget.auditAuditRange!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: greyblue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "முக்கிய பகுதி பெயர்"
                                      : "Main Area Name",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: greyblue,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                UserContainer(
                                  color: Colors.white,
                                  inside: Text(
                                    MainAreaVar,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: greyblue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "பகுதி பெயர்"
                                      : "Area Name",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: greyblue,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                UserContainer(
                                  color: Colors.white,
                                  inside: Text(
                                    widget.auditarea!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: greyblue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Divider(
                                  thickness: 3,
                                  color: Colors.grey.withValues(alpha: 0.5),
                                  height: 20,
                                ),
                                ...questions.map(
                                  (question) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                Provider.of<LanguageProvider>(
                                                            context)
                                                        .isTamil
                                                    ? question.questionTamil!
                                                    : question.question!,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: greyblue,
                                                ),
                                              ),
                                            ),
                                            if (answers[question.id] == 'bad' &&
                                                (controllers[question.id!]!
                                                        .text
                                                        .isEmpty ||
                                                    images[question.id!] ==
                                                        null))
                                              const Icon(
                                                Icons.error_outline,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        DropdownUser(
                                          onChanged: (String? value) {
                                            setState(() {
                                              answers[question.id!] = value;
                                              checkCondition();
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 5),
                                        if (answers[question.id] == null)
                                          Divider(
                                            thickness: 3,
                                            color: Colors.grey
                                                .withValues(alpha: 0.5),
                                            height: 20,
                                          ),
                                        if (answers[question.id] == 'good')
                                          Divider(
                                            thickness: 3,
                                            color: Colors.grey
                                                .withValues(alpha: 0.5),
                                            height: 20,
                                          ),
                                        if (answers[question.id] == 'bad')
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: TextField(
                                                  maxLines: null,
                                                  controller: controllers[
                                                      question.id!]!,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color:
                                                            Colors.grey[400]!,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color:
                                                            Colors.grey[400]!,
                                                      ),
                                                    ),
                                                    border: InputBorder.none,
                                                    hintText: Provider.of<
                                                                    LanguageProvider>(
                                                                context)
                                                            .isTamil
                                                        ? "நிபந்தனையைக் குறிப்பிடவும்*"
                                                        : "Specify the condition *",
                                                    hintStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: greyblue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              IntrinsicHeight(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          // Check if a permission request is already running
                                                          if (_isRequestingPermission)
                                                            return;

                                                          _isRequestingPermission =
                                                              true;

                                                          try {
                                                            // Request the camera permission
                                                            PermissionStatus
                                                                status =
                                                                await Permission
                                                                    .camera
                                                                    .request();

                                                            if (status
                                                                .isGranted) {
                                                              // If permission is granted, proceed with picking the image
                                                              final pickedFile =
                                                                  await _picker
                                                                      .pickImage(
                                                                          source:
                                                                              ImageSource.camera);
                                                              if (pickedFile !=
                                                                      null &&
                                                                  question.id !=
                                                                      null) {
                                                                setState(() {
                                                                  images[question
                                                                          .id!] =
                                                                      File(pickedFile
                                                                          .path);
                                                                });
                                                              }
                                                            } else if (status
                                                                    .isDenied ||
                                                                status
                                                                    .isPermanentlyDenied) {
                                                              openAppSettings();
                                                            }
                                                          } catch (e) {
                                                            print(
                                                                "Error requesting camera permission: $e");
                                                          } finally {
                                                            _isRequestingPermission =
                                                                false;
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                lightbackgroundblue,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  15),
                                                            ),
                                                            border: Border.all(
                                                              color: Colors
                                                                  .grey[400]!,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .camera_alt,
                                                                    color:
                                                                        greyblue,
                                                                    size: 20),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom: Provider.of<LanguageProvider>(context)
                                                                            .isTamil
                                                                        ? 0
                                                                        : MediaQuery.of(context)
                                                                            .devicePixelRatio,
                                                                    top: Provider.of<LanguageProvider>(context)
                                                                            .isTamil
                                                                        ? MediaQuery.of(context)
                                                                            .devicePixelRatio
                                                                        : 0,
                                                                  ),
                                                                  child:
                                                                      // Row(
                                                                      //   children: [
                                                                      //     Text(
                                                                      //       Provider.of<LanguageProvider>(context).isTamil
                                                                      //           ? "எடுக்க"
                                                                      //           : "Take pic",
                                                                      //       style:
                                                                      //           TextStyle(
                                                                      //         fontSize:
                                                                      //             16,
                                                                      //         fontWeight:
                                                                      //             FontWeight.w500,
                                                                      //         color:
                                                                      //             greyblue,
                                                                      //       ),
                                                                      //     ),
                                                                      //     Text(
                                                                      //       '*',
                                                                      //       style:
                                                                      //           TextStyle(
                                                                      //         fontWeight:
                                                                      //             FontWeight.bold,
                                                                      //         fontSize:
                                                                      //             16,
                                                                      //         color:
                                                                      //             Colors.red,
                                                                      //       ),
                                                                      //     ),
                                                                      //   ],
                                                                      // ),
                                                                      Text.rich(
                                                                    TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text: Provider.of<LanguageProvider>(context).isTamil
                                                                                ? "எடுக்க"
                                                                                : "Take pic",
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 16,
                                                                              color: greyblue,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                "*",
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16,
                                                                              color: needred,
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    VerticalDivider(
                                                      color: Colors.grey
                                                          .withValues(
                                                              alpha: 0.5),
                                                      thickness: 2,
                                                    ),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          final pickedFile =
                                                              await _picker.pickImage(
                                                                  source: ImageSource
                                                                      .gallery);
                                                          if (pickedFile !=
                                                                  null &&
                                                              question.id !=
                                                                  null) {
                                                            setState(() {
                                                              images[question
                                                                      .id!] =
                                                                  File(pickedFile
                                                                      .path);
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                lightbackgroundblue,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  15),
                                                            ),
                                                            border: Border.all(
                                                              color: Colors
                                                                  .grey[400]!,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    Icons.photo,
                                                                    color:
                                                                        greyblue,
                                                                    size: 20),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom: Provider.of<LanguageProvider>(context)
                                                                            .isTamil
                                                                        ? 0
                                                                        : MediaQuery.of(context)
                                                                            .devicePixelRatio,
                                                                    top: Provider.of<LanguageProvider>(context)
                                                                            .isTamil
                                                                        ? MediaQuery.of(context)
                                                                            .devicePixelRatio
                                                                        : 0,
                                                                  ),
                                                                  child:

                                                                      // Row(
                                                                      //   children: [
                                                                      //     Text(
                                                                      //       Provider.of<LanguageProvider>(context).isTamil
                                                                      //           ? "கேலரி"
                                                                      //           : "Add Image",
                                                                      //       style:
                                                                      //           TextStyle(
                                                                      //         fontSize:
                                                                      //             16,
                                                                      //         fontWeight:
                                                                      //             FontWeight.w500,
                                                                      //         color:
                                                                      //             greyblue,
                                                                      //       ),
                                                                      //     ),
                                                                      //     Text(
                                                                      //       '*',
                                                                      //       style:
                                                                      //           TextStyle(
                                                                      //         fontWeight:
                                                                      //             FontWeight.bold,
                                                                      //         fontSize:
                                                                      //             16,
                                                                      //         color:
                                                                      //             Colors.red,
                                                                      //       ),
                                                                      //     ),
                                                                      //   ],
                                                                      // ),
                                                                      Text.rich(
                                                                    TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text: Provider.of<LanguageProvider>(context).isTamil
                                                                                ? "கேலரி"
                                                                                : "Add Image",
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 16,
                                                                              color: greyblue,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                "*",
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16,
                                                                              color: needred,
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              if (images[question.id!] != null)
                                                Row(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            height: 150,
                                                            width: 150,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          10)),
                                                              // border: Border.all(
                                                              //     color: Colors.black,
                                                              //     width: 2),
                                                              image:
                                                                  DecorationImage(
                                                                fit:
                                                                    BoxFit.fill,
                                                                image: FileImage(
                                                                    images[question
                                                                        .id!]!),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 125,
                                                          left: 125,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  images[question
                                                                          .id!] =
                                                                      null;
                                                                });
                                                              },
                                                              child: const Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Divider(
                                                thickness: 3,
                                                color: Colors.grey
                                                    .withValues(alpha: 0.5),
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                // const SizedBox(
                                //   height: 16,
                                // ),
                                Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "பகுதி பரிந்துரை"
                                      : "Any Suggestion?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: greyblue,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Badconditionields(
                                  controller: suggestioncontroller,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "பரிந்துரைகள்"
                                          : "Suggestions",
                                ),
                                const SizedBox(height: 20),

                                // GestureDetector(
                                //   onTap: () {
                                //     XFile? camera =
                                //         box.read('pickedFile_camera_file');
                                //     XFile? gallery =
                                //         box.read('pickedFile_gallery_file');
                                //     bool empty = true;
                                //     for (var question in questions) {
                                //       setState(() {
                                //         empty = controllers[question.id!]!
                                //             .text
                                //             .isNotEmpty;
                                //       });
                                //     }
                                //     if (!allRemarksFilled &&
                                //         answers[question.id] == 'bad' &&
                                //         (controllers[question.id!]!
                                //                 .text
                                //                 .isEmpty ||
                                //             images[question.id!] == null)) {
                                //       DelightToastBar(
                                //         position: DelightSnackbarPosition.top,
                                //         autoDismiss: true,
                                //         snackbarDuration: Durations.extralong4,
                                //         builder: (context) => ToastCard(
                                //           color: Colors.red,
                                //           leading: const Icon(
                                //             Icons
                                //                 .notification_important_outlined,
                                //             size: 28,
                                //             color: Colors.white,
                                //           ),
                                //           title: Text(
                                //             Provider.of<LanguageProvider>(
                                //                         context)
                                //                     .isTamil
                                //                 ? "அனைத்து புலங்களையும் நிரப்பவும்"
                                //                 : "Fill all the fields",
                                //             style: const TextStyle(
                                //               fontWeight: FontWeight.w700,
                                //               fontSize: 14,
                                //               color: Colors.white,
                                //             ),
                                //           ),
                                //         ),
                                //       ).show(context);
                                //     } else {
                                //       showDialog(
                                //         context: context,
                                //         builder: (BuildContext context) {
                                //           return Dialog(
                                //             backgroundColor: Colors.white,
                                //             shape: RoundedRectangleBorder(
                                //               borderRadius:
                                //                   BorderRadius.circular(40.0),
                                //             ),
                                //             child: ClipRRect(
                                //               borderRadius:
                                //                   BorderRadius.circular(40.0),
                                //               child: Padding(
                                //                 padding: const EdgeInsets.only(
                                //                   top: 3,
                                //                   left: 3,
                                //                   right: 3,
                                //                   bottom: 3,
                                //                 ),
                                //                 child: Container(
                                //                   width: 150,
                                //                   decoration:
                                //                       const BoxDecoration(
                                //                     color: Colors.white,
                                //                     borderRadius:
                                //                         BorderRadius.only(
                                //                       bottomLeft:
                                //                           Radius.circular(37),
                                //                       bottomRight:
                                //                           Radius.circular(37),
                                //                       topLeft:
                                //                           Radius.circular(37),
                                //                       topRight:
                                //                           Radius.circular(37),
                                //                     ),
                                //                   ),
                                //                   child: Padding(
                                //                     padding: const EdgeInsets
                                //                         .symmetric(
                                //                         horizontal: 20.0),
                                //                     child: Column(
                                //                       mainAxisSize:
                                //                           MainAxisSize.min,
                                //                       crossAxisAlignment:
                                //                           CrossAxisAlignment
                                //                               .center,
                                //                       children: [
                                //                         const SizedBox(
                                //                           height: 20,
                                //                         ),
                                //                         Text(
                                //                           Provider.of<LanguageProvider>(
                                //                                       context)
                                //                                   .isTamil
                                //                               ? "நீங்கள் உறுதியாக இருக்கிறீர்களா?"
                                //                               : "Are you sure?",
                                //                           style: GoogleFonts
                                //                               .manrope(
                                //                             color: Colors.black,
                                //                             fontSize: Provider.of<
                                //                                             LanguageProvider>(
                                //                                         context)
                                //                                     .isTamil
                                //                                 ? 19
                                //                                 : 23,
                                //                             fontWeight:
                                //                                 FontWeight.w500,
                                //                           ),
                                //                         ),
                                //                         const SizedBox(
                                //                           height: 20,
                                //                         ),
                                //                         Row(
                                //                           mainAxisAlignment:
                                //                               MainAxisAlignment
                                //                                   .spaceEvenly,
                                //                           children: [
                                //                             OutlinedButton(
                                //                               style:
                                //                                   OutlinedButton
                                //                                       .styleFrom(
                                //                                 padding:
                                //                                     const EdgeInsets
                                //                                         .symmetric(
                                //                                   vertical: 8,
                                //                                   horizontal:
                                //                                       32,
                                //                                 ),
                                //                                 foregroundColor:
                                //                                     Colors
                                //                                         .black87,
                                //                                 shape:
                                //                                     RoundedRectangleBorder(
                                //                                   borderRadius:
                                //                                       BorderRadius
                                //                                           .circular(
                                //                                               5),
                                //                                 ),
                                //                                 side:
                                //                                     const BorderSide(
                                //                                   color: Colors
                                //                                       .black87,
                                //                                 ),
                                //                               ),
                                //                               child: Text(
                                //                                 Provider.of<LanguageProvider>(
                                //                                             context)
                                //                                         .isTamil
                                //                                     ? "இல்லை"
                                //                                     : "No",
                                //                                 style: GoogleFonts.manrope(
                                //                                     color: Colors
                                //                                         .black87,
                                //                                     fontWeight:
                                //                                         FontWeight
                                //                                             .w500,
                                //                                     fontSize:
                                //                                         Provider.of<LanguageProvider>(context).isTamil
                                //                                             ? 12
                                //                                             : 15),
                                //                               ),
                                //                               onPressed: () {
                                //                                 Navigator.of(
                                //                                         context)
                                //                                     .pop();
                                //                               },
                                //                             ),
                                //                             ElevatedButton(
                                //                               style:
                                //                                   const ButtonStyle(
                                //                                 padding:
                                //                                     WidgetStatePropertyAll(
                                //                                   EdgeInsets
                                //                                       .symmetric(
                                //                                     vertical: 8,
                                //                                     horizontal:
                                //                                         32,
                                //                                   ),
                                //                                 ),
                                //                                 backgroundColor:
                                //                                     WidgetStatePropertyAll(
                                //                                   Color
                                //                                       .fromRGBO(
                                //                                           130,
                                //                                           204,
                                //                                           146,
                                //                                           1),
                                //                                 ),
                                //                                 shape:
                                //                                     WidgetStatePropertyAll(
                                //                                   RoundedRectangleBorder(
                                //                                     borderRadius:
                                //                                         BorderRadius
                                //                                             .all(
                                //                                       Radius
                                //                                           .circular(
                                //                                               5),
                                //                                     ),
                                //                                   ),
                                //                                 ),
                                //                               ),
                                //                               child: const Icon(
                                //                                 Icons.check,
                                //                                 color: Colors
                                //                                     .white,
                                //                               ),
                                //                               onPressed: () {
                                //                                 auditsubmituser();
                                //                                 Navigator.of(
                                //                                         context)
                                //                                     .pop();
                                //                                 setState(() {
                                //                                   _useractivityblock =
                                //                                       true;
                                //                                 });
                                //                               },
                                //                             ),
                                //                           ],
                                //                         ),
                                //                         const SizedBox(
                                //                           height: 20,
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ),
                                //             ),
                                //           );
                                //         },
                                //       );
                                //     }
                                //   },
                                // child: Container(
                                //   height: 50,
                                //   width: double.maxFinite,
                                //   decoration: const BoxDecoration(
                                //     color: Colors.black,
                                //     borderRadius:
                                //         BorderRadius.all(Radius.circular(20)),
                                //   ),
                                //   child: Center(
                                //     child: Text(
                                //       "Submit",
                                //       style: GoogleFonts.manrope(
                                //         color: Colors.white,
                                //         fontSize: 17,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // ),

                                GestureDetector(
                                  onTap: () {
                                    // Iterate through all the questions to check conditions
                                    for (var question in questions) {
                                      // Update the state to determine if the current question's text is empty

                                      // If any 'bad' remark is not properly filled, show a toast message
                                      if (!allRemarksFilled ||
                                          answers[question.id] == 'bad' &&
                                              (controllers[question.id!]!
                                                      .text
                                                      .isEmpty ||
                                                  images[question.id!] ==
                                                      null)) {
                                        if (mounted) {
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
                                                      ? "அனைத்து புலங்களையும் நிரப்பவும்"
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
                                        }

                                        return;
                                      }
                                    }

                                    if (allRemarksFilled) {
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
                                                padding: const EdgeInsets.only(
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
                                                            color: Colors.black,
                                                            fontSize: Provider.of<
                                                                            LanguageProvider>(
                                                                        context)
                                                                    .isTamil
                                                                ? 19
                                                                : 23,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                                child: Padding(
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
                                                                        fontWeight:
                                                                            FontWeight
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
                                                                thickness: 1,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  auditsubmituser();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  setState(() {
                                                                    _useractivityblock =
                                                                        true;
                                                                  });
                                                                },
                                                                child: Padding(
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
                                                                        fontWeight:
                                                                            FontWeight
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
                                          // Dialog(
                                          //   backgroundColor: Colors.white,
                                          //   shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(15.0),
                                          //   ),
                                          //   child: ClipRRect(
                                          //     borderRadius:
                                          //         BorderRadius.circular(15.0),
                                          //     child: Padding(
                                          //       padding:
                                          //           const EdgeInsets.all(3.0),
                                          //       child: Container(
                                          //         width: 150,
                                          //         decoration:
                                          //             const BoxDecoration(
                                          //           color: Colors.white,
                                          //           borderRadius:
                                          //               BorderRadius.all(
                                          //                   Radius.circular(
                                          //                       37)),
                                          //         ),
                                          //         child: Padding(
                                          //           padding: const EdgeInsets
                                          //               .symmetric(
                                          //               horizontal: 20.0),
                                          //           child: Column(
                                          //             mainAxisSize:
                                          //                 MainAxisSize.min,
                                          //             crossAxisAlignment:
                                          //                 CrossAxisAlignment
                                          //                     .center,
                                          //             children: [
                                          //               const SizedBox(
                                          //                   height: 20),
                                          //               Text(
                                          //                 Provider.of<LanguageProvider>(
                                          //                             context)
                                          //                         .isTamil
                                          //                     ? "நீங்கள் உறுதியாக இருக்கிறீர்களா?"
                                          //                     : "Are you sure?",
                                          //                 style: GoogleFonts
                                          //                     .manrope(
                                          //                   color: Colors.black,
                                          //                   fontSize: Provider.of<
                                          //                                   LanguageProvider>(
                                          //                               context)
                                          //                           .isTamil
                                          //                       ? 19
                                          //                       : 23,
                                          //                   fontWeight:
                                          //                       FontWeight.w500,
                                          //                 ),
                                          //               ),
                                          //               const SizedBox(
                                          //                   height: 20),
                                          //               Row(
                                          //                 mainAxisAlignment:
                                          //                     MainAxisAlignment
                                          //                         .spaceEvenly,
                                          //                 children: [
                                          //                   OutlinedButton(
                                          //                     style:
                                          //                         OutlinedButton
                                          //                             .styleFrom(
                                          //                       padding:
                                          //                           const EdgeInsets
                                          //                               .symmetric(
                                          //                         vertical: 8,
                                          //                         horizontal:
                                          //                             32,
                                          //                       ),
                                          //                       foregroundColor:
                                          //                           Colors
                                          //                               .black87,
                                          //                       shape:
                                          //                           RoundedRectangleBorder(
                                          //                         borderRadius:
                                          //                             BorderRadius
                                          //                                 .circular(
                                          //                                     5),
                                          //                       ),
                                          //                       side: const BorderSide(
                                          //                           color: Colors
                                          //                               .black87),
                                          //                     ),
                                          //                     child: Text(
                                          //                       Provider.of<LanguageProvider>(
                                          //                                   context)
                                          //                               .isTamil
                                          //                           ? "இல்லை"
                                          //                           : "No",
                                          //                       style: GoogleFonts.manrope(
                                          //                           color: Colors
                                          //                               .black87,
                                          //                           fontWeight:
                                          //                               FontWeight
                                          //                                   .w500,
                                          //                           fontSize:
                                          //                               Provider.of<LanguageProvider>(context).isTamil
                                          //                                   ? 12
                                          //                                   : 15),
                                          //                     ),
                                          //                     onPressed: () {
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
                                          //                           vertical: 8,
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
                                          //                               BorderRadius
                                          //                                   .all(
                                          //                             Radius
                                          //                                 .circular(
                                          //                                     5),
                                          //                           ),
                                          //                         ),
                                          //                       ),
                                          //                     ),
                                          //                     child: const Icon(
                                          //                         Icons.check,
                                          //                         color: Colors
                                          //                             .white),
                                          //                     onPressed: () {
                                          // auditsubmituser();
                                          // Navigator.of(
                                          //         context)
                                          //     .pop();
                                          // setState(() {
                                          //   _useractivityblock =
                                          //       true;
                                          // });
                                          //                     },
                                          //                   ),
                                          //                 ],
                                          //               ),
                                          //               const SizedBox(
                                          //                   height: 20),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: darkblue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
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
                                )
                              ],
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
