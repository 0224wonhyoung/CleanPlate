import 'dart:convert';

import 'package:eventsource/eventsource.dart' as es;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/test_main/alarmData.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

Future<void> alarmRequest (String authorization, FlutterLocalNotificationsPlugin _local, SharedPreferences _prefs) async {
  print("alarmRequest Start");
  es.EventSource eventSource = await es.EventSource.connect("http://15.164.150.143/users/alarm2/subscribe", headers: {
    'Content-Type': 'application/json',
    'access': authorization
  });
  print("alarm----------------");
  print( eventSource.hashCode );
  print( eventSource.readyState );
  print( eventSource.onMessage );
  print( eventSource.onOpen);
  print( eventSource.onError);
  print("alarmRequest Start");
  print("alarm----------------");

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
  int id = 0;
  bool alarm = false;

//   tz.initializeTimeZones();
//   tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
//   tz.TZDateTime now = tz.TZDateTime.now(tz.local);
// // 2024-01-22 00:00:00.000Z
//   tz.TZDateTime setting = tz.TZDateTime(tz.local, 2024, 1, 22);
// // 2024-01-22 00:00:00.000Z
//   tz.TZDateTime duration = now.add(const Duration(hours: 3, minutes: 20));
// // 2024-01-22 03:20:00.000Z
//   tz.TZDateTime schedule = tz.TZDateTime.now(tz.local);
//
//   await _local.zonedSchedule(
//     1,
//     "abc",
//     "def",
//     schedule,
//     details,
//     uiLocalNotificationDateInterpretation:
//     UILocalNotificationDateInterpretation.absoluteTime,
//     matchDateTimeComponents: DateTimeComponents.time,
//   );


  eventSource.listen((es.Event event) {
    alarm = _prefs.getBool('alarm') ?? false;
    //TODO Check this 3 line correct
    if(!alarm){
      return;
    }
    print("New event: -----------------");
    print("  event: ${event.event}");
    print("  data: ${event.data}");
    print("alarm----------------");

    if(event.event == "expirationAlert" && alarm){
      String msg = jsonDecode(event.data.toString())["Expiration"];
      print("************************** 소비기한 관련: " + msg);
      _local.show(
        id,
        "Clean Food",
        msg,
        details,
        payload: "tyger://",
      );
    }
    id++;
  });

}

class CustomData{
  List<String> foodList;
  String recipe;
  CustomData({required this.foodList, required this.recipe});
}

Future<CustomData> alarmRequest2 (String authorization) async {
  print("alarmRequest222 Start" + authorization);
  const String url = "http://15.164.150.143/users/alarmList";
  List<AlarmData> data = [];
  try {
    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'access': authorization
        }
    );
    print("alarmRequest222 status :  " + response.statusCode.toString());
    if (response.statusCode == 200) {
      //final List<Food> user = foodFromJson(response.body);
      //print(utf8.decode(response.bodyBytes));
      data = alarmDataFromJson(utf8.decode(response.bodyBytes));
    }
    else {
      print("some wrong status");
    }
  } catch (e) {
    print("some error : " + e.toString());
  }

  List<String> list = [];
  String recipe = "";
  print("데이터 길이 : " + data.length.toString());
  for (AlarmData a in data) {
    if(a.alarmType == "near expiration!"){
      list.add(a.content);
    }
    // print(a.id.toString() + a.alarmType + a.content);
    else if(a.alarmType == "new recipe!"){
      recipe = a.content;
    }
  }
  CustomData c = CustomData(foodList: list, recipe: recipe);
  return c;
}
