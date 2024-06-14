import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<http.Response> postRequest () async {
  const String url = "http://52.79.146.63:8080/login";
  print("postRequesst start");

  var response = await http.post(
      Uri.parse(url),
      body: {
      'username': "testman2",
      'password': "1234"
      }
  );
  print("code: " + response.statusCode.toString());
  String sss = response.headers['authorization'].toString();
  print("body: " + response.headers['authorization'].toString());

  var response2 = await http.get(
      Uri.parse("http://52.79.146.63:8080/food/searchFoodList"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization' : sss
      }
  );
  print("code: " + response2.statusCode.toString());
  print("body: " + response2.headers['authorization'].toString());

  return response;
}