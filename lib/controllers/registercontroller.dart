import 'dart:convert';
import 'package:auditfitnesstest/screens/admin/viewing%20pages/view_all_users.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterationController extends GetxController {
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController firstnamecontroller = TextEditingController();
  final TextEditingController lastnamecontroller = TextEditingController();
  final TextEditingController phonenumbercontroller = TextEditingController();
  final TextEditingController staffidcontroller = TextEditingController();
  final int selectedRole = 1;

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
        usernamecontroller.clear();
        passwordcontroller.clear();
        firstnamecontroller.clear();
        lastnamecontroller.clear();
        phonenumbercontroller.clear();
        staffidcontroller.clear();
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
}
