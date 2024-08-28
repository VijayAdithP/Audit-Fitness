import 'dart:convert';
import 'package:auditfitnesstest/models/campus%20info/reportby_specific_area.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/campus/campuspage.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/user_container.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SpecificTaskSubmission extends StatefulWidget {
  final int weeknumber;
  final int year;
  final String month;
  final String specificArea;
  final String specificTaskId;

  const SpecificTaskSubmission({
    super.key,
    required this.weeknumber,
    required this.year,
    required this.month,
    required this.specificArea,
    required this.specificTaskId,
  });

  @override
  State<SpecificTaskSubmission> createState() => _SpecificTaskSubmissionState();
}

class _SpecificTaskSubmissionState extends State<SpecificTaskSubmission> {
  final box = GetStorage();
  String? selectedCondition;
  int _selectedIndex = 1;
  List<ReportbySpecificArea> report = [];
  bool _useractblock = false;

  @override
  void initState() {
    super.initState();
    fetchCampusdetaile();
  }

  Future<void> fetchCampusdetaile() async {
    try {
      // print(
      //   '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.reportspecificAreas}/${widget.specificArea}/${widget.weeknumber}/${widget.month}/${widget.year}',
      // );
      final response = await http.get(
        Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.reportspecificAreas}/${widget.specificArea}/${widget.weeknumber}/${widget.month}/${widget.year}',
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        if (mounted) {
          setState(() {
            report = jsonData
                .map((json) => ReportbySpecificArea.fromJson(json))
                .toList();
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> progressUpdate() async {
    bool? _istamil = box.read('isTamil');
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.campusStatusUpdate);

      var body = json.encode({
        "taskId": widget.specificTaskId,
        "newProgress": selectedStatus,
      });

      var response = await http.post(url, body: body, headers: headers);
      // setState(() {

      // });
      if (response.statusCode == 200) {
        // print(response.body);
        if (mounted) {
          setState(() {
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
                  _istamil!
                      ? "முன்னேற்றம் வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது"
                      : "Progress successfully submited",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ).show(context);
            _useractblock = true;
          });
        }
        Get.offAll(const CampusMainPage());
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
      } else {
        if (mounted) {
          setState(() {
            _useractblock = false;
          });
        }
        throw jsonDecode(response.body)["Message"] ?? "Invalid Login";
      }
    } catch (error) {
      print(error);
    }
  }

  final List<String> options = ["Completed", "In Progress"];

  final List<String> optionsTamil = ["நிறைவு", "செய்யவில்லை"];

  Widget imageDialog(path, context) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: path,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ),
          ),
          TextButton(
            // style: ButtonStyle(),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditData(BuildContext context, List<AuditData>? auditDataList) {
    if (auditDataList == null || auditDataList.isEmpty) {
      return const Text("No Audit Data Available");
    }
    List<AuditData> badRemarks =
        auditDataList.where((auditData) => auditData.remark == "bad").toList();

    if (badRemarks.isEmpty) {
      return const Text("No bad remarks found.");
    }
    return Column(
      children: badRemarks.map((auditData) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              thickness: 3,
              color: Colors.grey,
              height: 20,
            ),
            Text(
              Provider.of<LanguageProvider>(context).isTamil
                  ? "கேள்வி ${auditData.questionNumber}"
                  : 'Question ${auditData.questionNumber}',
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
                auditData.question!,
                style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              Provider.of<LanguageProvider>(context).isTamil
                  ? "கருத்துக்கள்"
                  : 'Remarks',
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
                auditData.remark!,
                style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              Provider.of<LanguageProvider>(context).isTamil
                  ? "கருத்து"
                  : 'Comment',
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
                auditData.comment!,
                style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              Provider.of<LanguageProvider>(context).isTamil ? "படம்" : 'Image',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (auditData.imagePath != null)
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => imageDialog(
                          '${ApiEndPoints.baseUrl}/${auditData.imagePath!.trim().replaceAll('\\', '/').replaceAll(' ', '%20')}',
                          context));
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      colorFilter: const ColorFilter.mode(
                        Colors.white12,
                        BlendMode.lighten,
                      ),
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        '${ApiEndPoints.baseUrl}/${auditData.imagePath!.replaceAll('\\', '/').replaceAll(' ', '%20')}',
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "பார்க்க"
                          : "Tap To View",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  String selectedStatus = 'In Progress';
  @override
  Widget build(BuildContext context) {
    // bool? _useractblock = box.read('isTamil');
    // double containerWidth = MediaQuery.of(context).size.width - 30;
    // double optionWidth = containerWidth / options.length;
    // double optionTamilWidth = containerWidth / optionsTamil.length;
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            _useractblock ? Color.fromRGBO(229, 229, 229, 1) : Colors.black,
        body: _useractblock
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "சேர்க்கப்படுகிறது"
                          : "Adding task Id",
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
                                    ? "முன்னேற்றத்தைச் சேர்"
                                    : "ADD PROGRESSION",
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 20,
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
                          color: Color.fromRGBO(229, 229, 228, 1),
                        ),
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: report.length,
                            itemBuilder: (context, index) {
                              final item = report[index];
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 15.0,
                                    left: 15,
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        Provider.of<LanguageProvider>(context)
                                                .isTamil
                                            ? "முக்கிய பகுதி"
                                            : 'Main Area',
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
                                          item.mainArea!,
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
                                            ? "குறிப்பிட்ட பகுதி"
                                            : 'Specific Area',
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
                                          item.specificArea!,
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
                                            ? "குறிப்பிட்ட பணி ஐடி"
                                            : 'Specific Task Id',
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
                                          item.taskId!,
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
                                            ? "பரிந்துரைகள்"
                                            : 'Suggestions',
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
                                          item.suggestions!,
                                          style: GoogleFonts.manrope(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      _buildAuditData(context, item.auditData),
                                      const Divider(
                                        thickness: 3,
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        Provider.of<LanguageProvider>(context)
                                                .isTamil
                                            ? "நிலை"
                                            : 'Status',
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // Container(
                                      //   height: 50,
                                      //   // width: containerWidth,
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.grey[400],
                                      //     borderRadius: BorderRadius.circular(10),
                                      //   ),
                                      //   child: Stack(
                                      //     children: [
                                      //       AnimatedPositioned(
                                      //         top: 0,
                                      //         left: Provider.of<LanguageProvider>(
                                      //                     context)
                                      //                 .isTamil
                                      //             ? _selectedIndex * optionTamilWidth
                                      //             : _selectedIndex * optionWidth,
                                      //         bottom: 0,
                                      //         duration:
                                      //             const Duration(milliseconds: 100),
                                      //         child: Container(
                                      //           width: Provider.of<LanguageProvider>(
                                      //                       context)
                                      //                   .isTamil
                                      //               ? optionTamilWidth
                                      //               : optionWidth,
                                      //           height: 40,
                                      //           decoration: BoxDecoration(
                                      //             color: Colors.orange[300],
                                      //             borderRadius:
                                      //                 BorderRadius.circular(10),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       Row(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.spaceAround,
                                      //         children: Provider.of<LanguageProvider>(
                                      //                     context)
                                      //                 .isTamil
                                      //             ? List.generate(
                                      //                 optionsTamil.length,
                                      //                 (index) {
                                      //                   return GestureDetector(
                                      //                     onTap: () {
                                      //                       setState(() {
                                      //                         _selectedIndex = index;
                                      //                       });
                                      //                     },
                                      //                     child: Container(
                                      //                       width: optionTamilWidth,
                                      //                       alignment:
                                      //                           Alignment.center,
                                      //                       padding: const EdgeInsets
                                      //                           .symmetric(
                                      //                           vertical: 8),
                                      //                       child: Text(
                                      //                         optionsTamil[index],
                                      //                         style: const TextStyle(
                                      //                           fontSize: 12,
                                      //                           color: Colors.black,
                                      //                           fontWeight:
                                      //                               FontWeight.bold,
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                   );
                                      //                 },
                                      //               )
                                      //             : List.generate(
                                      //                 options.length,
                                      //                 (index) {
                                      //                   return GestureDetector(
                                      //                     onTap: () {
                                      //                       setState(() {
                                      //                         _selectedIndex = index;
                                      //                         print(options[
                                      //                             _selectedIndex]);
                                      //                       });
                                      //                     },
                                      //                     child: Container(
                                      //                       width: optionWidth,
                                      //                       alignment:
                                      //                           Alignment.center,
                                      //                       padding: const EdgeInsets
                                      //                           .symmetric(
                                      //                           vertical: 8),
                                      //                       child: Text(
                                      //                         options[index],
                                      //                         style: const TextStyle(
                                      //                           fontSize: 17,
                                      //                           color: Colors.black,
                                      //                           fontWeight:
                                      //                               FontWeight.bold,
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                   );
                                      //                 },
                                      //               ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: RadioListTile<String>(
                                          activeColor: Colors.black,
                                          title: Text(
                                            Provider.of<LanguageProvider>(
                                                        context)
                                                    .isTamil
                                                ? "செயல்படுகிறது"
                                                : "In Progress",
                                          ),
                                          value: "In Progress",
                                          groupValue: selectedStatus,
                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedStatus = value!;
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: RadioListTile<String>(
                                          activeColor: Colors.black,
                                          title: Text(
                                            Provider.of<LanguageProvider>(
                                                        context)
                                                    .isTamil
                                                ? "முடிக்கப்பட்டது"
                                                : "Completed",
                                          ),
                                          value: "Completed",
                                          groupValue: selectedStatus,
                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedStatus = value!;
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                        ),
                                      ),

                                      const SizedBox(height: 16.0),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.0),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.0),
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
                                                              Radius.circular(
                                                                  37),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  37),
                                                          topLeft:
                                                              Radius.circular(
                                                                  37),
                                                          topRight:
                                                              Radius.circular(
                                                                  37),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    20.0),
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
                                                                color: Colors
                                                                    .black,
                                                                fontSize: Provider.of<LanguageProvider>(
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
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          32,
                                                                    ),
                                                                    foregroundColor:
                                                                        Colors
                                                                            .black87,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    side:
                                                                        const BorderSide(
                                                                      color: Colors
                                                                          .black87,
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    Provider.of<LanguageProvider>(context)
                                                                            .isTamil
                                                                        ? "இல்லை"
                                                                        : "No",
                                                                    style: GoogleFonts.manrope(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize: Provider.of<LanguageProvider>(context).isTamil
                                                                            ? 12
                                                                            : 15),
                                                                  ),
                                                                  onPressed:
                                                                      () {
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
                                                                        WidgetStatePropertyAll(
                                                                      Color.fromRGBO(
                                                                          130,
                                                                          204,
                                                                          146,
                                                                          1),
                                                                    ),
                                                                    shape:
                                                                        WidgetStatePropertyAll(
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(
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
                                                                  onPressed:
                                                                      () {
                                                                    // print(selectedStatus);
                                                                    progressUpdate();
                                                                    // Navigator.pop(
                                                                    //     context);
                                                                    // Navigator.pop(
                                                                    //     context);
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
                                              Provider.of<LanguageProvider>(
                                                          context)
                                                      .isTamil
                                                  ? 'முன்னேற்றத்தை சமர்ப்பிக்கவும்'
                                                  : "Submit Progress",
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
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// void loadDummyData() {
//   String jsonData = '''
// [
//   {
//     "main_area": "Main Auditorium Backside",
//     "specific_area": "Main Auditorium Backside - male",
//     "task_id": "Task1",
//     "audit_date": "2024-08-09T18:30:00.000Z",
//     "week_number": 30,
//     "month": "july",
//     "year": 2024,
//     "auditor_name": "John",
//     "auditor_phone": "1234567890",
//     "suggestions": "Suggestions",
//     "audit_data": [
//       {
//         "question_number": 1,
//         "question": "question",
//         "remark": "good",
//         "image_path": null,
//         "comment": ""
//       },
//       {
//         "question_number": 2,
//         "question": "question",
//         "remark": "good",
//         "image_path": null,
//         "comment": ""
//       },
//       {
//         "question_number": 3,
//         "question": "question",
//         "remark": "good",
//         "image_path": null,
//         "comment": ""
//       },
//       {
//         "question_number": 4,
//         "question": "question",
//         "remark": "bad",
//         "image_path": "https://picsum.photos/200/300",
//         "comment": "need change"
//       },
//       {
//         "question_number": 5,
//         "question": "question",
//         "remark": "good",
//         "image_path": null,
//         "comment": ""
//       },
//       {
//         "question_number": 6,
//         "question": "question",
//         "remark": "good",
//         "image_path": null,
//         "comment": ""
//       },
//       {
//         "question_number": 7,
//         "question": "question",
//         "remark": "good",
//         "image_path": null,
//         "comment": ""
//       }
//     ]
//   }
// ]
//   ''';

//   List<dynamic> parsedJson = jsonDecode(jsonData);
//   report = ReportbySpecificArea.fromJson(parsedJson[0]);

//   setState(() {});
// }

// class SpecificTaskSubmission extends StatefulWidget {
//   final String specificArea;
//   final String auditdata;

//   const SpecificTaskSubmission({
//     super.key,
//     required this.specificArea,
//     required this.auditdata,
//   });

//   @override
//   State<SpecificTaskSubmission> createState() => _SpecificTaskSubmissionState();
// }

// class _SpecificTaskSubmissionState extends State<SpecificTaskSubmission> {
//   int _selectedIndex = 1;
//   final List<String> options = ["COMPLETED", "IN PROGRESS"];
//   ReportbySpecificArea? report;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchReportbySpecificArea();
//   }

//   Future<void> fetchReportbySpecificArea() async {
//     final response = await http.get(Uri.parse(
//         '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.reportspecificAreas}/${widget.specificArea}/${widget.auditdata}'));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> jsonData = jsonDecode(response.body);
//       setState(() {
//         report = ReportbySpecificArea.fromJson(jsonData);
//         isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load report');
//     }
//   }

//   Widget imageDialog(String path, BuildContext context) {
//     return InteractiveViewer(
//       child: Stack(
//         children: [
//           Dialog(
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: Image.network(
//                 path,
//                 fit: BoxFit.fill,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 150,
//             right: 20,
//             child: GestureDetector(
//               onTap: () => Navigator.of(context).pop(),
//               child: const Icon(
//                 Icons.cancel_outlined,
//                 color: Colors.white,
//                 size: 40,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double containerWidth = MediaQuery.of(context).size.width - 32;
//     double optionWidth = containerWidth / options.length;

//     if (isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Loading...'),
//         ),
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     if (report == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Error'),
//         ),
//         body: Center(
//           child: Text('Failed to load data.'),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.only(
//               top: 50.0,
//               left: 15.0,
//               right: 15.0,
//               bottom: 20.0,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: const Icon(
//                           Icons.arrow_back,
//                           color: Colors.white,
//                           size: 30,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       Text(
//                         overflow: TextOverflow.visible,
//                         Provider.of<LanguageProvider>(context).isTamil
//                             ? "நிர்வாக டாஷ்போர்டு"
//                             : "ADD PROGRESSION",
//                         style: GoogleFonts.manrope(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(35.0),
//                 topRight: Radius.circular(35.0),
//               ),
//               child: Container(
//                 height: MediaQuery.of(context).size.height - 150,
//                 decoration: const BoxDecoration(
//                   color: Color.fromRGBO(229, 229, 229, 1),
//                 ),
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildLabel(context, 'Main Area'),
//                         _buildUserContainer(report!.mainArea),
//                         _buildLabel(context, 'Specific Area'),
//                         _buildUserContainer(report!.specificArea!),
//                         _buildLabel(context, 'Specific Task Id'),
//                         _buildUserContainer(report!.taskId),
//                         _buildLabel(context, 'Audit Date'),
//                         _buildUserContainer(report!.auditDate),
//                         _buildLabel(context, 'Auditor Name'),
//                         _buildUserContainer(report!.auditorName),
//                         _buildLabel(context, 'Auditor Phone'),
//                         _buildUserContainer(report!.auditorPhone),
//                         _buildLabel(context, 'Suggestions'),
//                         _buildUserContainer(report!.suggestions),
//                         _buildLabel(context, 'Audit Data'),
//                         _buildAuditData(context, report!.auditData),
//                         const SizedBox(height: 16.0),
//                         _buildLabel(context, 'Status'),
//                         _buildStatusOption(containerWidth, optionWidth),
//                         const SizedBox(height: 16.0),
//                         _buildSubmitButton(context),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLabel(BuildContext context, String label) {
//     return Column(
//       children: [
//         Text(
//           Provider.of<LanguageProvider>(context).isTamil
//               ? "வாராந்திர தணிக்கை ஐடி"
//               : label,
//           style: GoogleFonts.manrope(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   Widget _buildUserContainer(String? text) {
//     return UserContainer(
//       color: Colors.grey[400],
//       inside: Text(
//         text ?? "N/A",
//         style: GoogleFonts.manrope(
//           fontSize: 17,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _buildAuditData(BuildContext context, List<AuditData>? auditDataList) {
//     if (auditDataList == null || auditDataList.isEmpty) {
//       return const Text("No Audit Data Available");
//     }

//     return Column(
//       children: auditDataList.map((auditData) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildLabel(context, 'Question ${auditData.questionNumber}'),
//             _buildUserContainer(auditData.question),
//             _buildLabel(context, 'Remark'),
//             _buildUserContainer(auditData.remark),
//             _buildLabel(context, 'Comment'),
//             _buildUserContainer(auditData.comment),
//             _buildLabel(context, 'Image'),
//             GestureDetector(
//               onTap: () {
//                 showDialog(
//                     context: context,
//                     builder: (_) =>
//                         imageDialog(auditData.imagePath ?? "", context));
//               },
//               child: Container(
//                 height: 200,
//                 width: 200,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     width: 0.5,
//                     color: Colors.black,
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                   image: auditData.imagePath != null
//                       ? DecorationImage(
//                           fit: BoxFit.fill,
//                           image: NetworkImage(auditData.imagePath!),
//                         )
//                       : null,
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "Tap To Expand",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildStatusOption(double containerWidth, double optionWidth) {
//     return Container(
//       height: 50,
//       width: containerWidth,
//       decoration: BoxDecoration(
//         color: Colors.grey[400],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Stack(
//         children: [
//           AnimatedPositioned(
//             top: 0,
//             left: _selectedIndex * optionWidth,
//             bottom: 0,
//             duration: const Duration(milliseconds: 300),
//             child: Container(
//               width: optionWidth,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.orange[300],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: List.generate(options.length, (index) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _selectedIndex = index;
//                   });
//                 },
//                 child: Container(
//                   width: optionWidth,
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: Text(
//                     options[index],
//                     style: const TextStyle(
//                       fontSize: 17,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSubmitButton(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               backgroundColor: Colors.grey[400],
//               insetPadding: const EdgeInsets.all(10),
//               title: Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   "Are you sure?",
//                   style: GoogleFonts.manrope(
//                     color: Colors.black,
//                     fontSize: 23,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               actions: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 8,
//                           horizontal: 32,
//                         ),
//                         foregroundColor: Colors.black87,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         side: const BorderSide(
//                           color: Colors.black87,
//                         ),
//                       ),
//                       child: Text(
//                         "No",
//                         style: GoogleFonts.manrope(
//                           color: Colors.black87,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     ElevatedButton(
//                       style: const ButtonStyle(
//                         padding: WidgetStatePropertyAll(
//                           EdgeInsets.symmetric(vertical: 8, horizontal: 32),
//                         ),
//                         backgroundColor:
//                             WidgetStatePropertyAll(Colors.deepPurple),
//                         shape: WidgetStatePropertyAll(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(5)),
//                           ),
//                         ),
//                       ),
//                       child: const Icon(
//                         Icons.check,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         // Submit action here
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         );
//       },
//       child: Container(
//         height: 50,
//         width: double.maxFinite,
//         decoration: const BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//         ),
//         child: Center(
//           child: Text(
//             "Submit Progress",
//             style: GoogleFonts.manrope(
//               color: Colors.white,
//               fontSize: 17,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SpecificTaskSubmission extends StatefulWidget {
//   final String specificArea;
//   final String auditdate;

//   const SpecificTaskSubmission({
//     Key? key,
//     required this.specificArea,
//     required this.auditdate,
//   }) : super(key: key);

//   @override
//   State<SpecificTaskSubmission> createState() => _SpecificTaskSubmissionState();
// }

// class _SpecificTaskSubmissionState extends State<SpecificTaskSubmission> {
//   late ReportbySpecificArea report;

//   @override
//   void initState() {
//     super.initState();
//     loadDummyData();
//   }

//   void loadDummyData() {
//     // Dummy data as provided
//     String jsonData = '''
//     [
//       {
//         "main_area": "Main Auditorium Backside",
//         "specific_area": "Main Auditorium Backside - male",
//         "task_id": "Task1",
//         "audit_date": "2024-08-09T18:30:00.000Z",
//         "week_number": 30,
//         "month": "july",
//         "year": 2024,
//         "auditor_name": "John",
//         "auditor_phone": "1234567890",
//         "suggestions": "Suggestions",
//         "audit_data": [
//           {
//             "question_number": 1,
//             "question": "question",
//             "remark": "good",
//             "image_path": null,
//             "comment": ""
//           },
//           {
//             "question_number": 2,
//             "question": "question",
//             "remark": "good",
//             "image_path": null,
//             "comment": ""
//           },
//           {
//             "question_number": 3,
//             "question": "question",
//             "remark": "good",
//             "image_path": null,
//             "comment": ""
//           },
//           {
//             "question_number": 4,
//             "question": "question",
//             "remark": "bad",
//             "image_path": "uploads/images/respirator-protection-fnl.webp",
//             "comment": "need change"
//           },
//           {
//             "question_number": 5,
//             "question": "question",
//             "remark": "good",
//             "image_path": null,
//             "comment": ""
//           },
//           {
//             "question_number": 6,
//             "question": "question",
//             "remark": "good",
//             "image_path": null,
//             "comment": ""
//           },
//           {
//             "question_number": 7,
//             "question": "question",
//             "remark": "good",
//             "image_path": null,
//             "comment": ""
//           }
//         ]
//       }
//     ]
//     ''';

//     // Parsing the JSON data
//     List<dynamic> parsedJson = jsonDecode(jsonData);
//     report = ReportbySpecificArea.fromJson(parsedJson[0]);

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (report == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Loading...'),
//         ),
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task Submission'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Specific Task ID: ${report.taskId}'),
//               const SizedBox(height: 10),
//               Text('Main Area: ${report.mainArea ?? 'N/A'}'),
//               const SizedBox(height: 10),
//               Text('Specific Area: ${report.specificArea ?? 'N/A'}'),
//               const SizedBox(height: 10),
//               Text('Audit Date: ${report.auditDate ?? 'N/A'}'),
//               const SizedBox(height: 10),
//               Text('Auditor Name: ${report.auditorName ?? 'N/A'}'),
//               const SizedBox(height: 10),
//               Text('Auditor Phone: ${report.auditorPhone ?? 'N/A'}'),
//               const SizedBox(height: 10),
//               Text('Suggestions: ${report.suggestions ?? 'N/A'}'),
//               const SizedBox(height: 10),
//               _buildAuditData(context, report.auditData),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAuditData(BuildContext context, List<AuditData>? auditDataList) {
//     if (auditDataList == null || auditDataList.isEmpty) {
//       return const Text("No Audit Data Available");
//     }

//     return Column(
//       children: auditDataList.map((auditData) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Question ${auditData.questionNumber}: ${auditData.question}'),
//             const SizedBox(height: 5),
//             Text('Remark: ${auditData.remark}'),
//             const SizedBox(height: 5),
//             Text('Comment: ${auditData.comment}'),
//             const SizedBox(height: 10),
//             if (auditData.imagePath != null)
//               GestureDetector(
//                 onTap: () {
//                   showDialog(
//                       context: context,
//                       builder: (_) =>
//                           imageDialog(auditData.imagePath!, context));
//                 },
//                 child: Container(
//                   height: 200,
//                   width: 200,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       width: 0.5,
//                       color: Colors.black,
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                     image: DecorationImage(
//                       fit: BoxFit.fill,
//                       image: NetworkImage(
//                           'https://yourimageurl.com/${auditData.imagePath!}'),
//                     ),
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 20),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   Widget imageDialog(String path, BuildContext context) {
//     return Dialog(
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: Image.network(
//           'https://yourimageurl.com/$path',
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
