import 'dart:io';

import 'package:chatapp_2/helper/auth_helper.dart';
import 'package:chatapp_2/utils/color_utils.dart';
import 'package:chatapp_2/utils/current_user_modal.dart';
import 'package:chatapp_2/utils/route_utils.dart';
import 'package:chatapp_2/views/screens/chat_page.dart';
import 'package:chatapp_2/views/screens/create_account_page.dart';
import 'package:chatapp_2/views/screens/home_page.dart';
import 'package:chatapp_2/views/screens/lets_get_started.dart';
import 'package:chatapp_2/views/screens/sign_in_page.dart';
import 'package:chatapp_2/views/screens/update_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'helper/firestore_helper.dart';
import 'modals/user_modal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (AuthHelper.authHelper.firebaseAuth.currentUser != null) {
    UserModal userModal = await FireStoreHelper.fireStoreHelper.getUserByEmail(
        email: AuthHelper.authHelper.firebaseAuth.currentUser!.email as String);
    CurrentUser.user = userModal;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: orangeTheme,
        // colorScheme: ColorScheme.fromSeed(seedColor: orangeTheme),
        useMaterial3: true,
      ),
      // initialRoute: MyRoutes.update_profile,
      initialRoute: (AuthHelper.authHelper.firebaseAuth.currentUser != null)
          ? MyRoutes.home
          : MyRoutes.lets_get_started_page,
      routes: {
        // MyRoutes.Splash_Screen: (cnt) => SplashScreen(),
        MyRoutes.home: (context) => HomePage(),
        MyRoutes.create_account_page: (context) => CreateAccountPage(),
        MyRoutes.sign_in_page: (context) => SignInPage(),
        MyRoutes.lets_get_started_page: (context) => LetsGetStarted(),
        MyRoutes.update_profile: (context) => UpdateProfile(),
        MyRoutes.chat_page: (context) => ChatPage(),
      },
    );
  }
}
