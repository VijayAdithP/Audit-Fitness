import 'dart:convert';
import 'package:auditfitnesstest/models/admin%20specific/admin_main_area_model.dart';
import 'package:auditfitnesstest/models/admin%20specific/admin_questions_model.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/admin/adminpage.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/bad_condition_user.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
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

  final box = GetStorage();
  final TextEditingController mainAreacontroller = TextEditingController();
  final TextEditingController specificareacontroller = TextEditingController();
  final TextEditingController tamilspecificareacontroller =
      TextEditingController();
  final TextEditingController questionscontroller = TextEditingController();
  final TextEditingController tamilquestionscontroller =
      TextEditingController();

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
      questionscontroller.clear();
      tamilquestionscontroller.clear();
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      questionList.removeAt(index);
    });
  }

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
        // Handle successful response
        // print(response.body);
        Get.off(() => const AdminNavPage());
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        body: Column(
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
                              ? "கேள்விகள் மற்றும் \nபகுதிகளைச் சேர்க்கவும்"
                              : "ADD QUESTIONS AND AREAS",
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontSize:
                                Provider.of<LanguageProvider>(context).isTamil
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
                  height: MediaQuery.of(context).size.height - 150,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(229, 229, 229, 1),
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
                          Text(
                            Provider.of<LanguageProvider>(context).isTamil
                                ? "முக்கிய பகுதி"
                                : "Main Area",
                            style: GoogleFonts.manrope(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TypeAheadField(
                            direction: VerticalDirection.down,
                            builder: (context, controller, focusNode) {
                              return TextField(
                                textInputAction: TextInputAction.done,
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  border: InputBorder.none,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "முக்கிய பகுதி"
                                          : "Main Area",
                                  hintStyle: GoogleFonts.manrope(
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
                          Text(
                            Provider.of<LanguageProvider>(context).isTamil
                                ? "குறிப்பிட்ட பகுதி"
                                : "Specific Area",
                            style: GoogleFonts.manrope(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Badconditionields(
                            controller: specificareacontroller,
                            hintText:
                                Provider.of<LanguageProvider>(context).isTamil
                                    ? "குறிப்பிட்ட பகுதி"
                                    : "Specific Area",
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            Provider.of<LanguageProvider>(context).isTamil
                                ? "தமிழ் குறிப்பிட்ட பகுதி"
                                : "Tamil Specific Area",
                            style: GoogleFonts.manrope(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Badconditionields(
                            controller: tamilspecificareacontroller,
                            hintText:
                                Provider.of<LanguageProvider>(context).isTamil
                                    ? "தமிழ் குறிப்பிட்ட பகுதி"
                                    : "Tamil Specific Area",
                          ),
                          const SizedBox(height: 16.0),
                          Column(
                            children: questionList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, String> question = entry.value;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Provider.of<LanguageProvider>(context)
                                            .isTamil
                                        ? "கேள்வி ${index + 1}"
                                        : "Question ${index + 1}",
                                    style: GoogleFonts.manrope(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(question["question"]!,
                                          style: GoogleFonts.manrope(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(question["question_tamil"]!,
                                          style: GoogleFonts.manrope(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () => _removeQuestion(index),
                                    child: Container(
                                      height: 50,
                                      width: double.maxFinite,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(229, 109, 91, 1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          Provider.of<LanguageProvider>(context)
                                                  .isTamil
                                              ? "அகற்று"
                                              : "Remove",
                                          style: GoogleFonts.manrope(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  )
                                ],
                              );
                            }).toList(),
                          ),
                          Text(
                            Provider.of<LanguageProvider>(context).isTamil
                                ? "கேள்விகள்"
                                : "Questions",
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
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
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  border: InputBorder.none,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "கேள்விகள்"
                                          : "Questions",
                                  hintStyle: GoogleFonts.manrope(
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
                            direction: VerticalDirection.up,
                            builder: (context, controller, focusNode) {
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  border: InputBorder.none,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "தமிழில் கேள்விகள்"
                                          : "Questions in Tamil",
                                  hintStyle: GoogleFonts.manrope(
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
                            onTap: _addQuestion,
                            child: Container(
                              height: 50,
                              width: double.maxFinite,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(229, 184, 91, 1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "கேள்விகளைச் சேர்க்கவும்"
                                      : "Add Questions",
                                  style: GoogleFonts.manrope(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (mainAreacontroller.text.isEmpty ||
                                  specificareacontroller.text.isEmpty ||
                                  tamilspecificareacontroller.text.isEmpty ||
                                  questionList.isEmpty) {
                                setState(() {
                                  DelightToastBar(
                                    position: DelightSnackbarPosition.top,
                                    autoDismiss: true,
                                    snackbarDuration: Durations.extralong4,
                                    builder: (context) => ToastCard(
                                      color: Colors.red,
                                      leading: const Icon(
                                        Icons.notification_important_outlined,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        Provider.of<LanguageProvider>(context)
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
                                          padding: const EdgeInsets.only(
                                            top: 3,
                                            left: 3,
                                            right: 3,
                                            bottom: 3,
                                          ),
                                          child: Container(
                                            width: 150,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(37),
                                                bottomRight:
                                                    Radius.circular(37),
                                                topLeft: Radius.circular(37),
                                                topRight: Radius.circular(37),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                      fontSize:
                                                          Provider.of<LanguageProvider>(
                                                                      context)
                                                                  .isTamil
                                                              ? 19
                                                              : 23,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                            horizontal: 32,
                                                          ),
                                                          foregroundColor:
                                                              Colors.black87,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          side:
                                                              const BorderSide(
                                                            color:
                                                                Colors.black87,
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
                                                              fontSize: Provider.of<
                                                                              LanguageProvider>(
                                                                          context)
                                                                      .isTamil
                                                                  ? 12
                                                                  : 15),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
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
                                                              vertical: 8,
                                                              horizontal: 32,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              WidgetStatePropertyAll(
                                                            Color.fromRGBO(130,
                                                                204, 146, 1),
                                                          ),
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
                                                        child: const Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          _submitData();
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
                                  Provider.of<LanguageProvider>(context).isTamil
                                      ? "தணிக்கையை சமர்ப்பிக்கவும்"
                                      : "Submit Questions",
                                  style: GoogleFonts.manrope(
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
            ),
          ],
        ),
      ),
    );
  }
}
