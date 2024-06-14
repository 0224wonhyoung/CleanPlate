import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/test_main/loginService.dart';
import 'package:test1/test_main/postTest.dart';

class LogInTest extends StatefulWidget {
  const LogInTest({super.key});

  @override
  State<LogInTest> createState() => _LogInTestState();
}

class _LogInTestState extends State<LogInTest> {
  bool autoLogin = false;
  late SharedPreferences _prefs;
  FlutterSecureStorage storage = FlutterSecureStorage();

  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
    //postRequest();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 50)),
              Center(
                child: Image(
                  image: AssetImage("assets/test.PNG"),
                  width: 170.0,
                  height: 190.0,
                ),
              ),
              Form(
                  child: Theme(
                data: ThemeData(
                    primaryColor: Colors.teal,
                    inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(color: Colors.teal, fontSize: 15.0))),
                child: Container(
                  padding: EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(labelText: "사용자명"),
                        keyboardType: TextInputType.text,
                      ),
                      TextField(
                        controller: controller2,
                        decoration: InputDecoration(labelText: "비밀번호"),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Checkbox(
                              value: autoLogin,
                              onChanged: (bool? value){
                                setState(() {
                                  autoLogin = value!;
                                });
                              }),
                          Text("자동 로그인",),
                        ],
                      ),
                      SizedBox(height: 15.0),

                      Row(

                        children: [
                          Expanded(
                            flex : 1,
                            child: TextButton(
                              child: Text("회원가입", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.lightGreen,
                              ),
                              onPressed: (){
                                //TODO goto 회원가입 page
                                Navigator.pushNamed(context, '/signin');
                              },
                            ),
                          ),
                          SizedBox(width : 20),
                          Expanded(
                            flex: 1,
                            child: ButtonTheme(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                                  child: Icon(Icons.arrow_forward, color: Colors.white, size: 35.0,),
                                  onPressed: (){
                                    // TODO 아래걸로 바꿔야함
                                    // loginRequest("testman","1234").then((value) {
                                    //   // Login Success
                                    //   if(value.statusCode == 200){
                                    //     print ("login success with : "+ value.headers['authorization'].toString());
                                    //     print("autoLogin was" + autoLogin.toString());
                                    //     _prefs.setBool("autoLogin", autoLogin);
                                    //     if(autoLogin){
                                    //       storage.write(key : 'cplogin', value: value.headers['authorization']);
                                    //       print("Login Data Saved At Secure Storage");
                                    //     }
                                    //     storage.write(key : 'cpName', value: "testman");
                                    //     Navigator.pushNamed(context, '/list', arguments: value.headers['authorization']);
                                    //   }
                                    //   // Login Failed
                                    //   else{
                                    //     print(jsonDecode(value.body)['error']);
                                    //     showSnackBar(context, jsonDecode(value.body)['error']);
                                    //   }
                                    // });

                                    // TODO 이걸로 바꿔야함
                                    loginRequest(controller.text, controller2.text).then((value) {
                                      // Login Success
                                      if(value["statusCode"] == "200"){
                                        print ("login success code 200");
                                        _prefs.setBool("autoLogin", autoLogin);
                                        if(autoLogin){
                                          storage.write(key : 'cplogin', value: value['authorization']);
                                          print("Login Data Saved At Secure Storage");
                                        }
                                        storage.write(key : 'cpName', value: controller.text);
                                        Navigator.pushNamed(context, '/list', arguments: value['authorization']);
                                      }
                                      // Login Failed
                                      else{
                                        print(value['statusCode']);
                                        showSnackBar(context, value['statusCode'].toString());
                                      }
                                    });
                                  },)),
                          ),

                        ],

                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

void showSnackBar(BuildContext context, String error){
  ScaffoldMessenger.of(context)
      .showSnackBar(
      SnackBar(
          content: Text(error,
          textAlign: TextAlign.center,),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.blue,));
}