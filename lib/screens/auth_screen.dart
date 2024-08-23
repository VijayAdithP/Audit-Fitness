import 'package:auditfitnesstest/models/locale_provider.dart';
import 'package:auditfitnesstest/screens/widgets/auth_textfields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Positioned(
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
                            : "Welcom",
                        style: GoogleFonts.manrope(
                          textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
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
                        style: GoogleFonts.manrope(
                          color: Colors.grey[800],
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
                        onTap: loginController.loginWithEmail,
                        child: Container(
                          height: 50,
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              Provider.of<LanguageProvider>(context).isTamil
                                  ? "உள்நுழைய"
                                  : "Login",
                              style: GoogleFonts.manrope(
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
                            const Icon(
                              Icons.type_specimen_sharp,
                              size: 30,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              Provider.of<LanguageProvider>(context).isTamil
                                  ? "English"
                                  : "தமிழ்",
                              style: GoogleFonts.manrope(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Positioned(
              //   child: Align(
              //     alignment: Alignment.bottomCenter,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           Provider.of<LanguageProvider>(context).isTamil
              //               ? "கணக்கு இல்லையா?"
              //               : "Dont have an account?",
              //           style: GoogleFonts.manrope(),
              //         ),
              //         TextButton(
              //           style: TextButton.styleFrom(
              //               foregroundColor: Colors.purple[900]),
              //           onPressed: widget.showRegisterpage,
              //           child: Text(
              //               Provider.of<LanguageProvider>(context).isTamil
              //                   ? "பதிவு"
              //                   : "Register",
              //               style: GoogleFonts.manrope()),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
