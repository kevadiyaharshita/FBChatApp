import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/color_utils.dart';
import '../../utils/route_utils.dart';

class LetsGetStarted extends StatelessWidget {
  const LetsGetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(10),
                Image.asset(
                  'assets/images/NewLogo.png',
                  scale: 3.1,
                ),
                const Gap(50),
                Transform.scale(
                  scale: 1.2,
                  child: Image.asset(
                    'assets/images/Newfirstpage.png',
                  ),
                ),
                const Gap(50),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      "Your Premier ",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Social",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: orangeTheme),
                    ),
                    Spacer(),
                  ],
                ),
                Text(
                  "Connection App",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: orangeTheme),
                ),
                const Gap(20),
                const Text(
                  " It's a digital technology that enables people to shareprefernces ideas and information through virtual networks.",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const Gap(20),
                Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: orangeTheme,
                  ),
                  child: InkWell(
                    onTap: () async {
                      Navigator.pushNamed(
                          context, MyRoutes.create_account_page);
                    },
                    borderRadius: BorderRadius.circular(30),
                    splashColor: Colors.white,
                    child: Container(
                      height: 50,
                      width: s.width,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "Let's Get Started",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      "Already have an Account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, MyRoutes.sign_in_page);
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: orangeTheme,
                          color: orangeTheme,
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
