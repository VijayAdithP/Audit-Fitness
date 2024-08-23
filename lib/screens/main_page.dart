import 'package:auditfitnesstest/screens/admin/adminpage.dart';
import 'package:auditfitnesstest/screens/auth_screen.dart';
import 'package:auditfitnesstest/screens/campus/campuspage.dart';
import 'package:auditfitnesstest/screens/user/userpage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => MainpageState();
}

class MainpageState extends State<Mainpage> {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    String? role = box.read('role');
    if (role!.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (role == 'admin') {
      return const AdminNavPage();
    } else if (role == 'user') {
      return const UserHomePage();
    } else if (role == 'executer') {
      return const CampusPage();
    } else {
      return const AuthScreen();
    }
  }
}
