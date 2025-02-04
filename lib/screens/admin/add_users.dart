import 'dart:convert';
import 'package:auditfitnesstest/assets/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/admin/viewing%20pages/view_all_users.dart';
import 'package:auditfitnesstest/screens/widgets/User-Widgets/bad_condition_user.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddUsers extends StatefulWidget {
  const AddUsers({
    super.key,
  });

  @override
  State<AddUsers> createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController firstnamecontroller = TextEditingController();
  final TextEditingController lastnamecontroller = TextEditingController();
  final TextEditingController phonenumbercontroller = TextEditingController();
  final TextEditingController staffidcontroller = TextEditingController();
  bool useractiondis = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageProvider = Provider.of<LanguageProvider>(context);
  }

  late LanguageProvider _languageProvider;
  Future<void> registerWithEmail() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.registerEmail);
      Map body = {
        'username': usernamecontroller.text,
        'password': passwordcontroller.text,
        "roleId": selectedRole,
        "firstName": firstnamecontroller.text.trim(),
        "lastName": lastnamecontroller.text.trim(),
        "phoneNumber": phonenumbercontroller.text,
        "staffId": staffidcontroller.text.trim()
      };

      var response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
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
                        ? "பயனர் வெற்றிகரமாக உருவாக்கப்பட்டது"
                        : "User successfully created",
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
        Get.off(const ViewAllUsers());
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Invalid Input";
      }
    } catch (e) {
      Get.back();
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Error!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(e.toString())],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    phonenumbercontroller.dispose();
    staffidcontroller.dispose();
    super.dispose();
  }

  // RegisterationController registercontroller =
  //     Get.put(RegisterationController());
  String dropdownValue = 'user';
  int selectedRole = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
                  ? "நிர்வாக டாஷ்போர்டு"
                  : "ADD USER",
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
              ? const Center(
                  child: SpinKitThreeBounce(
                    color: const Color.fromARGB(255, 130, 111, 238),
                    size: 40,
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
                    //     ? "நிர்வாக டாஷ்போர்டு"
                    //     : "ADD USER",
                    //               style: GoogleFonts.manrope(
                    //                 color: Colors.white,
                    //                 fontSize: 20,
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
                                // Provider.of<LanguageProvider>(context)
                                //         .isTamil
                                //     ? "முதல் பெயர்"
                                //     : 'First Name',
                                // style: TextStyle(
                                //   fontWeight: FontWeight.bold,
                                //   fontSize: 20,
                                //   color: greyblue,
                                // ),
                                //     ),
                                //     Text(
                                //       '*',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.red,
                                //         fontSize: 20,
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
                                              ? "முதல் பெயர்"
                                              : 'First Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: greyblue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: needred,
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Badconditionields(
                                  controller: firstnamecontroller,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "முதல் பெயர்"
                                          : 'First Name',
                                ),
                                const SizedBox(height: 16.0),
                                // Row(
                                //   children: [
                                //     Text(
                                //       Provider.of<LanguageProvider>(context)
                                //               .isTamil
                                //           ? "கடைசி பெயர்"
                                //           : 'Last Name',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 20,
                                //         color: greyblue,
                                //       ),
                                //     ),
                                //     Text(
                                //       '*',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.red,
                                //         fontSize: 20,
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
                                              ? "கடைசி பெயர்"
                                              : 'Last Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: greyblue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: needred,
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Badconditionields(
                                  controller: lastnamecontroller,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "கடைசி பெயர்"
                                          : 'Last Name',
                                ),
                                const SizedBox(height: 16.0),
                                // Row(
                                //   children: [
                                //     Text(
                                //       Provider.of<LanguageProvider>(context)
                                //               .isTamil
                                //           ? "பயனர் பெயர்"
                                //           : 'UserName',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 20,
                                //         color: greyblue,
                                //       ),
                                //     ),
                                //     Text(
                                //       '*',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.red,
                                //         fontSize: 20,
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
                                              ? "பயனர் பெயர்"
                                              : 'UserName',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: greyblue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: needred,
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Badconditionields(
                                  controller: usernamecontroller,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "பயனர் பெயர்"
                                          : 'Username',
                                ),
                                const SizedBox(height: 16.0),
                                // Row(
                                //   children: [
                                //     Text(
                                //       Provider.of<LanguageProvider>(context)
                                //               .isTamil
                                //           ? "தொலைபேசி எண்"
                                //           : 'Phone Number',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 20,
                                //         color: greyblue,
                                //       ),
                                //     ),
                                //     Text(
                                //       '*',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.red,
                                //         fontSize: 20,
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
                                              ? "தொலைபேசி எண்"
                                              : 'Phone Number',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: greyblue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: needred,
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                TextField(
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  controller: phonenumbercontroller,
                                  // obscureText: hidden,
                                  maxLines: null,
                                  // minLines: 1,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.grey[400]!,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.grey[400]!,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    hintText:
                                        Provider.of<LanguageProvider>(context)
                                                .isTamil
                                            ? "தொலைபேசி எண்"
                                            : 'Phone Number',
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                // Badconditionields(
                                //   controller: phonenumbercontroller,
                                //   hintText:
                                //       Provider.of<LanguageProvider>(context)
                                //               .isTamil
                                //           ? "தொலைபேசி எண்"
                                //           : 'Phone Number',
                                // ),

                                const SizedBox(height: 16.0),
                                // Row(
                                //   children: [
                                //     Text(
                                //       Provider.of<LanguageProvider>(context)
                                //               .isTamil
                                //           ? "பணியாளர் ஐடி"
                                //           : 'Staff Id',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 20,
                                //         color: greyblue,
                                //       ),
                                //     ),
                                //     Text(
                                //       '*',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.red,
                                //         fontSize: 20,
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
                                              ? "பணியாளர் ஐடி"
                                              : 'Staff Id',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: greyblue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: needred,
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Badconditionields(
                                  controller: staffidcontroller,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "பணியாளர் ஐடி"
                                          : 'Staff Id*',
                                ),
                                const SizedBox(height: 16.0),
                                // Row(
                                //   children: [
                                //     Text(
                                //       Provider.of<LanguageProvider>(context)
                                //               .isTamil
                                //           ? "கடவுச்சொல்"
                                //           : 'Password',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 20,
                                //         color: greyblue,
                                //       ),
                                //     ),
                                //     Text(
                                //       '*',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.red,
                                //         fontSize: 20,
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
                                              ? "கடவுச்சொல்"
                                              : 'Password',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: greyblue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: needred,
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Badconditionields(
                                  controller: passwordcontroller,
                                  hintText:
                                      Provider.of<LanguageProvider>(context)
                                              .isTamil
                                          ? "கடவுச்சொல்"
                                          : 'Password',
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       Provider.of<LanguageProvider>(context)
                                //               .isTamil
                                //           ? "பாத்திரங்கள்"
                                //           : 'Role',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 20,
                                //         color: greyblue,
                                //       ),
                                //     ),
                                //     Text(
                                //       '*',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.red,
                                //         fontSize: 20,
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
                                              ? "பாத்திரங்கள்"
                                              : 'Role',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: greyblue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: needred,
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: 60,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.grey[400]!),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white,
                                        ),
                                      ],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    child: DropdownButton<int>(
                                      underline: SizedBox(),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      dropdownColor: Colors.white,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: greyblue,
                                      ),
                                      isExpanded: true,
                                      value: selectedRole,
                                      elevation: 1,
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          selectedRole = newValue!;
                                        });
                                      },
                                      items: <DropdownMenuItem<int>>[
                                        DropdownMenuItem<int>(
                                          value: 1,
                                          child: Text(
                                            Provider.of<LanguageProvider>(
                                                        context)
                                                    .isTamil
                                                ? "நிர்வாகம்"
                                                : 'Admin',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem<int>(
                                          value: 2,
                                          child: Text(
                                            Provider.of<LanguageProvider>(
                                                        context)
                                                    .isTamil
                                                ? "பயனர்"
                                                : 'User',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem<int>(
                                          value: 3,
                                          child: Text(
                                            Provider.of<LanguageProvider>(
                                                        context)
                                                    .isTamil
                                                ? "வளாகம்"
                                                : 'Campus',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                const SizedBox(
                                  height: 16,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (firstnamecontroller.text.isNotEmpty &&
                                        lastnamecontroller.text.isNotEmpty &&
                                        passwordcontroller.text.isNotEmpty &&
                                        phonenumbercontroller.text.isNotEmpty &&
                                        staffidcontroller.text.isNotEmpty &&
                                        usernamecontroller.text.isNotEmpty) {
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
                                              //                       registerWithEmail();
                                              //                       // Navigator.of(context)
                                              //                       //     .pop();
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
                                                                    // top: 10,
                                                                    // bottom: 10,
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
                                                                            .5),
                                                                thickness: 1,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  registerWithEmail();
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
                                                                    // top: 10,
                                                                    // bottom: 10,
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
                                      color: darkblue,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        Provider.of<LanguageProvider>(context)
                                                .isTamil
                                            ? "சேர்க்க"
                                            : "Add",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
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
