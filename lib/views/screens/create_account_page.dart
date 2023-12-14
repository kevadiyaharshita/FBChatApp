import 'package:chatapp_2/helper/auth_helper.dart';
import 'package:chatapp_2/utils/current_user_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../helper/firestore_helper.dart';
import '../../modals/user_modal.dart';
import '../../utils/color_utils.dart';
import '../../utils/route_utils.dart';

class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPswController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.sizeOf(context);
    RxBool cPassCkeck = false.obs;
    RxBool passCkeck = false.obs;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(15),
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
                ),
                const Gap(10),
                Text(
                  "Fill your information below or register \n with your social account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Gap(40),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: orangeTheme,
                        ),
                      ),
                      fillColor: greyTheme,
                    ),
                    validator: (value) {
                      return (value == "") ? "Enter Email" : null;
                    },
                  ),
                ),
                Gap(15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: Obx(
                    () => TextFormField(
                      controller: passwordController,
                      obscureText: passCkeck.value,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: orangeTheme,
                          ),
                        ),
                        fillColor: greyTheme,
                        suffixIcon: IconButton(
                          onPressed: () {
                            passCkeck(!passCkeck.value);
                          },
                          icon: Obx(() => (passCkeck.value)
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                        ),
                      ),
                      validator: (value) {
                        return (value == "") ? "Enter Password " : null;
                      },
                      onChanged: (val) {},
                    ),
                  ),
                ),
                Gap(15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Confirm Password",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: Obx(
                    () => TextFormField(
                      controller: confirmPswController,
                      validator: (value) {
                        return (value == "") ? "Enter Password" : null;
                      },
                      obscureText: cPassCkeck.value,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: orangeTheme,
                          ),
                        ),
                        fillColor: greyTheme,
                        suffixIcon: IconButton(
                          onPressed: () {
                            cPassCkeck(!cPassCkeck.value);
                          },
                          icon: Obx(() => (cPassCkeck.value)
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                        ),
                      ),
                      onChanged: (val) {},
                    ),
                  ),
                ),
                const Gap(40),
                Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: orangeTheme,
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        if (passwordController.text ==
                            confirmPswController.text) {
                          User? user = await AuthHelper.authHelper
                              .registerUserWithEmailPassword(
                            email: emailController.text,
                            password: passwordController.text,
                            context: context,
                          );
                          if (user != null) {
                            FireStoreHelper.fireStoreHelper
                                .setUserData(user: user)
                                .then(
                              (value) async {
                                UserModal userModal = await FireStoreHelper
                                    .fireStoreHelper
                                    .getUserByEmail(
                                        email: user.email as String);
                                CurrentUser.user = userModal;
                                return Navigator.of(context)
                                    .pushReplacementNamed(
                                        MyRoutes.update_profile);
                              },
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Password MisMatched..!!"),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
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
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(40),

                //=================================================================
                const Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Or sign up with",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Spacer(),
                    Ink(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(200),
                        splashColor: Colors.grey,
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/apple_icon.png',
                            scale: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const Gap(15),
                    Ink(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () async {
                          User? user =
                              await AuthHelper.authHelper.signInWithGoogle();
                          if (user != null) {
                            FireStoreHelper.fireStoreHelper
                                .setUserData(user: user)
                                .then(
                              (value) async {
                                UserModal userModal = await FireStoreHelper
                                    .fireStoreHelper
                                    .getUserByEmail(
                                        email: user.email as String);
                                CurrentUser.user = userModal;
                                return Navigator.of(context)
                                    .pushReplacementNamed(MyRoutes.home);
                              },
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(200),
                        splashColor: Colors.grey,
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/google_icon.png',
                            scale: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const Gap(15),
                    Ink(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(200),
                        splashColor: Colors.grey,
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/facebook_icon.png',
                            scale: 1.5,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                const Gap(20),
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
