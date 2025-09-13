import 'package:auditfitnesstest/assets/colors.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/widgets/auth_textfields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../controllers/logincontroller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showLoginpage = true;
  void togglescreen() {
    setState(() {
      _showLoginpage = !_showLoginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (_showLoginpage) {
    return LoginPage(showRegisterpage: togglescreen);
    // } else {
    //   return RegisterPage(showLoginpage: togglescreen);
    // }
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.showRegisterpage,
  });
  final VoidCallback showRegisterpage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController loginController = Get.put(LoginController());

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    // bool isloading = box.read('isloading');
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: lighterbackgroundblue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "வருக"
                          : "Welcome",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: greyblue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      Provider.of<LanguageProvider>(context).isTamil
                          ? "உள்நுழைய உங்கள் நற்சான்றிதழை உள்ளிடவும்"
                          : "Enter your Credential to log in",
                      style: TextStyle(
                        color: greyblue,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AuthTextfields(
                    controller: loginController.usernameController,
                    hintText: Provider.of<LanguageProvider>(context).isTamil
                        ? "பயனர் பெயர்"
                        : "User Name",
                  ),
                  AuthTextfields(
                    controller: loginController.passwordController,
                    hintText: Provider.of<LanguageProvider>(context).isTamil
                        ? "கடவுச்சொல்"
                        : "Password",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   isloading = true;
                        // });
                        loginController.loginWithEmail();
                      },
                      child: Container(
                        height: 50,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: darkblue,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            Provider.of<LanguageProvider>(context).isTamil
                                ? "உள்நுழைய"
                                : "Login",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Provider.of<LanguageProvider>(context, listen: false)
                          .toggleLanguage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.type_specimen_sharp,
                            size: 30,
                            color: greyblue,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            Provider.of<LanguageProvider>(context).isTamil
                                ? "English"
                                : "தமிழ்",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: greyblue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
