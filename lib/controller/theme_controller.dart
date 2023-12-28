import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  RxBool isThemeDark = false.obs;
  late SharedPreferences preferences;

  ThemeController({required this.preferences});

  init() async {
    preferences = await SharedPreferences.getInstance();
  }

  get getTheme {
    isThemeDark(preferences.getBool('theme') ?? false);
    return isThemeDark.value;
  }

  changeTheme() {
    isThemeDark(!isThemeDark.value);
    preferences.setBool('theme', isThemeDark.value);
  }
}
