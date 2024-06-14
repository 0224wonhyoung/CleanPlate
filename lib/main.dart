import 'package:flutter/material.dart';
import 'package:test1/test/diceTest.dart';
import 'package:test1/test/listTest.dart';
import 'package:test1/test/loginTest.dart';
import 'package:test1/test/loginTest2.dart';
import 'package:test1/test/screenA.dart';
import 'package:test1/test/screenB.dart';
import 'package:test1/test/screenC.dart';
import 'package:test1/test/test.dart';
import 'package:test1/test_json/jsonParse.dart';
import 'package:test1/test_json/jsonParse2.dart';
import 'package:test1/test_json/listTest.dart';
import 'package:test1/test_main/jsonParse3.dart';
import 'package:test1/test_ocr/cameraTest.dart';
import 'package:test1/test_ocr/mlKitTest.dart';
import 'package:test1/test_ocr/ocrTest.dart';
import 'package:test1/test_main/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:test1/test_main/jsonParse3.dart';


void main() async {
  /*
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: "9inp5rekt3");
  */
  //await _initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Clean Plate",
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',    // 처음 Route의 이름은 / 다.
      onGenerateRoute: generateRoute,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // routes: {
      //   '/' : (context) =>  LogInTest(), // lists  JsonParse, MLKitTest, LogInTest,
      //   '/list' : (context) =>  JsonParse3(),
      //   '/b' : (context) => ScreenB(),
      //   '/c' : (context) => ScreenC(),
      //   '/dice' : (context) => DiceTest(),
      // },
    );
  }
}

