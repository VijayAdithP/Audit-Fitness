import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auditfitnesstest/utils/apiendpoints.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:auditfitnesstest/screens/main_page.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final box = GetStorage();

  Future<void> loginWithEmail() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      String username = usernameController.text;
      box.write('username', username);

      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.loginEmail);

      var body = json.encode({
        "username": usernameController.text,
        "password": passwordController.text,
      });

      var response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        var token = json['token'];
        var role = json['role'];
        box.write('token', token);
        box.write('role', role);

        //to send the FCMtoken and the user name to identify the specific user rather than the device
        fcmtokenpost();

        passwordController.clear();
        usernameController.clear();
        Get.off(() => const Mainpage());
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Invalid Login";
      }
    } catch (error) {
      bool isloading = false;
      box.write('isloading', isloading);
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Opps!'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(error.toString())],
            );
          });
    }
  }

  Future<void> fcmtokenpost() async {
    String FCMtoken = box.read('FCMtoken');
    String username = box.read('username');
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.userFCMtoken);

      var body = json.encode({
        "username": username,
        "fcmtoken": FCMtoken,
      });

      var response = await http.post(url, body: body, headers: headers);
      if (response.statusCode == 200) {
        print("all good post");
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
}
