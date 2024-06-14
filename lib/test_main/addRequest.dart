import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<http.Response> addRequest (String foodName, int quantity,
    String category, String expiration, String authorization) async {

  const String url = "http://15.164.150.143/food/save";

  final msg = jsonEncode({
    "foodName": foodName,
    "quantity": quantity,
    "category": category,
    "storage": "냉장",
    "expiration" : expiration,
  });

  final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'access' :  authorization
      },
      body: msg
  );
  print("save code : " + response.statusCode.toString());
  return response;
}



Future<http.Response> deleteRequest (int foodID, String authorization) async {
  String url = "http://15.164.150.143/food/deleteFood/" + foodID.toString();
  print(url);
  print("deleteRequest start");
  final response = await http.delete(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'access' :  authorization
    },

  );
  print("delete code : " + response.statusCode.toString());
  return response;
}




Future<http.Response> modifyRequest (String name, String date, String category, int count, int foodID, String authorization) async {
  String url = "http://15.164.150.143/food/updateFood/" + foodID.toString();

  print(url);
  String ssss = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
  print("modifyRequest start" + name + ssss + count.toString() + foodID.toString() + authorization);
  print("date : " +date);
  print("formating : " + ssss);
  final msg = jsonEncode({
    "foodName" : name,
    "expiration" : ssss,
    "expiration": DateFormat('yyyy-MM-dd').format(DateTime.parse(date)),
    "storage": "냉장",
    "quantity" : count,
    //"category" : category,
    // name, category
  });

  final response = await http.patch(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'access' :  authorization
    },
    body : msg
  );
  print("modifyRequest code : " + response.statusCode.toString());
  return response;
}


Future<http.Response> recipeRequest (List<String> foodList, String type, List<String> condition, String authorization) async {
  String url = "http://15.164.150.143/chatGpt/recommendRecipe";

  print(url);
  print("recipeRequest Strat");

  final msg = jsonEncode({
    "ingredients": foodList,
    "cuisineType": type,
    "dietaryRestrictions": condition,
  });
  print(msg);

  final testmsg = jsonEncode({
    "ingredients": ["닭가슴살", "양파"],
    "cuisineType": "양식",
    "dietaryRestrictions": ["글루텐 없음"]
  });

  final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'access' :  authorization
      },
      body : msg
  );
  print("recipeRequest code : " + response.statusCode.toString());
  return response;

  //print("Alarm Test");

  // EventSource eventSource = await EventSource.connect("http://52.79.146.63:8080/users/alarm2/subscribe", headers: {
  //   'Content-Type': 'application/json',
  //   'Authorization': sss
  // });
}
