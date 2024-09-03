import 'dart:convert';
import 'package:auditfitnesstest/assets/colors.dart';
import 'package:auditfitnesstest/models/admin%20specific/admin_main_area_model.dart';
import 'package:auditfitnesstest/models/admin%20specific/admin_questions_model.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/admin/adminpage.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/bad_condition_user.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AddQuestionAndAreas extends StatefulWidget {
  const AddQuestionAndAreas({super.key});

  @override
  State<AddQuestionAndAreas> createState() => _AddQuestionAndAreasState();
}

class _AddQuestionAndAreasState extends State<AddQuestionAndAreas> {
  List<String> _mainAreaNames = [];
  List<String> _questions = [];
  List<String> _tamilQuestions = [];
  List<Map<String, String>> questionList = [];
  bool useractiondis = false;

  final box = GetStorage();
  final TextEditingController mainAreacontroller = TextEditingController();
  final TextEditingController specificareacontroller = TextEditingController();
  final TextEditingController tamilspecificareacontroller =
      TextEditingController();
  final TextEditingController questionscontroller = TextEditingController();
  final TextEditingController tamilquestionscontroller =
      TextEditingController();
  final SuggestionsController questionsSuggestioncontroller =
      SuggestionsController();

  final SuggestionsController tamilquestionsSuggestioncontroller =
      SuggestionsController();
  final FocusNode _questionsfocusNode = FocusNode();
  final FocusNode _tamilquestionsfocusNode = FocusNode();
  final FocusNode _questionsAheadfocusNode = FocusNode();
  final FocusNode _tamilquestionsAheadfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchMainAreaNames();
    _fetchQuestions();
    _fetchTamilQuestions();
  }

  Future<List<AdminQuestionsModel>> fetchTheQuestions() async {
    final response = await http.get(
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.questions));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData
          .map((item) => AdminQuestionsModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load daily tasks');
    }
  }

  Future<List<AdminMainAreaModel>> fetchMainAreas() async {
    final response = await http.get(
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.mainareas));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => AdminMainAreaModel.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load areas');
    }
  }

  Future<List<String>> fetchMainAreaNames() async {
    List<AdminMainAreaModel> mainAreas = await fetchMainAreas();
    return mainAreas
        .map((area) => area.mainArea)
        .where((area) => area != null)
        .cast<String>()
        .toList();
  }

  Future<List<String>> fetchQuestions() async {
    List<AdminQuestionsModel> questions = await fetchTheQuestions();
    return questions
        .map((question) => question.question)
        .where((question) => question != null)
        .cast<String>()
        .toList();
  }

  Future<List<String>> fetchTamilQuestions() async {
    List<AdminQuestionsModel> tamilQuestions = await fetchTheQuestions();
    return tamilQuestions
        .map((question) => question.questionTamil)
        .where((question) => question != null)
        .cast<String>()
        .toList();
  }

  Future<void> _fetchMainAreaNames() async {
    try {
      List<String> mainAreaNames = await fetchMainAreaNames();
      setState(() {
        _mainAreaNames = mainAreaNames;
      });
      // print(_mainAreaNames);
    } catch (e) {
      print('Failed to load main areas: $e');
    }
  }

  Future<void> _fetchQuestions() async {
    try {
      List<String> questions = await fetchQuestions();
      setState(() {
        _questions = questions;
      });
    } catch (e) {
      print('Failed to load questions: $e');
    }
  }

  Future<void> _fetchTamilQuestions() async {
    try {
      List<String> tamilQuestions = await fetchTamilQuestions();
      setState(() {
        _tamilQuestions = tamilQuestions;
      });
    } catch (e) {
      print('Failed to load Tamil questions: $e');
    }
  }

  void _addQuestion() {
    setState(() {
      questionList.add({
        "question": questionscontroller.text,
        "question_tamil": tamilquestionscontroller.text,
      });
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      questionList.removeAt(index);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageProvider = Provider.of<LanguageProvider>(context);
  }

  late LanguageProvider _languageProvider;

  Future<void> _submitData() async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndPoints.baseUrl +
            ApiEndPoints.authEndpoints.enterAreaQuestions),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "main_area": mainAreacontroller.text,
          "area_specific": specificareacontroller.text,
          "area_specific_tamil": tamilspecificareacontroller.text,
          "questions": questionList,
        }),
      );

      if (response.statusCode == 200) {
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
                      ? "கேள்வி சேர்க்கப்பட்டது"
                      : "Question added",
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

        Get.off(() => const AdminNavPage());
      }
      if (response.statusCode == 500) {
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
      } else {
        // Handle error response
        print('Failed to submit data');
      }
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            toolbarHeight:
                Provider.of<LanguageProvider>(context).isTamil ? 70 : 70,
            // backgroundColor: Colors.red,
            titleSpacing: 0,
            title: Text(
              overflow: TextOverflow.visible,
              Provider.of<LanguageProvider>(context).isTamil
                  ? "பகுதிகளைச் சேர்க்கவும்"
                  : "ADD AREAS",
              style: TextStyle(
                color: darkblue,
                fontWeight: FontWeight.bold,
                fontSize:
                    Provider.of<LanguageProvider>(context).isTamil ? 18 : 21,
              ),
            ),
          ),
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
                    // Provider.of<LanguageProvider>(context).isTamil
                    //     ? "கேள்விகள் மற்றும் \nபகுதிகளைச் சேர்க்கவும்"
                    //     : "ADD QUESTIONS AND AREAS",
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
                        height: MediaQuery.of(context).size.height - 150,
                        decoration: BoxDecoration(
                          color: lighterbackgroundblue,
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 15.0,
                              left: 15,
                              top: 10,
                              bottom: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       Provider.of<LanguageProvider>(context)
                                //               .isTamil
                                //           ? "முக்கிய பகுதி"
                                //           : "Main Area",
                                //       style: TextStyle(
                                //         fontSize: 23,
                                //         fontWeight: FontWeight.w700,
                                //       ),
                                //     ),
                                //     Text(
                                //       "*",
                                //       style: TextStyle(
                                //         fontSize: 23,
                                //         fontWeight: FontWeight.w700,
                                //         color: Colors.red,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text:
                                          Provider.of<LanguageProvider>(context)
                                                  .isTamil
                                              ? "முக்கிய பகுதி"
                                              : "Main Area",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                        color: greyblue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                        color: needred,
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(height: 10),
                                TypeAheadField(
                                  direction: VerticalDirection.down,
                                  decorationBuilder: (context, child) =>
                                      DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: lightbackgroundblue,
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
                                  constraints: BoxConstraints(maxHeight: 120),
                                  builder: (context, controller, focusNode) {
                                    return TextField(
                                      maxLines: null,
                                      textInputAction: TextInputAction.done,
                                      controller: controller,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                189, 189, 189, 1),
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                189, 189, 189, 1),
                                          ),
                                        ),
                                        border: InputBorder.none,
                                        hintText: Provider.of<LanguageProvider>(
                                                    context)
                                                .isTamil
                                            ? "முக்கிய பகுதி"
                                            : "Main Area",
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    );
                                  },
                                  suggestionsCallback: (value) {
                                    return _mainAreaNames.where((item) {
                                      return item.contains(value);
                                    }).toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  controller: mainAreacontroller,
                                  onSelected: (suggestion) {
                                    mainAreacontroller.text = suggestion;
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                // Row(
                                //   children: [
                                //     Text(
                                //       Provider.of<LanguageProvider>(context)
                                //               .isTamil
                                //           ? "பகுதி"
                                //           : "Specific Area",
                                //       style: TextStyle(
                                //         fontSize: 23,
                                //         fontWeight: FontWeight.w700,
                                //       ),
                                //     ),
                                //     Text(
                                //       "*",
                                //       style: TextStyle(
                                //         fontSize: 23,
                                //         fontWeight: FontWeight.w700,
                                //         color: Colors.red,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text:
                                          Provider.of<LanguageProvider>(context)
                                                  .isTamil
                                              ? "பகுதி"
                                              : "Specific Area",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                        color: greyblue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                        color: needred,
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(height: 10),
                                softtextfield(
                                  controller: specificareacontroller,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "பகுதி"
                                          : "Specific Area",
                                ),
                                const SizedBox(height: 16.0),
                                // Row(
                                //   children: [
                                //     Text(
                                //       Provider.of<LanguageProvider>(context)
                                //               .isTamil
                                //           ? "பகுதி தமிழில்"
                                //           : "Tamil Specific Area",
                                //       style: TextStyle(
                                //         fontSize: 23,
                                //         fontWeight: FontWeight.w700,
                                //       ),
                                //     ),
                                //     Text(
                                //       "*",
                                //       style: TextStyle(
                                //         fontSize: 23,
                                //         fontWeight: FontWeight.w700,
                                //         color: Colors.red,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text:
                                          Provider.of<LanguageProvider>(context)
                                                  .isTamil
                                              ? "பகுதி தமிழில்"
                                              : "Tamil Specific Area",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                        color: greyblue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                        color: needred,
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(height: 10),
                                softtextfield(
                                  controller: tamilspecificareacontroller,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "பகுதி தமிழில்"
                                          : "Tamil Specific Area",
                                ),
                                // const SizedBox(height: 16.0),
                                Column(
                                  children:
                                      questionList.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    Map<String, String> question = entry.value;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Divider(
                                        //   height: 30,
                                        //   thickness: 3,
                                        //   color: Colors.grey[400],
                                        // ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Text(
                                          Provider.of<LanguageProvider>(context)
                                                  .isTamil
                                              ? "கேள்வி ${index + 1}"
                                              : "Question ${index + 1}",
                                          style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          height: 55,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey[400]!,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Text(question["question"]!,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          height: 55,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey[400]!,
                                            ),
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Text(
                                                  question["question_tamil"]!,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    // fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: () => _removeQuestion(index),
                                          child: Container(
                                            height: 50,
                                            width: double.maxFinite,
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  229, 109, 91, 1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                Provider.of<LanguageProvider>(
                                                            context)
                                                        .isTamil
                                                    ? "அகற்று"
                                                    : "Remove",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // const SizedBox(
                                        //   height: 16,
                                        // ),
                                        // Divider(
                                        //   thickness: 3,
                                        //   color: Colors.grey[400],
                                        // ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       Provider.of<LanguageProvider>(context)
                                //               .isTamil
                                //           ? "கேள்விகள்"
                                //           : "Questions",
                                //       style: TextStyle(
                                //         fontSize: 23,
                                //         fontWeight: FontWeight.w700,
                                //       ),
                                //     ),
                                //     Text(
                                //       "*",
                                //       style: TextStyle(
                                //         fontSize: 23,
                                //         fontWeight: FontWeight.w700,
                                //         color: Colors.red,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text:
                                          Provider.of<LanguageProvider>(context)
                                                  .isTamil
                                              ? "கேள்விகள்"
                                              : "Questions",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                        color: greyblue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                        color: needred,
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(height: 10),
                                TypeAheadField(
                                  constraints: BoxConstraints(maxHeight: 120),
                                  suggestionsController:
                                      questionsSuggestioncontroller,
                                  focusNode: _questionsAheadfocusNode,
                                  direction: VerticalDirection.up,
                                  decorationBuilder: (context, child) =>
                                      DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: lightbackgroundblue,
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
                                  builder: (context, questionscontroller,
                                      _questionsfocusNode) {
                                    return TextField(
                                      maxLines: null,
                                      textInputAction: TextInputAction.done,
                                      controller: questionscontroller,
                                      focusNode: _questionsfocusNode,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                189, 189, 189, 1),
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                189, 189, 189, 1),
                                          ),
                                        ),
                                        border: InputBorder.none,
                                        hintText: Provider.of<LanguageProvider>(
                                                    context)
                                                .isTamil
                                            ? "கேள்விகள்"
                                            : "Questions",
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    );
                                  },
                                  suggestionsCallback: (value) {
                                    return _questions.where((item) {
                                      return item.contains(value);
                                    }).toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  controller: questionscontroller,
                                  onSelected: (suggestion) {
                                    questionscontroller.text = suggestion;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TypeAheadField(
                                  constraints: BoxConstraints(maxHeight: 120),
                                  suggestionsController:
                                      tamilquestionsSuggestioncontroller,
                                  focusNode: _tamilquestionsAheadfocusNode,
                                  direction: VerticalDirection.up,
                                  decorationBuilder: (context, child) =>
                                      DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: lightbackgroundblue,
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
                                  builder: (context, tamilquestionscontroller,
                                      _tamilquestionsfocusNode) {
                                    return TextField(
                                      textInputAction: TextInputAction.done,
                                      maxLines: null,
                                      controller: tamilquestionscontroller,
                                      focusNode: _tamilquestionsfocusNode,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                189, 189, 189, 1),
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                189, 189, 189, 1),
                                          ),
                                        ),
                                        border: InputBorder.none,
                                        hintText: Provider.of<LanguageProvider>(
                                                    context)
                                                .isTamil
                                            ? "தமிழில் கேள்விகள்"
                                            : "Questions in Tamil",
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    );
                                  },
                                  suggestionsCallback: (value) {
                                    return _tamilQuestions.where((item) {
                                      return item.contains(value);
                                    }).toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  controller: tamilquestionscontroller,
                                  onSelected: (suggestion) {
                                    tamilquestionscontroller.text = suggestion;
                                  },
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    if (tamilquestionscontroller
                                            .text.isNotEmpty ||
                                        questionscontroller.text.isNotEmpty) {
                                      _addQuestion();
                                      questionscontroller.clear();
                                      _questionsfocusNode.unfocus();
                                      tamilquestionscontroller.clear();
                                      _tamilquestionsfocusNode.unfocus();

                                      questionsSuggestioncontroller.close();
                                      tamilquestionsSuggestioncontroller
                                          .close();

                                      _questionsAheadfocusNode.unfocus();
                                      _tamilquestionsAheadfocusNode.unfocus();
                                    } else {
                                      setState(() {
                                        DelightToastBar(
                                          position: DelightSnackbarPosition.top,
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
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: lightblue,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        Provider.of<LanguageProvider>(context)
                                                .isTamil
                                            ? "கேள்விகளைச் சேர்க்கவும்"
                                            : "Add Questions",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "செய்ய வேண்டியது *"
                                          : "To do *",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(Provider.of<LanguageProvider>(context)
                                            .isTamil
                                        ? "கேள்விகளைச் சமர்ப்பிக்கும் முன், கேள்விகளைச் சேர் பொத்தானைப் பயன்படுத்தி அவற்றைச் சேர்க்கவும்!"
                                        : 'Make sure to add the questions before submitting them!'),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (mainAreacontroller.text.isEmpty ||
                                        specificareacontroller.text.isEmpty ||
                                        tamilspecificareacontroller
                                            .text.isEmpty ||
                                        questionList.isEmpty) {
                                      setState(() {
                                        DelightToastBar(
                                          position: DelightSnackbarPosition.top,
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
                                          return

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
                                              //       padding: const EdgeInsets.only(
                                              //         top: 3,
                                              //         left: 3,
                                              //         right: 3,
                                              //         bottom: 3,
                                              //       ),
                                              //       child: Container(
                                              //         width: 150,
                                              //         decoration:
                                              //             const BoxDecoration(
                                              //           color: Colors.white,
                                              //           borderRadius:
                                              //               BorderRadius.only(
                                              //             bottomLeft:
                                              //                 Radius.circular(37),
                                              //             bottomRight:
                                              //                 Radius.circular(37),
                                              //             topLeft:
                                              //                 Radius.circular(37),
                                              //             topRight:
                                              //                 Radius.circular(37),
                                              //           ),
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
                                              //                 height: 20,
                                              //               ),
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
                                              //                       side:
                                              //                           const BorderSide(
                                              //                         color: Colors
                                              //                             .black87,
                                              //                       ),
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
                                              //                       Icons.check,
                                              //                       color: Colors
                                              //                           .white,
                                              //                     ),
                                              //                     onPressed: () {
                                              //                       _submitData();
                                              //                       Navigator.of(
                                              //                               context)
                                              //                           .pop();
                                              //                       setState(() {
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
                                                                    .withOpacity(
                                                                        0.5),
                                                                thickness: 1,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  _submitData();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  setState(() {
                                                                    useractiondis =
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
                                SizedBox(
                                  height: 10,
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
