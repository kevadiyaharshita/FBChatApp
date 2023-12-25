import '../../../utils/date_utils.dart';
import 'package:flutter/material.dart';

Widget getTimeData({required String time, required String type}) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(
    int.parse(time),
  );
  Duration day = DateTime.now().difference(dt);
  String date = "";
  date = "${dt.hour % 12 == 0 ? 12 : dt.hour % 12}" +
      ":" +
      "${dt.minute}".padLeft(2, "0") +
      " " +
      "${(dt.hour > 12) ? "PM" : "Am"}";
  // if (int.parse(day.inDays.toString()) > 0) {
  //   print("If Statument");
  //   date = "${dt.day}".padLeft(2, "0") +
  //       "/" +
  //       "${dt.month}".padLeft(2, "0") +
  //       "/" +
  //       "${dt.year}";
  // } else if (int.parse(day.inHours.toString()) > DateTime.now().hour) {
  //   print("else If Statument : ${int.parse(day.inHours.toString())}");
  //   date = "YesterDay";
  // } else {
  //   print("else Statument :${int.parse(day.inHours.toString())}");
  //   date = "${dt.hour % 12 == 0 ? 12 : dt.hour % 12}" +
  //       ":" +
  //       "${dt.minute}".padLeft(2, "0") +
  //       " " +
  //       "${(dt.hour > 12) ? "PM" : "Am"}";
  // }
  return Text(date,
      style: TextStyle(
          fontSize: 12,
          color:
              (type == 'sent') ? Colors.white.withOpacity(0.8) : Colors.grey));
}

String setDateTime({required String timeMsgData}) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(
    int.parse(timeMsgData),
  );

  Duration day = DateTime.now().difference(dt);
  String date = "";
  if (day.inDays > 0) {
    if (day.inDays == 1) {
      date = "YesterDay";
    } else if (day.inDays >= 2 && day.inDays <= 7) {
      date = getWeekDay(day: dt.weekday);
    } else {
      date = "${dt.day}".padLeft(2, "0") +
          "/" +
          "${dt.month}".padLeft(2, "0") +
          "/" +
          "${dt.year}";
    }
  } else if (int.parse(day.inHours.toString()) > DateTime.now().hour) {
    date = "YesterDay";
  } else {
    date = "${dt.hour % 12 == 0 ? 12 : dt.hour % 12}".padLeft(2, "0") +
        ":" +
        "${dt.minute}".padLeft(2, "0") +
        " " +
        "${(dt.hour > 12) ? "PM" : "Am"}";
  }
  return date;
}

String getCheckDate({required String timeMsgData}) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(
    int.parse(timeMsgData),
  );

  Duration day = DateTime.now().difference(dt);
  String date = "";
  if (day.inDays > 0) {
    if (day.inDays == 1) {
      date = "YesterDay";
    } else if (day.inDays >= 2 && day.inDays <= 7) {
      date = getWeekDay(day: dt.weekday);
    } else {
      date = "${dt.day}".padLeft(2, "0") +
          "/" +
          "${dt.month}".padLeft(2, "0") +
          "/" +
          "${dt.year}";
    }
  } else if (int.parse(day.inHours.toString()) > DateTime.now().hour) {
    date = "YesterDay";
  } else {
    date = "Today";
  }
  return date;
}
