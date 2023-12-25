import 'dart:async';

import 'package:flutter/material.dart';

import '../../helper/auth_helper.dart';
import '../../utils/route_utils.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 3), (timer) {
      Navigator.of(context).pushReplacementNamed(
        (AuthHelper.authHelper.firebaseAuth.currentUser != null)
            ? MyRoutes.home
            : MyRoutes.lets_get_started_page,
      );
      timer.cancel();
    });
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/NewLogo.png', scale: 2.5),
      ),
    );
  }
}
