import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
class AlarmTest extends StatefulWidget {
  const AlarmTest({super.key});

  @override
  State<AlarmTest> createState() => _AlarmTestState();
}

class _AlarmTestState extends State<AlarmTest> {
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    _permissionWithNotification();
    _initialization();
  }

  void _permissionWithNotification() async {
    if (await Permission.notification.isDenied &&
        !await Permission.notification.isPermanentlyDenied) {
      await [Permission.notification].request();
    }
  }

  void _initialization() async {
    AndroidInitializationSettings android =
    const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings =
    InitializationSettings(android: android, iOS: ios);
    await _local.initialize(settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        child: Icon(Icons.add),
        onPressed: () async{
          NotificationDetails details = const NotificationDetails(
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
            android: AndroidNotificationDetails(
              "show_test",
              "show_test",
              importance: Importance.max,
              priority: Priority.high,
            ),
          );
          await _local.show(
            0,
            "타이틀이 보여지는 영역입니다.",
            "컨텐츠 내용이 보여지는 영역입니다.\ntest show()",
            details,
            payload: "tyger://",
          );
        },
      )
    );
  }
}