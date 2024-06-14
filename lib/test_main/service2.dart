import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:test1/test_main/food.dart';
import 'package:eventsource/eventsource.dart';

class Services{
  static const String url = "http://15.164.150.143/food/searchFoodList";
  //static const String url = "http://52.79.146.63:8080/food/searchFoodList?username=testman2&&password=1234";
  String s = "username=";

  //static const String url = "http://52.79.146.63:8080/food/searchFoodList?username=testman";

  static Future<List<Food>> getInfo(String authorization) async{

    // const String url1 = "http://52.79.146.63:8080/login";
    // print("Service2 start");
    //
    // print(" login part start");
    // var response1 = await http.post(
    //     Uri.parse(url1),
    //     body: {
    //       'username': "testman",
    //       'password': "1234"
    //     }
    // );
    // print("login status code: " + response1.statusCode.toString());
    // String sss = response1.headers['authorization'].toString();
    // print("login body: " + response1.headers['authorization'].toString());

    //print("Alarm Test");

    // EventSource eventSource = await EventSource.connect("http://52.79.146.63:8080/users/alarm2/subscribe", headers: {
    //   'Content-Type': 'application/json',
    //   'Authorization': sss
    // });

    // void _connectToSSE() async {
    //   final headers = {
    //     'Content-Type': 'application/json',
    //     'Authorization': sss,
    //   };
    //   EventSource eventSource = await EventSource.connect(
    //     "http://52.79.146.63:8080/users/alarm2/subscribe",
    //     headers: headers,
    //   );
    // }
    // _connectToSSE();


    // print("svae test");
    // final msg = jsonEncode({
    //   "foodName": "고구마테스트",
    //   "quantity": 7,
    //   "category": "채소",
    //   "storage": "냉장",
    //   "expiration": "2024-05-17"
    // });
    //
    // final response3 = await http.post(
    //     Uri.parse("http://52.79.146.63:8080/food/save"),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Authorization' :  sss
    //     },
    //     body: msg
    // );
    // print("save code : " + response3.statusCode.toString());


    try{
      print("food get start");
      final response = await http.get(
          Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
            'access' :  authorization
        }
      );
      print("food get status :  "+ response.statusCode.toString());
      if(response.statusCode==200){
        print("200 success");
        //final List<Food> user = foodFromJson(response.body);
        print(utf8.decode(response.bodyBytes));
        final List<Food> user = foodFromJson(utf8.decode(response.bodyBytes));
        return user;
      }
      else{
        print("some wrong status");
        Fluttertoast.showToast(msg: 'Connection Error');
        return <Food>[];
      }
    }catch(e){
      print("some error : " + e.toString());
      Fluttertoast.showToast(msg: e.toString());
      return <Food>[];
    }
  }
}