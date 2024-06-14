import 'package:flutter/material.dart';
import 'package:test1/test/loginTest.dart';
import 'package:test1/test_main/alarmRecipe.dart';
import 'package:test1/test_main/jsonParse3.dart';
import 'package:test1/test_main/recipe.dart';
import 'package:test1/test_main/signIn.dart';
import 'package:test1/test_main/splashPage.dart';
import 'package:test1/test_main/testAlarm.dart';
import 'package:test1/test_ocr/mlKitTestMini.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => SplashPage()); // MLKitTest2  SplashPage
    case '/login':
      return MaterialPageRoute(builder: (context) => LogInTest()); //LogInTest()//LogInTest()
    case '/signin':
      return MaterialPageRoute(builder: (context) => SignIn()); //LogInTest()//LogInTest()
    case '/list':
      String loginArgument = settings.arguments.toString();
      return MaterialPageRoute(builder: (context) => JsonParse3(authorization: loginArgument));
    case '/recipe':
      //List<String> recipeArgument = settings.arguments as List<String>;
      Map recipeArgument = settings.arguments as Map;
      return MaterialPageRoute(builder: (context) => Recipe(foodList: recipeArgument['foodList'], authorization: recipeArgument['authorization']));
    case '/alarm':
      String alarmArgument = settings.arguments.toString();
      return MaterialPageRoute(builder: (context) => AlarmRecipe(authorization: alarmArgument));
    default:
      return MaterialPageRoute(builder: (context) => LogInTest());
  }
}