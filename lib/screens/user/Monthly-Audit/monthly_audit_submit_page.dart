import 'dart:convert';
import 'dart:io';
import 'package:auditfitnesstest/models/user%20data/all_areas.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/models/user%20data/usermodel.dart';
// import 'package:auditfitnesstest/screens/auth_screen.dart';
import 'package:auditfitnesstest/screens/user/userpage.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/bad_condition_user.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/dropdown_user.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/user_container.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class MonthlyUserAuditSubmmitPage extends StatefulWidget {
  const MonthlyUserAuditSubmmitPage({super.key});

  @override
  State<MonthlyUserAuditSubmmitPage> createState() =>
      MonthlyUserAuditSubmmitPageState();
}

class MonthlyUserAuditSubmmitPageState
    extends State<MonthlyUserAuditSubmmitPage> {
  final box = GetStorage();

  Future<List<AreasUser>> fetchDataFromApi() async {
    final response = await http.get(Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.remoteAreaWeekly));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => AreasUser.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<int?> fetchPhoneNumber() async {
    try {
      username = box.read('username');
      final response = await http.get(Uri.parse(
          "${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.userdata}/$username"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('phoneNumber') && data['phoneNumber'] is int) {
          setState(() {
            userPhonenumber = data['phoneNumber'];
          });
          return userPhonenumber;
        } else {
          throw Exception('Invalid phoneNumber data');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Invalid phoneNumber data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLastAuditDate();
    fetchPhoneNumber();
    futureData = fetchDataFromApi();
    languageChange();
  }

  Future<void> fetchLastAuditDate() async {
    try {
      final response = await http.get(Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.lastauditdata));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('date')) {
          final String dateString = data['date'];

          final DateTime dateTime = DateTime.parse(dateString);
          final String formattedDate =
              DateFormat('yyyy-MM-dd').format(dateTime);

          setState(() {
            lastAuditDate = formattedDate;
          });
        }
      }
    } catch (error) {
      print('Error fetching last audit date: $error');
    }
  }

  Future<void> auditsubmituser() async {
    username = box.read('username');

    if (selectedValue == null ||
        dustfreecondition == null ||
        furniturecondition == null ||
        doorscondition == null ||
        civilcondition == null ||
        carpentrycondition == null ||
        electricalcondition == null ||
        plumbingcondition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all remarks.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      var uri = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndpoints.submitUserDailyAudit);

      var request = http.MultipartRequest('POST', uri);

      request.fields['area_name'] = selectedValue!;
      request.fields['audit_date'] = lastAuditDate;
      request.fields['auditor_name'] = username;
      request.fields['auditor_phone'] = userPhonenumber.toString();
      request.fields['suggestion'] = '';

      var questions = [
        {
          'question': 'Are the rooms/restrooms clean and free from dust?',
          'remark': dustfreecondition,
          'comment': dustfreecontroller.text,
        },
        {
          'question': 'Any damages observed in the furniture?',
          'remark': furniturecondition,
          'comment': furniturecontroller.text,
        },
        {
          'question': 'Are the doors and handles in good condition?',
          'remark': doorscondition,
          'comment': doorscontroller.text,
        },
        {
          'question': 'Civil complaints?',
          'remark': civilcondition,
          'comment': civilcontroller.text,
        },
        {
          'question': 'Carpentry complaints?',
          'remark': carpentrycondition,
          'comment': carpentrycontroller.text,
        },
        {
          'question': 'Electrical complaints?',
          'remark': electricalcondition,
          'comment': electricalcontroller.text,
        },
        {
          'question': 'Plumbing complaints?',
          'remark': plumbingcondition,
          'comment': plumbingcontroller.text,
        },
      ];

      request.fields['questions'] = jsonEncode(questions);

      List<File?> images = [
        dustfree,
        furniture,
        doors,
        civil,
        carpentry,
        electrical,
        plumbing
      ];

      for (var i = 0; i < images.length; i++) {
        if (images[i] != null) {
          var imageFile = images[i]!;
          var stream = http.ByteStream(imageFile.openRead());
          var length = await imageFile.length();
          var multipartFile = http.MultipartFile(
            'image${i + 1}',
            stream,
            length,
            filename: path.basename(imageFile.path),
          );
          request.files.add(multipartFile);
        } else {}
      }

      var response = await request.send();

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
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

  checkcondition() {
    if (selectedValue != null &&
        dustfreecondition != null &&
        furniturecondition != null &&
        doorscondition != null &&
        civilcondition != null &&
        carpentrycondition != null &&
        electricalcondition != null &&
        plumbingcondition != null) {
      setState(() {
        allRemarksFilled = true;
      });
    } else {
      setState(() {
        allRemarksFilled = false;
      });
    }
  }

  languageChange() async {
    bool language = true;

    box.write('language', language);
  }

  getlanguageChange() async {
    setState(() {
      language = box.read('language');
    });
  }

  @override
  void dispose() {
    dustfreecontroller.dispose();
    furniturecontroller.dispose();
    doorscontroller.dispose();
    civilcontroller.dispose();
    carpentrycontroller.dispose();
    plumbingcontroller.dispose();
    suggestioncontroller.dispose();
    super.dispose();
  }

  late Future<List<AreasUser>> futureData;

  String? selectedValue;
  String? dustfreecondition;
  String? furniturecondition;
  String? doorscondition;
  String? civilcondition;
  String? carpentrycondition;
  String? electricalcondition;
  String? plumbingcondition;

  final TextEditingController dustfreecontroller = TextEditingController();
  final TextEditingController furniturecontroller = TextEditingController();
  final TextEditingController doorscontroller = TextEditingController();
  final TextEditingController civilcontroller = TextEditingController();
  final TextEditingController carpentrycontroller = TextEditingController();
  final TextEditingController plumbingcontroller = TextEditingController();
  final TextEditingController electricalcontroller = TextEditingController();
  final TextEditingController suggestioncontroller = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  late Future<UserModel> futureUser;

  String username = '';
  String lastAuditDate = '';
  int? userPhonenumber;

  File? dustfree;
  File? furniture;
  File? doors;
  File? civil;
  File? carpentry;
  File? plumbing;
  File? electrical;

  bool allRemarksFilled = false;
  bool language = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        toolbarHeight: 100,
        backgroundColor: Colors.purple[900],
        title: Text(
          overflow: TextOverflow.visible,
          Provider.of<LanguageProvider>(context).isTamil
              ? "தொலைதூரப் பகுதி -\n வாராந்திர தணிக்கைத் திட்டம்"
              : "Daily Audits",
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () async {
          List<AreasUser> users = await fetchDataFromApi();
          for (var user in users) {
            print(user.areaSpecific);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                UserContainer(
                  inside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<LanguageProvider>(context).isTamil
                            ? "ஆடிட்டர்"
                            : "Auditor",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        username,
                        style: GoogleFonts.manrope(fontSize: 25),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserContainer(
                  inside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<LanguageProvider>(context).isTamil
                            ? "தேதி"
                            : "Date",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        lastAuditDate,
                        style: GoogleFonts.manrope(fontSize: 25),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserContainer(
                  inside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<LanguageProvider>(context).isTamil
                            ? "தொலைபேசி எண்"
                            : "Phone Number",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        userPhonenumber.toString(),
                        style: GoogleFonts.manrope(fontSize: 25),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserContainer(
                  inside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          Provider.of<LanguageProvider>(context).isTamil
                              ? "பகுதி பெயர்"
                              : "Area Name",
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureBuilder<List<AreasUser>>(
                        future: futureData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No data available'));
                          } else {
                            List<DropdownMenuItem<String>> dropdownItems =
                                snapshot.data!
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value: item.areaSpecific,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey[400]!),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  Provider.of<LanguageProvider>(
                                                              context)
                                                          .isTamil
                                                      ? item.areaSpecificTamil!
                                                      : item.areaSpecific!,
                                                  style: GoogleFonts.manrope(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList();
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: DropdownButton<String>(
                                itemHeight: 80,
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    Provider.of<LanguageProvider>(context)
                                            .isTamil
                                        ? "ஒரு பகுதியை உள்ளிடவும்"
                                        : "Enter an area",
                                    style: GoogleFonts.manrope(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                menuMaxHeight: 500,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                dropdownColor: Colors.grey[200],
                                style: GoogleFonts.manrope(
                                  fontSize: 17,
                                  color: Colors.grey[400],
                                ),
                                isDense: false,
                                isExpanded: true,
                                value: selectedValue,
                                elevation: 1,
                                underline: const SizedBox(),
                                onChanged: (String? newValue) {
                                  checkcondition();
                                  setState(() {
                                    selectedValue = newValue;
                                  });
                                },
                                items: dropdownItems,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserContainer(
                  inside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<LanguageProvider>(context).isTamil
                            ? "அறைகள்/கழிவறைகள் சுத்தமாகவும், தூசி படியாததாகவும் உள்ளதா?"
                            : "Are the rooms/restrooms are clean \nand free form dust?",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownUser(
                        onChanged: (String? value) {
                          setState(() {
                            dustfreecondition = value;
                          });
                          checkcondition();
                        },
                      ),
                      if (dustfreecondition == 'bad')
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Badconditionields(
                                controller: dustfreecontroller,
                                hintText: Provider.of<LanguageProvider>(context)
                                        .isTamil
                                    ? "நிபந்தனையைக் குறிப்பிடவும்"
                                    : "Specify the condition",
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final pickedFile =
                                            await _picker.pickImage(
                                                source: ImageSource.camera);
                                        if (pickedFile != null) {
                                          setState(() {
                                            dustfree = File(pickedFile.path);
                                          });
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    dustfree == null
                                        ? Text(
                                            Provider.of<LanguageProvider>(
                                                        context)
                                                    .isTamil
                                                ? "<-- படத்தைச் சேர்க்கவும்"
                                                : "<-- Add image",
                                            style: GoogleFonts.manrope(
                                              fontSize: 16,
                                            ),
                                          )
                                        : Stack(
                                            children: [
                                              Positioned(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 130,
                                                    width: 130,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(15),
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.blueGrey,
                                                        width: 5,
                                                      ),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: FileImage(
                                                            dustfree!),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 105,
                                                left: 105,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        dustfree = null;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserContainer(
                  inside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<LanguageProvider>(context).isTamil
                            ? "மரச்சாமான்களில் ஏதேனும் சேதம் பார்வையாளர் உள்ளதா?"
                            : "Any damages observer in the furniture?",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownUser(
                        onChanged: (String? value) {
                          setState(() {
                            furniturecondition = value;
                          });
                          checkcondition();
                        },
                      ),
                      if (furniturecondition == 'bad')
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Badconditionields(
                                controller: furniturecontroller,
                                hintText: Provider.of<LanguageProvider>(context)
                                        .isTamil
                                    ? "நிபந்தனையைக் குறிப்பிடவும்"
                                    : "Specify the condition",
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final pickedFile =
                                            await _picker.pickImage(
                                                source: ImageSource.camera);

                                        if (pickedFile != null) {
                                          setState(() {
                                            furniture = File(pickedFile.path);
                                          });
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    furniture == null
                                        ? Text(Provider.of<LanguageProvider>(
                                                    context)
                                                .isTamil
                                            ? "<-- படத்தைச் சேர்க்கவும்"
                                            : "<-- Add image")
                                        : Stack(
                                            children: [
                                              Positioned(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 130,
                                                    width: 130,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(15),
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.blueGrey,
                                                        width: 5,
                                                      ),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: FileImage(
                                                            furniture!),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 105,
                                                left: 105,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        furniture = null;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserContainer(
                  inside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<LanguageProvider>(context).isTamil
                            ? "கதவுகள் மற்றும் கைப்பிடிகள் நல்ல நிலையில் உள்ளதா?"
                            : "Are the doors and handles are in\ngood conditions?",
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownUser(
                        onChanged: (String? value) {
                          setState(() {
                            doorscondition = value;
                          });
                          checkcondition();
                        },
                      ),
                      if (doorscondition == 'bad')
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Badconditionields(
                                controller: doorscontroller,
                                hintText: Provider.of<LanguageProvider>(context)
                                        .isTamil
                                    ? "நிபந்தனையைக் குறிப்பிடவும்"
                                    : "Specify the condition",
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final pickedFile =
                                            await _picker.pickImage(
                                                source: ImageSource.camera);

                                        if (pickedFile != null) {
                                          setState(() {
                                            doors = File(pickedFile.path);
                                          });
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    doors == null
                                        ? Text(Provider.of<LanguageProvider>(
                                                    context)
                                                .isTamil
                                            ? "<-- படத்தைச் சேர்க்கவும்"
                                            : "<-- Add image")
                                        : Stack(
                                            children: [
                                              Positioned(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 130,
                                                    width: 130,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(15),
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.blueGrey,
                                                        width: 5,
                                                      ),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image:
                                                            FileImage(doors!),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 105,
                                                left: 105,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        doors = null;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserContainer(
                  inside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<LanguageProvider>(context).isTamil
                            ? "சிவில் புகார்கள்?"
                            : "Any problem in civil?",
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownUser(
                        onChanged: (String? value) {
                          setState(() {
                            civilcondition = value;
                          });
                          checkcondition();
                        },
                      ),
                      if (civilcondition == 'bad')
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Badconditionields(
                                controller: civilcontroller,
                                hintText: Provider.of<LanguageProvider>(context)
                                        .isTamil
                                    ? "நிபந்தனையைக் குறிப்பிடவும்"
                                    : "Specify the condition",
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final pickedFile =
                                            await _picker.pickImage(
                                                source: ImageSource.camera);

                                        if (pickedFile != null) {
                                          setState(() {
                                            civil = File(pickedFile.path);
                                          });
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    civil == null
                                        ? Text(Provider.of<LanguageProvider>(
                                                    context)
                                                .isTamil
                                            ? "<-- படத்தைச் சேர்க்கவும்"
                                            : "<-- Add image")
                                        : Stack(
                                            children: [
                                              Positioned(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 130,
                                                    width: 130,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(15),
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.blueGrey,
                                                        width: 5,
                                                      ),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image:
                                                            FileImage(civil!),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 105,
                                                left: 105,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        civil = null;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserContainer(
                  inside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<LanguageProvider>(context).isTamil
                            ? "தச்சு வேலை புகார்கள்?"
                            : "Any problem in carpentry?",
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownUser(
                        onChanged: (String? value) {
                          setState(() {
                            carpentrycondition = value;
                          });
                          checkcondition();
                        },
                      ),
                      if (carpentrycondition == 'bad')
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Badconditionields(
                                controller: carpentrycontroller,
                                hintText: Provider.of<LanguageProvider>(context)
                                        .isTamil
                                    ? "நிபந்தனையைக் குறிப்பிடவும்"
                                    : "Specify the condition",
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final pickedFile =
                                            await _picker.pickImage(
                                                source: ImageSource.camera);

                                        if (pickedFile != null) {
                                          setState(() {
                                            carpentry = File(pickedFile.path);
                                          });
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    carpentry == null
                                        ? Text(Provider.of<LanguageProvider>(
                                                    context)
                                                .isTamil
                                            ? "<-- படத்தைச் சேர்க்கவும்"
                                            : "<-- Add image")
                                        : Stack(
                                            children: [
                                              Positioned(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 130,
                                                    width: 130,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(15),
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.blueGrey,
                                                        width: 5,
                                                      ),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: FileImage(
                                                            carpentry!),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 105,
                                                left: 105,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        carpentry = null;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserContainer(
                  inside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<LanguageProvider>(context).isTamil
                            ? "மின்சார புகார்கள்?"
                            : "Any problem in electrical?",
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownUser(
                        onChanged: (String? value) {
                          setState(() {
                            electricalcondition = value;
                          });
                          checkcondition();
                        },
                      ),
                      if (electricalcondition == 'bad')
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Badconditionields(
                                controller: electricalcontroller,
                                hintText: Provider.of<LanguageProvider>(context)
                                        .isTamil
                                    ? "நிபந்தனையைக் குறிப்பிடவும்"
                                    : "Specify the condition",
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final pickedFile =
                                            await _picker.pickImage(
                                                source: ImageSource.camera);

                                        if (pickedFile != null) {
                                          setState(() {
                                            electrical = File(pickedFile.path);
                                          });
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    electrical == null
                                        ? Text(Provider.of<LanguageProvider>(
                                                    context)
                                                .isTamil
                                            ? "<-- படத்தைச் சேர்க்கவும்"
                                            : "<-- Add image")
                                        : Stack(
                                            children: [
                                              Positioned(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 130,
                                                    width: 130,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(15),
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.blueGrey,
                                                        width: 5,
                                                      ),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: FileImage(
                                                            electrical!),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 105,
                                                left: 105,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        electrical = null;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserContainer(
                  inside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<LanguageProvider>(context).isTamil
                            ? "பிளம்பிங் புகார்கள்?"
                            : "Any plumbing complaints?",
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownUser(
                        onChanged: (String? value) {
                          setState(() {
                            plumbingcondition = value;
                          });
                          checkcondition();
                        },
                      ),
                      if (plumbingcondition == 'bad')
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Badconditionields(
                                controller: plumbingcontroller,
                                hintText: Provider.of<LanguageProvider>(context)
                                        .isTamil
                                    ? "நிபந்தனையைக் குறிப்பிடவும்"
                                    : "Specify the condition",
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final pickedFile =
                                            await _picker.pickImage(
                                                source: ImageSource.camera);

                                        if (pickedFile != null) {
                                          setState(() {
                                            plumbing = File(pickedFile.path);
                                          });
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    plumbing == null
                                        ? Text(Provider.of<LanguageProvider>(
                                                    context)
                                                .isTamil
                                            ? "<-- படத்தைச் சேர்க்கவும்"
                                            : "<-- Add image")
                                        : Stack(
                                            children: [
                                              Positioned(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 130,
                                                    width: 130,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(15),
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.blueGrey,
                                                        width: 5,
                                                      ),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: FileImage(
                                                            plumbing!),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 105,
                                                left: 105,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        plumbing = null;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                UserContainer(
                  inside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<LanguageProvider>(context).isTamil
                            ? "ஏதேனும் ஆலோசனைகள்?"
                            : "Any Suggestions?",
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Badconditionields(
                        controller: suggestioncontroller,
                        hintText: Provider.of<LanguageProvider>(context).isTamil
                            ? "ஆலோசனைகள்"
                            : "Suggestions",
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    if (dustfreecondition == null ||
                        furniturecondition == null ||
                        doorscondition == null ||
                        civilcondition == null ||
                        carpentrycondition == null ||
                        electricalcondition == null ||
                        plumbingcondition == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all remarks.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[400],
                          insetPadding: const EdgeInsets.all(10),
                          title: Align(
                            alignment: Alignment.center,
                            child: Text(
                              Provider.of<LanguageProvider>(context).isTamil
                                  ? "நீங்கள் நிச்சயமாக சமர்ப்பிக்கிறீர்களா?"
                                  : "Are you sure?",
                              style: GoogleFonts.manrope(
                                color: Colors.black,
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 32,
                                    ),
                                    foregroundColor: Colors.black87,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    side: const BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  child: Text(
                                    Provider.of<LanguageProvider>(context)
                                            .isTamil
                                        ? "இல்லை"
                                        : "No",
                                    style: GoogleFonts.manrope(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                  style: const ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 32,
                                      ),
                                    ),
                                    backgroundColor: WidgetStatePropertyAll(
                                      Colors.deepPurple,
                                    ),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
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
                                    auditsubmituser();
                                    setState(() {});
                                    Get.off(() => const UserHomePage());
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 50,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: allRemarksFilled
                          ? Colors.deepPurple
                          : Colors.grey[500],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        Provider.of<LanguageProvider>(context).isTamil
                            ? "தணிக்கையை சமர்ப்பிக்கவும்"
                            : "Submit Audit",
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
