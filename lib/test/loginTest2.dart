import 'package:flutter/material.dart';
import 'package:test1/test/myButtonTest.dart';

class LogInTest2 extends StatelessWidget {
  const LogInTest2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Sign In',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0.2,
      ),
      body: _buildButton(),
    );
  }
}

Widget _buildButton() {
  return Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MyButtonTest(
          image: Image.asset('assets/test1.PNG', width: 30.0, height: 30.0,),
          text: Text(
            'Login with Naver',
            style: TextStyle(color: Colors.black87, fontSize: 15.0),
          ),
          color: Colors.white,
          radius: 4.0,
          onPressed: (){},
        ),
        SizedBox(
          height: 10.0,
        ),
        MyButtonTest(
          image: Image.asset('assets/test2.PNG', width: 30.0, height: 30.0,),
          text: Text(
            'Login with YouTube',
            style: TextStyle(color: Colors.black87, fontSize: 15.0),
          ),
          color: Colors.white,
          radius: 4.0,
          onPressed: (){},
        ),
        SizedBox(
          height: 10.0,
        ),
        MyButtonTest(
          image: Image.asset('assets/test3.PNG', width: 30.0, height: 30.0,),
          text: Text(
            'Login with Chrome',
            style: TextStyle(color: Colors.black87, fontSize: 15.0),
          ),
          color: Colors.white,
          radius: 4.0,
          onPressed: (){},
        ),
      ],
    ),
  );
}
