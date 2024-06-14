import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<Map<String, String>> loginRequest (String name, String password) async {


  //const String url = "http://52.79.146.63/login";
  const String url = "http://15.164.150.143/login";
  const String url2 = "http://15.164.150.143/users/reissue";
  print("loginRequest start with name : "+ name + ", pw : " + password);

  var response = await http.post(
      Uri.parse(url),
      body: {
        'username': name,
        'password': password
      }
  );
  print("code: " + response.statusCode.toString());


  if(response.statusCode == 401){
    print("Need to Refresh (401 Code)");
    var response2 = await http.post(
        Uri.parse(url2),
        body: {
          'username': name,
          'password': password
        }
    );
    print("code2: " + response2.statusCode.toString());
  }


  String sss = response.headers['set-cookie'].toString();
  final res1 = sss.split(";");
  final res2 = res1[0].split("=");
  final refresh = res2[1].trim();

  String authorization = response.headers['access'].toString().trim();

  print("인증키 : " + authorization);
  print("리프레시 : " + refresh);

  Map <String, String> result = {
    "statusCode" : response.statusCode.toString(),
    "authorization" : authorization
  };

  return result;
}

Future<http.Response> signInRequest (String name, String password, String nickname, String email, String address) async {

  //const String url = "http://52.79.146.63/login";
  const String url = "http://15.164.150.143/users/join";
  print("SignIn Request start with name : "+ name + ", pw : " + password);

  final msg = jsonEncode({
    "username": "testman33",
    "password": "1234",
    "role": "member",
    "nickName": "testman",
    "email": "testman@example.com",
    "address": "korea"
  });

  var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: msg
  );
  print("code: " + response.statusCode.toString());

  return response;
}