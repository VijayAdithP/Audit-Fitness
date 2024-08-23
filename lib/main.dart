// import 'package:auditfitnesstest/screens/auth_screen.dart';
// import 'package:auditfitnesstest/screens/main_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:provider/provider.dart';
// import "package:auditfitnesstest/models/locale_provider.dart";

// Future<void> main() async {
//   final box = GetStorage();

//   await GetStorage.init();
//   WidgetsFlutterBinding.ensureInitialized();

//   String? token1 = box.read('token');
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]);
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => LanguageProvider(),
//       child: GetMaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: token1 != null ? const Mainpage() : const AuthScreen(),
//       ),
//     ),
//   );
// }
import 'package:auditfitnesstest/firebase_options.dart';
import 'package:auditfitnesstest/screens/auth_screen.dart';
import 'package:auditfitnesstest/screens/main_page.dart';
import 'package:auditfitnesstest/service/notification/firebase_api.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:auditfitnesstest/models/locale_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  final box = GetStorage();

  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  requestNotificationPermission();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  String? token1 = box.read('token');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await FirebaseApi().initNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => WeeklyTasksProvider()),
      ],
      child: GetMaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.manropeTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        home: token1 != null ? const Mainpage() : const AuthScreen(),
      ),
    ),
  );
}

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}
