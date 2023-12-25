import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LocalNotificationHelper {
  LocalNotificationHelper._();

  static final LocalNotificationHelper localNotificationHelper =
      LocalNotificationHelper._();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //Done: initialize
  Future<void> initNotification() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("ic_launcher");

    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //Done: simpleNotification

  Future<void> sendSimpleNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('demo_notification', 'Demo',
            importance: Importance.max);

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      101,
      'Hello!',
      'This is Simple Notification...',
      notificationDetails,
    );
  }

  //TODO: BIG PICTURE
  Future<void> sendBigPictureNotification(
      {required String title, required String body}) async {
    String imageLink =
        'https://docs.flutter.dev/assets/images/dash/Dashatars.png';

    http.Response response = await http.get(Uri.parse(imageLink));
    Directory? dir = await getExternalStorageDirectory();
    String path = "${dir!.path}/not.png";
    File file = File(path);
    await file.writeAsBytes(response.bodyBytes);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('demo_notification', 'Demo',
            importance: Importance.max,
            largeIcon: const DrawableResourceAndroidBitmap('dash'),
            styleInformation: BigPictureStyleInformation(
              FilePathAndroidBitmap(file.path),
            ));

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      102,
      'Hello!',
      'This is Big Picture Notification...',
      notificationDetails,
    );
  }

  //TODO: BIG PICTURE
  Future<void> sendMediaNotification(
      {required String title, required String body}) async {
    String imageLink =
        'https://docs.flutter.dev/assets/images/dash/Dashatars.png';

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'demo_notification',
      'Demo',
      importance: Importance.max,
      largeIcon: DrawableResourceAndroidBitmap('dash'),
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      104,
      'Hello!',
      'This is Media Notification...',
      notificationDetails,
    );
  }
}
