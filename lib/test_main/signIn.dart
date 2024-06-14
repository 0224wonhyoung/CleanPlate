import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/test_main/loginService.dart';
import 'package:test1/test_main/postTest.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final region = ['한국', '일본', '중국', '미국', '기타'];
  String selectedRegion = '';


  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerNickName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRegion = region[0];
    //postRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
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
                            controller: controllerName,
                            decoration: InputDecoration(labelText: "사용자명(ID)"),
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 10.0,),
                          TextField(
                            controller: controllerPassword,
                            decoration: InputDecoration(labelText: "비밀번호"),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),
                          SizedBox(height: 10.0,),
                          TextField(
                            controller: controllerNickName,
                            decoration: InputDecoration(labelText: "닉네임"),
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 10.0,),
                          TextField(
                            controller: controllerEmail,
                            decoration: InputDecoration(labelText: "이메일"),
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            children: [
                              Text("지역", style: TextStyle(fontSize:16, color: Colors.cyan),),
                              SizedBox(width: 20,),
                              DropdownButton(
                                style: TextStyle(fontSize: 16, color: Colors.black),
                                value: selectedRegion,
                                items: region.map((e) => DropdownMenuItem(
                                  value: e, // 선택 시 onChanged 를 통해 반환할 value
                                  child: Text(e),
                                )).toList(),
                                onChanged: (value) { // items 의 DropdownMenuItem 의 value 반환
                                  setState(() {
                                    selectedRegion = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            children: [
                              Expanded(
                                flex : 1,
                                child: TextButton(
                                  child: Text("취소", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.lightGreen,
                                  ),
                                  onPressed: (){
                                    Navigator.pushNamed(context, '/login');
                                  },
                                ),
                              ),
                              SizedBox(width : 20),
                              Expanded(
                                flex: 1,
                                child: TextButton(
                                  child: Text("회원가입", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.lightGreen,
                                  ),
                                  onPressed: (){
                                    //TODO goto 회원가입 page
                                    signInRequest(controllerName.text, controllerPassword.text, controllerNickName.text, controllerEmail.text, selectedRegion);
                                    Navigator.pushNamed(context, '/login');
                                  },
                                ),
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

  void showSnackBar(BuildContext context, String error){
    ScaffoldMessenger.of(context)
        .showSnackBar(
        SnackBar(
          content: Text(error,
            textAlign: TextAlign.center,),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue,));
  }
}

